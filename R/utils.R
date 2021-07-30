
strenv <- function(..., parent = parent.frame()) {
  structure(list2env(list2(...), parent = parent),
            class = c("strenv", "environment"))
}

strdfenv <- function(..., parent = parent.frame()) {
  structure(list2env(list2(...), parent = parent),
            class = c("strdfenv", "environment"))
}

#' @export
strlist <- function(...) {
  structure(dots_list(...), class = "strlist")
}

#' @export
print.strlist <- function(x, ...) {
  str.strlist(x, ...)
}

#' @export
str.strlist <- function(object, give.attr = F, give.head = F, no.list = T,
                        indent.str = "", nest.lev = 0, vec.len = 20, ...) {
  cat(indent.str, "[", paste(class(object), collapse = " "), "] ", sep = "")
  str(unclass(object), give.attr = give.attr, give.head = F, nest.lev = nest.lev,
      no.list = no.list, vec.len = vec.len, ...)
}

as_strlist <- function(x) structure(as.list(x), class = "strlist")

#' @export
str.strenv <- function(object, give.attr = F, give.head = F, no.list = T,
                       indent.str = "", nest.lev = 0, ...) {
  cat("[strenv] ")
  obj <- as.list(object, all.names = T)
  str(obj, give.attr = give.attr, give.head = F, nest.lev = nest.lev,  no.list = no.list, ...)
}

stdfenv2dt <- function(x) {
  dt <- suppressWarnings(rbindlist(as.list(x, all.names = T), fill = T, idcol = "key")) %>%
    discard_empty_cols()
  if (is.null(attr(x, "key"))) {
    if (!is.null(dt$timestamp))
      setkey(dt, timestamp)
  } else {
    setkey(dt, attr(x, "key"))
  }
  dt
}

#' @export
print.strdfenv <- function(x, ...) {
  print(strdf2dt(x), ...)
}

#' @export
str.stdfrenv <- function(object, give.attr = F, give.head = F, no.list = T,
                         indent.str = "", nest.lev = 0, ...) {
  cat("[stdfrenv] ")
  str(strdf2dt(object), give.attr = give.attr, give.head = F, nest.lev = nest.lev,  no.list = no.list, ...)
}

catlog <- function(..., .env = parent.frame(), ts_format = TS_FORMAT) {
  str <- paste(..., collapse = "", sep = "")
  str <- paste(glue(str, .envir = .env), collapse = " ")
  ts <- format.POSIXct(Sys.time(), format = ts_format, usetz = FALSE)
  cat(glue("{ts} {str}"), "\n")
}


decode_bin_msg <- function(bin) {
  con <- rawConnection(bin, "rb")
  on.exit(close(con))
  len <- readBin(con, "integer", 1, endian = "big")
  id <- readBin(con, "character")
  str <- readBin(con, "character", 32)
  while (length(str1 <- readBin(con, "character", 32))) {
    str <- c(str, str1)
  }
  strlist(bin = bin, len = len, id = id, str = str)
}
