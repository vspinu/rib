#' @include client.R utils.R
NULL

#' @export
tws <- function(host = "localhost",
                port = c("gwpaper", "gwlive", "twspaper", "twslive"),
                inHandlers = "hl_record_stdout_val",
                outHandlers = "hl_record_stdout_val",
                ...) {
  if (is.character(port)) {
    port <- match.arg(port)
    port <- c("gwpaper" = 4002, "gwlive" = 4001,
              "twspaper" = 7497, "twslive" = 7496)[[port]]
  }
  TWS$new(inHandlers = inHandlers, outHandlers = outHandlers,
          host = host, port = port, ...)
}

TWS <-
  R6Class("TWS",
          lock_objects = FALSE,
          cloneable = FALSE,
          private = list(
            finalize = function() {
              later::destroy_loop(private$loop)
            }
          ),

          public = list2(
            ## id = function() {
            ##   address(self)
            ## },

            clientId = 1,
            host = "localhost",
            port = 4002,
            inHandlers = NULL,
            outHandlers = NULL,

            data = strlist(),
            record = TRUE,

            requests = strenv(),
            callbacks = strenv(),
            reqval = function(reqId) {
              self$requests[[as.character(reqId)]]$val
            },

            initialize = function(inHandlers, outHandlers, ...) {
              private$nextValidId <- as.integer(Sys.time())
              private$laterCancelers <- strenv()
              if (is.function(inHandlers))
                inHandlers <- list(inHandlers)
              if (is.function(outHandlers))
                outHandlers <- list(outHandlers)
              self$inHandlers <- inHandlers
              self$outHandlers <- outHandlers
              new_objects <- dots_list(..., .ignore_empty = "all", .named = TRUE)
              funcs <- sapply(new_objects, is.function)
              list2env(new_objects, self)
              for (nm in names(new_objects)[funcs]) {
                environment(self[[nm]]) <- self$.__enclos_env__
              }
            },

            doLater = function(fn, delay = 0, id = NULL) {
              stopifnot(delay > 0)
              fn <- rlang::as_function(fn)
              formals(fn) <- alist(self = )

              remove_canceler <- !is.null(id)
              if (!is.null(id)) {
                id <- as.character(id)
                cl <- private$laterCancelers[[id]]
                if (!is.null(cl)) {
                  cl()
                }
              }

              .fn <-
                function() {
                  if (remove_canceler)
                    rm(list = id, envir = private$laterCancelers)
                  withCallingHandlers({
                    fn(self)
                  },
                  error = function(err) {
                    print(rlang::trace_back())
                    dmp_name <- paste0("dmp", self$clientId, "_", COUNTERS[["error"]])
                    COUNTERS[["error"]] <- COUNTERS[["error"]] + 1
                    dump.frames(dmp_name)
                    cat(sprintf("Error frames dumped to `%s` in GlobalEnv\n", dmp_name))
                    cat("ERROR:", err$message, "\n")
                  })
                }
              cl <- later::later(.fn, delay = delay, loop = private$loop)
              if (!is.null(id))
                private$laterCancelers[[id]] <- cl
              invisible(cl)
            },

            doRepeat = function(fn, interval = 0, id = NULL) {
              stopifnot(interval > 0)
              fn <- rlang::as_function(fn)
              formals(fn) <- alist(self = )
              if (!is.null(id)) {
                cl <- private$laterCancelers[[id]]
                if (!is.null(cl))
                  cl()
              }

              cl <- NULL
              .fn <-
                function() {
                  if (!is.null(cl)) {
                    cl()
                    withCallingHandlers({
                      fn(self)
                    },
                    error = function(err) {
                      print(rlang::trace_back())
                      dmp_name <- paste0("dmp", self$clientId, "_", COUNTERS[["error"]])
                      COUNTERS[["error"]] <- COUNTERS[["error"]] + 1
                      dump.frames(dmp_name)
                      cat(sprintf("Error frames dumped to `%s` in GlobalEnv\n", dmp_name))
                      cat("ERROR:", err$message, "\n")
                    })
                  }
                  cl <<- later::later(.fn, delay = interval, loop = private$loop)
                  if (!is.null(id))
                    private$laterCancelers[[id]] <- cl
                  cl
                }
              invisible(.fn())
            },

            async = function(fn, ..., auto_remove = NULL) {
              async_impl(self, fn, ..., reqId = NULL, auto_remove = auto_remove)
            },

            asyncid = function(fn, ..., reqId = self$nextId(), auto_remove = NULL) {
              async_impl(self, fn, ..., reqId = reqId, auto_remove = auto_remove)
            },

            addCallback = function(callback, event = NULL, reqId = self$nextId()) {
              if (is.null(event) && is.null(reqId))
                stop("At least one of `event` and `reqId` must be non-null")
              cid <- if (is.null(event)) as.character(reqId)
                     else if (is.null(reqId)) list(event, length(self$callbacks[[event]]) + 1)
                     else paste(event, reqId, sep = ":")
              if (is.list(cid))
                self$callbacks[[cid[[1]]]][[cid[[2]]]] <- callback
              else
                self$callbacks[[cid]] <- callback
              reqId
            },

            rmCallback = function(cid) {
              if (is.character(cid))
                rm(list = cid, envir = self$callbacks, inherits = FALSE)
              else if (is.list(cid)) {
                self$callbacks[[cid[[1]]]][[cid[[2]]]] <- NULL
              } else {
                stop(sprintf("`cid` must be either a string or a list with two elements. Supplied %s", deparse(cid)), call. = F)
              }
              NULL
            },

            nextId = function() {
              id <- private$nextValidId + 1L
              private$nextValidId <- id
              id
            },

            open = function(clientId = self$clientId, host = self$host,
                            port = self$port, timeout = 5, read_interval = .1) {
              private$loop <- later::create_loop()
              tws_connect(self, clientId, host = host, port = port, timeout = timeout)
              tws_process_msgs(self, read_interval = read_interval)
            },

            close = function() {
              later::destroy_loop(private$loop)
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



## -- MSG Handling --

tws_process_msgs <- function(self, read_interval = .1) {
  con <- self$con
  withCallingHandlers(
    if (read_interval == 0) {
      while (self$isOpen()) {
        if (!socketSelect(list(con), FALSE, 0.25))
          next
        tws_read_handle_inmsg(self)
      }
    } else {
      tws_later_scheduler(self, read_interval)
    },
    error = function(err) {
      try(close(self$con))
      abort(sprintf("%s (Closing connection)", err$message), parent = err)
    })
}

tws_later_scheduler <- function(self, read_interval = .1) {
  ## cat("scheduler:", address(self), "\n")
  loop <- self$.__enclos_env__$private$loop
  executor <-
    function() {
      while (self$isOpen() && tws_read_handle_inmsg(self)) {}
      if (self$isOpen() && later::exists_loop(loop))
        later::later(executor, delay = read_interval, loop = loop)
    }
  self$executor <- executor
  executor()
}

inmsg <- function(event, val, ix = 1L, bin = NULL) {
  structure(list(id = next_id(),
                 ts = .POSIXct(Sys.time(), tz = "UTC"),
                 ix = ix,
                 bin = bin,
                 event = event,
                 val = val),
            class = c("inmsg", "strlist"))
}

outmsg <- function(event, val) {
  structure(list(ts = .POSIXct(Sys.time(), tz = "UTC"),
                 event = event,
                 val = val),
            class = c("outmsg", "strlist"))
}

is_outmsg <- function(msg) {
  identical(class(msg)[[1]], "outmsg")
}

is_inmsg <- function(msg) {
  identical(class(msg)[[1]], "inmsg")
}

tws_read_handle_inmsg <- function(self) {
  bin <- read_bin(self$con)
  if (is.null(bin)) {
    FALSE
  } else {
    vals <- C_decode_bin(self$serverVersion, bin)
    ix <- 1L
    for (val in vals) {
      msg <- inmsg(val[["event"]], val, ix, bin)
      tws_handle_inmsg(self, msg)
      ix <- ix + 1L
    }
    TRUE
  }
}

tws_handle_inmsg <- function(self, msg) {
  withCallingHandlers(
    for (hl in self$inHandlers) {
      stopif(is.null(msg))
      msg <- do.call(hl, list(self, msg))
      if (is.null(msg)) break
    },
    error = function(err) {
      print(rlang::trace_back())
      msg_name <- paste0("msg", self$clientId, "_", COUNTERS[["error"]])
      dmp_name <- paste0("dmp", self$clientId, "_", COUNTERS[["error"]])
      COUNTERS[["error"]] <- COUNTERS[["error"]] + 1
      assign(msg_name, msg, envir = .GlobalEnv)
      dump.frames(dmp_name)
      cat(sprintf("Error frames dumped to `%s` in GlobalEnv\n", dmp_name))
      cat(sprintf("Inbound message (bound to `%s` in GlobalEnv):\n", msg_name))
      cat("ERROR:", err$message, "\n")
      str(msg)
      self$close()
      cat("Closing connection", "\n")
    })
}

tws_handle_outmsg <- function(self, event, encoder, val) {
  withCallingHandlers({
    if (length(self$outHandlers) > 0) {
      msg <- outmsg(event, val)
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
    # by now connection can be close and we get an "invalid connection" error
    if (self$isOpen())
      writeBin(bin, self$con)
  },
  error = function(err) {
    print(rlang::trace_back())
    stop(err)
  })
}





### -- Connection --

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



### Utils
async_impl <- function(self, fn, ..., reqId = self$nextId(), auto_remove = NULL) {
  callbacks <- dots_list(..., .named = TRUE, .ignore_empty = "all")
  for (nm in names(callbacks)) {
    if (!nm %in% names(EVENT2ID))
      stop(sprintf("Invalid TWS event `%s` for callback", nm))
    cl <- callbacks[[nm]]
    .f <- rlang::as_function(cl)
    if (is.language(cl))
      formals(.f) <- rlang::pairlist2(self = , msg = , cid = )
    if ((is.logical(auto_remove) && auto_remove) ||
        (is.null(auto_remove) && grepl("End$", nm))) {
      body <- body(.f)
      do_end <- is.symbol(body) ||
        !identical(body[[1]], as.symbol("{")) ||
        !identical(body[[length(body)]], as.symbol("msg"))

      body(.f) <- rlang::expr({
        self$rmCallback(cid)
        !!body(.f)
        !!!(if (do_end) list(NULL))
      })
    }
    self$addCallback(.f, nm, reqId = reqId)
  }
  fn <- rlang::as_function(fn)
  formals(fn) <- rlang::pairlist2(self = , reqId = )
  fn(self, reqId)
}
