#' Filter rows
#'
#' Filter rows via integer/numeric position or logical vector
#'
#' @param .data Data frame or two dimensional array
#' @param ... This should evaluate and reduce down to a numeric (row number)
#'   or logical vector. Row numbers higher than what exists in x will be
#'   ignored. Any numeric vector must be either all positive or all negative.
#' @return Sliced/filtered data frame
#' @export
filter_rows <- function(.data, ...) UseMethod("filter_rows")

#' @export
filter_rows.default <- function(.data, ...) {
  if (length(dim(.data)) != 2) {
    stop("filter_rows method requires two-dimensional object", call. = FALSE)
  }
  i <- unlist(lapply(list(...), eval))
  if (length(i) == 0) return(.data)
  if (is.logical(i)) i <- which(i)
  i <- i[i <= nrow(.data)]
  `[`(.data, i, )
}