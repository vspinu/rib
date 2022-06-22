#' IB Handlers
#'
#' When the `TWS` R client receives a message from the `TWS` server, each
#' messaged is processed in turn by the pipeline handlers (`inHandlers` and
#' `outHandlers` argument of [`tws()`] constructor). Handlers are functions that
#' take two arguments - `tws` client object and a message (a list). A handler
#' should modify and return the message. If a handler returns NULL, the message
#' will not be passed to the remaining handlers.
#'
#' @name handlers
#' @param self `TWS` R client object created with [`tws()`] constructor.
#' @param msg a list containing values added by the preceding handlers. The
#'   initial message contains the following element
#'  \describe{
#'    \item{bin}{raw object containing the binary representation of the TWS message}
#'    \item{ts}{timestamp when the message was received by TWS R client}
#' }
#'
NULL

#' @param file
#' @param type
#' @param exclude
#' @param include
#' @param ts_format format for timestamps
#' @rdname handlers
#' @export
bld_recorder <- function(file = stdout(), type = c("val", "str"),
                         exclude = NULL, include = NULL,
                         ts_format = TS_FORMAT) {
  type <- match.arg(type)
  function(self, msg) {
    if (self$record) {
      if (type == "str" && is.null(msg[["str"]])) {
        msg <- hlr_decode_str(self, msg)
      }
      event <- msg$event
      allow <- TRUE
      if (!is.null(exclude))
        allow <- !grepl(exclude, event)
      if (!is.null(include))
        allow <- allow && grepl(include, event)
      if (allow) {
        if (type == "str") {
          str <- msg[["str"]]
        } else {
          val <- as.list(msg[["val"]])
          val[["event"]] <- NULL
          str <- gsub("list", "", as.character(list(val)), fixed = TRUE)
          str <- gsub("\n", " ", str)
        }
        ts <- format.POSIXct(msg$ts, ts_format, usetz = FALSE)
        inout <- if (is_outmsg(msg)) "<-" else "->"
        cat(ts, inout, event, str, "\n", file = file, append = TRUE)
      }
    }
    msg
  }
}

#' @rdname handlers
#' @export
hlr_record_stdout_str <- bld_recorder(type = "str")

#' @rdname handlers
#' @export
hlr_record_stdout_val <- bld_recorder(type = "val")

#' @rdname handlers
#' @export
hlr_decode_str <- function(self, msg) {
  if (is.null(msg[["str"]]) && !is.null(msg[["bin"]])) {
    con <- rawConnection(msg$bin, "rb")
    id <- readBin(con, "character")
    str <- readBin(con, "character", 32)
    while (length(str1 <- readBin(con, "character", 32))) {
      str <- c(str, str1)
    }
    close(con)
    msg[["id"]] <- id
    msg[["event"]] <- ID2EVENT[[id]] %||% "UNKNOWN"
    msg[["str"]] <- str
  }
  msg
}

parse_hist_bar_time <- function(time, format = 2) {
  if (format == 1) {

  } else if (format == 2) {
    if (nchar(time[[1]]) > 7) {
      .POSIXct(as.numeric(time), tz = "UTC")
    } else {
      .Date(as.numeric(time))
    }
  } else if (format == 3) {

  } else {
    time
  }
}

#' @rdname handlers
#' @export
bld_save_history <- function(path = "history",
                             contract_fields = "localSymbol",
                             req_fields = c("barSize", "whatToShow"),
                             partition = c("none", "fields", "hive"),
                             format = c("rds", "parquet"),
                             binder = c("auto", "data.table", "dplyr"),
                             verbose = TRUE,
                             ...) {
  format <- match.arg(format)
  partition <- match.arg(partition)
  binder <- match.arg(binder)

  if (is.null(names(req_fields)))
    names(req_fields) <- req_fields
  if (is.null(names(contract_fields)))
    names(contract_fields) <- contract_fields

  bindfn <-
    if (binder == "auto") {
      if (requireNamespace("data.table", quietly = TRUE)) {
        function(lst) data.table::rbindlist(lst, fill = TRUE)
      } else if (requireNamespace("readr", quietly = TRUE)) {
        function(lst) dplyr::bind_rows(lst)
      } else {
        base::rbind
      }
    }

  cache <- new.env()

  function(self, msg) {

    if (msg$event %in% c("historicalData", "historicalDataEnd")) {

      reqid <- as.character(msg$val$reqId)
      req <- self$requests[[reqid]]$val
      if (is.null(req)) {
        stop(sprintf("No reqHistoricalData request with id %s found. Did you add `hlr_track_requests` outbound handler?", reqid))
      }
      ctr <- req$contract
      cacheid <- paste(c(reqid, req$contract[contract_fields], req[req_fields]), collapse = ":")
      env <- cache[[cacheid]]
      if (is.null(env)) {
        cache[[cacheid]] <- env <- new.env(size = 1e4)
      }

      if (msg$event == "historicalData") {
        bar <- msg$val$bar
        env[[bar$time]] <- bar
      }

      if (msg$event == "historicalDataEnd") {

        cfields <- structure(req$contract[contract_fields], names = names(contract_fields))
        if (any(nulls <- sapply(cfields, is.null))) {
          stop(sprintf("Invalid contract_fields: %s", paste(contract_fields[nulls], collapse = ", ")))
        }
        rfields <- structure(req[req_fields], names = names(req_fields))
        if (any(nulls <- sapply(rfields, is.null))) {
          stop(sprintf("Invalid req_fields: %s", paste(req_fields[nulls], collapse = ", ")))
        }
        fields <- c(cfields, rfields)

        if (partition == "none") {
          dir <- path
        } else if (partition == "fields") {
          loc <- paste(fields, collapse = ":")
          dir <- file.path(path, loc)
        } else {
          els <- as.list(paste(names(fields), fields, sep = "="))
          dir <- do.call(file.path, c(path, els))
        }

        nms <- ls(envir = env)
        if (length(nms) > 0) {

          df <- bindfn(as.list(env))
          if (partition == "none") {
            df <- cbind(as.data.frame(as.list(fields)), df)
          }

          dir <- gsub(" ", "", dir)
          dir.create(dir, showWarnings = FALSE, recursive = TRUE)
          df[["time"]] <- parse_hist_bar_time(df[["time"]])
          file <- sprintf("%s..%s.%s", min(df[["time"]]), max(df[["time"]]), format)
          file <- file.path(dir, file)

          if (format == "rds") {
            saveRDS(df, file, ...)
          } else {
            arrow::write_parquet(df, file, ...)
          }

          if (verbose) {
            tws_handle_inmsg(self, inmsg("save_history", list(N = nrow(df), file = file)))
          }

          rm(list = nms, envir = env)

        }

      }

    }

    msg
  }
}

#' @rdname handlers
#' @export
hlr_track_requests <- function(self, msg) {
  id <- msg$val$reqId %||% msg$val$orderId
  if (!is.null(id)) {
    if (is.null(self$requests))
      self$requests <- strenv(parent = self)
    id <- as.character(id)
    if (is_outmsg(msg)) {
      if (!grepl("^cancel", msg$event))
        self$requests[[id]] <- msg
    } else {
      if (grepl("End$", msg$event) && exists(id, self$requests, inherits = F)) {
        rm(list = id, envir = self$requests)
      }
    }
  }
  msg
}

#' @rdname handlers
#' @export
hlr_process_callbacks <- function(self, msg) {
  if (!is.null(clb <- self$callbacks[[msg$event]])) {
    for (i in seq_along(clb))
      msg <- do.call(clb[[i]], list(self, msg, list(msg$event, i)))
  }
  if (!is.null(msg) && !is.null(id <- msg$val$reqId)) {
    cid <- as.character(id)
    if (!is.null(msg) && !is.null(clb <- self$callbacks[[cid]]))
      msg <- do.call(clb, list(self, msg, cid))
    cid <- paste(msg$event, id, sep = ":")
    if (!is.null(msg) && !is.null(clb <- self$callbacks[[cid]])) {
      msg <- do.call(clb, list(self, msg, cid))
    }
  }
  msg
}
