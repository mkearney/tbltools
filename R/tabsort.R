
#' tabsort
#'
#' Returns a sorted (descending) frequency tbl
#'
#' @param data Data
#' @param ... Unquoted column names of variables to include in table. Default
#'   is to use all columns.
#' @param prop Logical indicating whether to include a proportion of total
#'   obs column.
#' @param sort Logical indicating whether to sort the returned object.
#' @param na_omit Logical indicating whether to exclude missing. If all
#'   responses are missing, a missing value is used as the single category.
#' @return Frequency tbl
#' @export
tabsort <- function(data, ..., prop = TRUE, na_omit = TRUE, sort = TRUE) {
  vars <- names(rlang::enquos(...))
  if (missing(data)) {
    data <- data.frame(..., stringsAsFactors = FALSE)
  } else if (!is.recursive(data) && length(vars) > 0) {
    tnames <- c(letters[c(24:26, 1:23)], paste0(letters[c(24:26, 1:23)], "2"))
    data <- structure(list(data, ...), class = "list", names = tnames[seq_len(length(list(data, ...)))])
  } else if (!is.recursive(data)) {
    data <- data.frame(x = data, stringsAsFactors = FALSE)
  } else {
    data <- tidyselector(data, ...)
  }
  if (na_omit) {
    data <- tfse::na_omit(data)
  }
  x <- as_tbl(do.call("table", data))
  if (prop) {
    x$prop <- x$n / sum(x$n, na.rm = TRUE)
  }
  if (sort) {
    x <- x[order(x$n, decreasing = TRUE), ]
  }
  x
}


#' @inheritParams tabsort
#' @rdname tabsort
#' @export
ntbl <- function(data, ...) {
  data <- rlang::with_env(data, tidyselector(data, ...))
  as_tbl(table(data))
}
