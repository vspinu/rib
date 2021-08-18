#' @include encoder.R utils.R
NULL

#' @export
tws <- function(host = "localhost",
                port = c("gwpaper", "gwprod", "twspaper", "twsprod"),
                inHandlers = "hl_record_stdout_val",
                outHandlers = "hl_record_stdout_val",
                ...) {
  if (is.character(port)) {
    port <- match.arg(port)
    port <- c("gwpaper" = 4002, "gwprod" = 4001,
              "twspaper" = 7497, "twsprod" = 7496)[[port]]
  }
  TWS$new(inHandlers = inHandlers, outHandlers = outHandlers,
          host = host, port = port, ...)
}

TWS <-
  R6Class("TWS",
          lock_objects = FALSE,

          private = list(
            nextValidId = as.integer(Sys.time())
          ), 
          
          public = list2(
            clientId = 1,
            host = "localhost",
            port = 4002, 
            inHandlers = NULL,
            outHandlers = NULL,
            
            data = strlist(),
            record = TRUE,

            requests = strenv(),
            reqval = function(reqId) {
              self$requests[[as.character(reqId)]]$val
            }, 

            initialize = function(inHandlers, outHandlers, ...) {
              if (is.function(inHandlers))
                inHandlers <- list(inHandlers)
              if (is.function(outHandlers))
                outHandlers <- list(outHandlers)
              self$inHandlers <- inHandlers
              self$outHandlers <- outHandlers
              list2env(list2(...), self)
            },

            nextId = function() {
              id <- private$nextValidId + 1L
              private$nextValidId <- id
              id
            }, 

            open = function(clientId = self$clientId, host = self$host,
                            port = self$port, timeout = 5, read_interval = .1) {
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

            !!!REQ_FUNCTIONS
          ))

tws_process_msgs <- function(self, read_interval = .1) {
  con <- self$con
  withCallingHandlers(
    if (read_interval == 0) {
      while (self$isOpen()) {
        if (!socketSelect(list(con), FALSE, 0.25))
          next
        tws_handle_inmsg(self)
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
      while (self$isOpen() && tws_handle_inmsg(self)) {
      }
      if (self$isOpen())
        later::later(executor, delay = read_interval)
    }
  executor()
}

tws_handle_inmsg <- function(self) {
  withCallingHandlers({
    bin <- read_bin(self$con)
    if (!is.null(bin)) {
      vals <- C_decode_bin(self$serverVersion, bin)
      ix <- 1L
      for (val in vals) {
        msg <- structure(list(ts = .POSIXct(Sys.time(), tz = "UTC"),
                              ix = ix,
                              bin = bin,
                              event = val[["event"]], 
                              val = val),
                         class = c("inmsg", "strlist"))
        for (hl in self$inHandlers) {
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

tws_handle_outmsg <- function(self, event, encoder, val) {
  withCallingHandlers({
    if (length(self$outHandlers) > 0) {
      msg <- structure(list(ts = .POSIXct(Sys.time(), tz = "UTC"),
                            event = event,
                            val = val),
                       class = c("outmsg", "strlist"))
      for (hl in self$outHandlers) {
        msg <- do.call(hl, list(self, msg))
        if (is.null(msg)) break
      }
      if (!is.null(msg)) {
        bin <- do.call(encoder, c(self, msg$val))
      }
    } else {
      bin <- do.call(encoder, c(self, val))
    }
    writeBin(bin, self$con)
  }, 
  error = function(err) {
    print(rlang::trace_back())
    stop(err)
  })
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
  on.exit(self$close())

  if (!self$isOpen()) { 
    stop(sprintf("couldn't connect to TWS on '%s:%s'", host, port))
  }

  Sys.sleep(0.2)

  clientVersion <- C_max_client_version()
  encoder <- encoder()
  writeBin(C_enc_connectionRequest(encoder), con)

  # server version and connection time
  while (TRUE) {
    if (socketSelect(list(con), FALSE, 0.1)) {
      bin <- read_bin(con)
      if (!is.null(bin)) {
        tryCatch({
          bincon <- rawConnection(bin, "rb")
          serverVersion <- as.integer(readBin(bincon, "character"))
          C_set_serverVersion(encoder, serverVersion)
          catlog("Connected client:{clientId}v{clientVersion}, server:v{serverVersion}")
        }, finally =
             base::close(bincon))
        break
      }
    }
    if (Sys.time() - start_time > timeout) {
      self$close()
      stop('TWS connection timed-out')
    }
  }

  on.exit()

  self$encoder <- encoder
  self$clientId <- clientId
  self$clientVersion <- clientVersion
  self$serverVersion <- serverVersion
  self$optionalCapabilities <- optionalCapabilities
  self$host <- host
  self$port <- port

  if (base::isOpen(con)) {
    writeBin(C_enc_startApi(encoder, clientId, optionalCapabilities), con)
  }

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



### Connection read-write

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
