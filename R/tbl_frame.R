#' Create tbl_data_frame
#'
#' Creates a data frame using non-standard evaluation
#'
#' @param ... Column vectors or expressions that reduce down to desired column vectors of
#'   data frame
#' @export
#' @examples
#'
#' ## create data frame with two random variables
#' tbl_data_frame(
#'   a = rnorm(10),
#'   b = rnorm(10)
#' )
#'
#' ## create variables calculated using previous variables
#' tbl_data_frame(
#'   a = rnorm(10),
#'   b = rnorm(10),
#'   c = (a + b) / 2,
#'   d = a + b + c
#' )
#'
#' @return A tbl_data data frame
tbl_data_frame <- function(...) {
  UseMethod("tbl_data_frame")
}

#' @export
tbl_data_frame <- function(...) {
  dots <- pretty_dots(...)
  vars <- names(dots)
  e <- call_env()
  for (i in vars) {
    dots[[i]] <- eval(dots[[i]], dots, e)
  }
  as_tbl_data(dots)
}
