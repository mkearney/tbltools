#' Pull data
#'
#' Pull (extract) data from a data frame
#'
#' @param .data Input data frame
#' @param ... Unquoted name of column to pull from data frame
#' @return A column pulled from its data frame (inheriting whatever class the
#'   column is)
#' @examples
#'
#' ## pull the 'y' variable from the data frame
#' tbl_data(x = rnorm(5), y = letters[1:5]) %>% pull_data(y)
#'
#' @export
pull_data <- function(.data, ...) {
  UseMethod("pull_data")
}

#' @export
pull_data.default <- function(.data, ...) {
  eval(capture_dots(...)[[1]], .data, new.env(parent = emptyenv()))
}
