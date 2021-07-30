#' @include encoder.R decoder.R utils.R
NULL

#' @export
tws <- function(symbols = "EURUSD",
                handlers = "hl_record_stdout",
                host = "localhost", port = 4002,
                ...) {
  TWS$new(symbols = symbols, handlers = handlers,
          host = host, port = port, ...)
}

TWS <-
  R6Class("TWS",
          lock_objects = FALSE,

          private = list(
            nextValidId = as.integer(Sys.time())
          ), 
          
          public = list2(
            clientId = 123,
            host = "localhost",
            port = 4002,
            tws = NULL, 
            handlers = NULL,
            
            data = strlist(),
            record = TRUE,

            initialize = function(handlers, ...) {
              if (is.function(handlers))
                handlers <- list(handlers)
              self$handlers <- handlers
              list2env(list2(...), self)
            },

            nextId = function() {
              id <- private$nextValidId + 1L
              private$nextValidId <- id
              id
            }, 

            open = function(clientId = self$clientId, host = self$host, port = self$port, timeout = 5, read_interval = .1) {
              tws_connect(self, clientId, host = host, port = port, timeout = timeout)
              tws_process_msgs(self, read_interval = read_interval)
            }, 

            close = function() {
              if (self$isOpen()) {
                try({
                  base::close(self$con)
                  catlog("Disconnected client:{self$clientId} {self$host}:{self$port}")
                  }, silent = T)
              }
            }, 

            isOpen = function() {
              if (is.null(self$con))
                return(FALSE)
              tryCatch(base::isOpen(self$con), error = function(e) FALSE)
            },

            !!!ENC_FUNCTIONS
          ))

tws_process_msgs <- function(self, read_interval = .1) {
  con <- self$con
  withCallingHandlers(
    if (read_interval == 0) {
      while (self$isOpen()) {
        if (!socketSelect(list(con), FALSE, 0.25))
          next
        tws_handle_msg(self)
      }
    } else {
      tws_later_scheduler(self, read_interval)
    },
    error = function(err) {
      close(self$con)
      abort(glue("{err$message} (Closing connection)"), parent = err)
    })
}

tws_later_scheduler <- function(self, read_interval = .1) {
  executor <-
    function() {
      while (self$isOpen() && tws_handle_msg(self)) {
      }
      if (self$isOpen())
        later::later(executor, delay = read_interval)
    }
  executor()
}

tws_handle_msg <- function(self) {
  withCallingHandlers({
    bin <- read_bin(self$con)
    if (!is.null(bin)) {
      vals <- C_decode_bin(self$twsServerVersion,  bin)
      ix <- 1L
      for (val in vals) {
        msg <- msg(bin, val, ix)
        for (hl in self$handlers) {
          msg <- do.call(hl, list(self, msg))
          if (is.null(msg)) break
        }
        ix <- ix + 1L
        bin <- NULL ## only on first decoded value we send bin
      }
    }
  },
  error = function(err) {
    print(rlang::trace_back())
    stop(err)
  })
  !is.null(bin)
}

tws_connect <- function(self, clientId = 1, host = 'localhost', port = 7496,
                        optionalCapabilities = "", timeout = 5,
                        blocking = .Platform$OS.type == "windows") {

  if (is.null(getOption('digits.secs'))) 
    options(digits.secs = 6)

  if (self$isOpen())
    self$close()

  start_time <- Sys.time()
  con <- socketConnection(host = host, port = port, open = 'ab', blocking = blocking)
  self$con <- con
  on.exit(self$close(con))

  if (!self$isOpen()) { 
    self$close()
    stop(sprintf("couldn't connect to TWS on '%s:%s'", host, port))
  }

  Sys.sleep(0.2)

  client_version <- min(161, C_max_client_version())
  binversion <- charToRaw(paste0("v100..", client_version))
  writeBin(c(charToRaw("API"), NULLSTR,
             bytelen(binversion),
             binversion),
           con)

  # server version and connection time
  while (TRUE) {
    if (socketSelect(list(con), FALSE, 0.1)) {
      bin <- read_bin(con)
      if (!is.null(bin)) {
        msg <- hl_decode_str(self, msg(bin))
        server_version <- as.integer(msg[["id"]])
        connection_time <- msg[["str"]]
        catlog("Connected client:{clientId}v{client_version}, server:v{server_version}")
        break
      }
    }
    if (Sys.time() - start_time > timeout) {
      self$close()
      stop('TWS connection timed-out')
    }
  }

  on.exit()

  ## ## temporary
  ## tws <- structure(new.env(), class = c("twsconn", "environment"))
  ## tws$conn <- con
  ## tws$clientId <- clientId
  ## tws$nextValidId <- "1"
  ## tws$port <- port
  ## tws$server.version <- server_version
  ## tws$connected.at <- connection_time
  ## self$tws <- tws
  
  self$clientId <- clientId
  self$twsClientVersion <- client_version
  self$twsServerVersion <- server_version
  self$host <- host
  self$port <- port

  if (base::isOpen(con))
    write_str(c(REQ2ID[["START_API"]], "2", clientId, optionalCapabilities), con)

  self
}

tws_handle_connection_error <- function(con) {
  err <- readBin(con, "character", 4)
  if(as.numeric(err[3]) > 1000) {
    warning(err[4])
    TRUE
  } else {
    close(con)
    stop(err[4])
  }
}



### Connection reader/writer

bytelen <- function(x) {
  as.raw(bitwShiftR(length(x), c(24, 16, 8, 0)))
}

read_bin <- function(con) {
  on.exit({
    base::close(con)
    stop("Incomplete message read. (Closing connection) ")
  })
  rem <- len <- readBin(con, "integer", endian = "big")
  out <- NULL
  if (length(rem)) {
    while (rem > 0) {
      out <- c(out, readBin(con, "raw", rem))
      rem <- len - length(out)
    }
  }
  on.exit()
  out
}

write_str <- function(str, con) {
  if (base::isOpen(con)) {
    raw <- do.call(c, lapply(as.character(str),
                             function(s) c(charToRaw(s), NULLSTR)))
    writeBin(bytelen(raw), con)
    writeBin(raw, con)
  }
}

msg <- function(bin, val = NULL, ix = 1L) {
  list(ts = .POSIXct(Sys.time(), tz = "UTC"),
       ix = ix,
       bin = bin,
       event = val[["event"]], 
       val = val)
}
