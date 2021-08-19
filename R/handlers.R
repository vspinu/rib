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

is_outmsg <- function(msg) {
  identical(class(msg)[[1]], "outmsg")
}

is_inmsg <- function(msg) {
  identical(class(msg)[[1]], "inmsg")
}

#' @param file file to store the output, by default [`stdout()`]
#' @param ts_format format for timestamps
#' @rdname handlers
#' @export
hl_recorder <- function(file = stdout(), type = c("str", "val"), ts_format = TS_FORMAT) {
  type <- match.arg(type)
  function(self, msg) {
    if (self$record) {
      if (type == "str" && is.null(msg[["str"]])) {
        msg <- hl_decode_str(self, msg)
      }
      event <- msg$event
      str <-
        if (type == "str") {
          msg[["str"]]
        } else {
          val <- as.list(msg[["val"]])
          val[["event"]] <- NULL
          gsub("list", "", as.character(list(val)), fixed = TRUE)
        }
      ts <- format.POSIXct(msg$ts, ts_format, usetz = FALSE)
      inout <- if (is_outmsg(msg)) "<-" else "->"
      cat(ts, inout, event, msg$id, str, "\n", file = file, append = TRUE)
    }
    msg
  }
}

#' @rdname handlers
#' @export
hl_record_stdout_str <- hl_recorder(type = "str")

#' @rdname handlers
#' @export
hl_record_stdout_val <- hl_recorder(type = "val")

#' @rdname handlers
#' @export
hl_decode_str <- function(self, msg) {
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

#' @rdname handlers
#' @export
hl_track_requests <- function(self, msg) {
  if (!is.null(msg$val$reqId)) {
    if (is.null(self$requests))
      self$requests <- strenv(parent = self)
    id <- as.character(msg$val$reqId)
    if (is_outmsg(msg)) {
      self$requests[[id]] <- msg
    } else {
      if (grepl("End$", msg$event)) {
        self$requests[[id]] <- NULL
      }
    }
  }
  msg
}
