
#' Slice data
#'
#' Slice data by row number
#'
#' @param .data Input data frame
#' @param ... Expression to evaluate to integer row positions
#' @return .data of evaluated row positions
#' @examples
#'
#' ## data set
#' d <- tbl_data(x = rnorm(10), y = rnorm(10))
#'
#' ## slice first 4 rows
#' slice_data(d, 1:4)
#' @export
slice_data <- function(.data, ...) {
  UseMethod("slice_data")
}

#' @export
slice_data.default <- function(.data, ...) {
  dots <- capture_dots(...)
  if (length(dots) > 1L) {
    stop("slice onlly accepts one expression", call. = FALSE)
  }
  rows <- eval(dots[[1]], .data, call_env())
  rows <- as.integer(rows)
  .data <- .data[rows, ]
  row.names(.data) <- NULL
  .data
}
