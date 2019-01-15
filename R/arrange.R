#' Arrange rows
#'
#' Arrange rows via descending or ascending column values
#'
#' @param .data data frame
#' @param ... One or more unquoted names of columns on which to arrange the rows. If none
#'   are supplied, the data are returned as is. By default, ordering is done in ascending
#'   order. To orer in descending order, use \code{\link{decr}} on desired variable(s).
#' @return Rearranged data frame
#' @examples
#'
#' ## data frame to arrange
#' dat <- data.frame(
#'   a = c(rep("a", 3), rep("b", 3), rep("c", 4)),
#'   b = c( 3, 3, 2,     8, 8, 1,     5,  5, 5, 9),
#'   c = c(-1, 0, 0,    -5, 0, 2,    -2, -4, 1, 0),
#'   stringsAsFactors = FALSE
#' )
#'
#' ## arrange by one column
#' arrange_data(dat, a)
#'
#' ## arrange by multiple columns
#' arrange_data(dat, decr(a), b, c)
#'
#' @export
arrange_data <- function(.data, ...) {
  UseMethod("arrange_data")
}

#' @export
arrange_data.default <- function(.data, ...) {
  dots <- capture_dots(...)

  ## if no columns supplied, return .data
  if (length(dots) == 0) {
    return(.data)
  }

  ## order the data with relevant columns selected
  .order_data <- select_data(.data, ...)
  row_names <- do.call(base::order, c(as.list(.order_data)))

  ## reorganize using ordered row_names
  .data <- .data[row_names, ]

  ## reset row names
  row.names(.data) <- NULL

  ## return data
  .data
}

