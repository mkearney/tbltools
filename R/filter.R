#' Filter rows
#'
#' Filter rows via integer/numeric position or logical vector
#'
#' @param .data Data frame or two dimensional array
#' @param ... Each argument/expression should should evaluate and reduce down to
#'   an integer (row number) or logical vector. The filter will keep all row
#'   numbers that appear in all evaluated expressions (commas are the equivalent
#'   to \code{&}. Row numbers higher than what exists in x will be ignored. Any
#'   numeric vector must be either all positive or all negative (excludes). This
#'   function uses non-standard evaluation–users can refer to column names
#'   without quotations.
#' @return Sliced/filtered data frame
#' @examples
#' set.seed(12)
#' d <- data.frame(
#'   mpg = rnorm(100, 25, 3),
#'   gear = sample(3:6, 100, replace = TRUE),
#'   vs = sample(0:1, 100, replace = TRUE),
#'   stringsAsFactors = FALSE
#' )
#'
#' filter_rows(d, mpg > 30)
#' filter_rows(d, !mpg < 30)
#' filter_rows(d, mpg > 30, !mpg < 30)
#' filter_rows(d, mpg > 30, gear == 4)
#' filter_rows(d, mpg > 30 | gear == 4, vs == 1)
#'
#' @export
filter_rows <- function(.data, ...) UseMethod("filter_rows")

#' @export
filter_rows.default <- function(.data, ...) {
  if (length(dim(.data)) != 2) {
    stop("filter_rows method requires two-dimensional object", call. = FALSE)
  }
  dots <- capture_dots(...)
  e <- call_env()
  i <- lapply(dots, function(.x) {
    o <- eval(.x, .data, e)
    if (is.logical(o)) o <- which(o)
    o
  })
  it <- table(unlist(i))
  i <- as.integer(names(it[it == length(i)]))
  if (length(i) == 0) return(.data)
  if (is.logical(i)) i <- which(i)
  i <- i[i <= nrow(.data)]
  .data <- `[`(.data, i, )
  row.names(.data) <- NULL
  .data
}
