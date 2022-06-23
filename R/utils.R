
#' @export
strenv <- function(..., parent = parent.frame()) {
  structure(list2env(list2(...), parent = parent),
            class = c("strenv", "environment"))
}

#' @export
strenvdf <- function(..., parent = parent.frame()) {
  structure(list2env(list2(...), parent = parent),
            class = c("strenvdf", "environment"))
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
                        digits.d = getOption("digits", 6),
                        indent.str = "", nest.lev = 0, vec.len = 20, ...) {
  cat("[", paste(class(object), collapse = " "), "]\n", sep = "")
  str(unclass(object), give.attr = give.attr, give.head = F, nest.lev = nest.lev,
      digits.d = digits.d, no.list = no.list, vec.len = vec.len, ...)
}

as_strlist <- function(x) structure(as.list(x), class = "strlist")

#' @export
str.strenv <- function(object, give.attr = F, give.head = F, no.list = T,
                       digits.d = getOption("digits", 6),
                       indent.str = "", nest.lev = 0, ...) {
  cat("[", paste(class(object), collapse = " "), "]\n", sep = "")
  obj <- as.list(object, all.names = T)
  str(obj, give.attr = give.attr, give.head = F,
      digits.d = digits.d, nest.lev = nest.lev,  no.list = no.list, ...)
}

#' @export
as.data.frame.strenv <- function(x, ...) {
  do.call("rbind", as.list(x))
}

#' @export
as.data.table.strenv <- function(x, ...) {
    if (requireNamespace("data.table", quietly = TRUE)) {
      data.table::rbindlist(as.list(x), fill = TRUE)
    } else {
      do.call("rbind", as.list(x), ...)
    }
}

#' @export
print.strenv <- function(x, ...) {
  str.strenv(x)
}

strenvdf2dt <- function(x) {
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
print.strenvdf <- function(x, ...) {
  print(strenvdf2dt(x), ...)
}

#' @export
str.strenvdf <- function(object, give.attr = F, give.head = F, no.list = T,
                         indent.str = "", nest.lev = 0, ...) {
  cat("[strenvdf] ")
  str(strenvdf2dt(object), give.attr = give.attr, give.head = F, nest.lev = nest.lev,  no.list = no.list, ...)
}

catlog <- function(..., .env = parent.frame(), ts_format = TS_FORMAT) {
  str <- paste(..., collapse = "", sep = "")
  str <- paste(glue(str, .envir = .env), collapse = " ")
  ts <- format.POSIXct(Sys.time(), format = ts_format, usetz = FALSE)
  cat(glue("{ts} {str}"), "\n")
}


decode_str_msg <- function(bin) {
  con <- rawConnection(bin, "rb")
  on.exit(close(con))
  str <- readBin(con, "character", 32)
  while (length(str1 <- readBin(con, "character", 32))) {
    str <- c(str, str1)
  }
  str
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

stopif <- function (...) {
  n <- length(ll <- list(...))
  if (n == 0L)
    return(invisible())
  mc <- match.call()
  for (i in 1L:n)
    if (!is.logical(r <- ll[[i]]) || anyNA(r) || any(r)) {
      ch <- deparse(mc[[i + 1]], width.cutoff = 60L)
      if (length(ch) > 1L)
        ch <- paste(ch[1L], "....")
      stop(sprintf("%s is TRUE", ch), call. = FALSE, domain = NA)
    }
  invisible()
}
