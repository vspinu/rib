#' IB Handlers
#'
#' When the `TWS` R client receives a message from the `TWS` server, each
#' messaged is processed in turn by the handlers in the handler pipeline
#' (`handlers` argument of [`tws()`] function). Handlers are functions that take
#' two arguments - `TWS` R client object and a message. A handler should modify
#' and return the message. If a handler return NULL, the message is not passed
#' to the remaining handlers.
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


#' @param file file to store the output, by default [`stdout()`]
#' @param ts_format format for timestamps
#' @rdname handlers
#' @export
hl_recorder <- function(file = stdout(), type = c("str", "val"), ts_format = TS_FORMAT) {
  type <- match.arg(type)
  function(self, msg, ...) {
    if (self$record) {
      if (type == "str" && is.null(msg[["str"]])) {
        msg <- hl_decode_str(self, msg, ...)
      }
      event <- msg$event
      if (identical(event, "error"))
        event <- if (msg[["val"]][["reqId"]] == -1) "INFO" else "ERROR"
      str <-
        if (type == "str") msg[["str"]]
        else gsub("list", "", as.character(list(msg[["val"]])), fixed = TRUE)
      ts <- format.POSIXct(msg$ts, ts_format, usetz = FALSE)
      cat(ts, event, msg$id, str, "\n", file = file, append = TRUE)
    }
    msg
  }
}

#' @rdname handlers
#' @export
hl_record_stdout <- hl_recorder()

#' @rdname handlers
#' @export
hl_decode_str <- function(self, msg, ...) {
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

## #' @rdname handlers
## #' @export
## hl_decode_val <- function(self, msg, ...) {
##   if (is.null(msg[["val"]])) {
##     val <- C_decode_bin(self$serverVersion, msg[["bin"]])
##     msg[["event"]] <- val[["event"]]
##     msg[["val"]] <- val
##   }
##   msg
## }

