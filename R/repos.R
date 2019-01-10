
#' move vars to front
#'
#' @param data data frame
#' @param ... columns to move to front
#' @export
#' @examples
#' ## data with row names
#' d <- data.frame(x = rnorm(5), y = rnorm(5), row.names = letters[1:5])
#'
#' ## move y to front
#' repos_front(d, y)
#'
#' @return Reordered data frame.
repos_front <- function(data, ...) {
  re <- select_cols(data, ...)
  as_tbl(cbind(re, data[!names(data) %in% names(re)]))
}

#' move vars to back
#'
#' @param data data frame
#' @param ... columns to move to back
#' @export
#' @examples
#' ## data with row names
#' d <- data.frame(x = rnorm(5), y = rnorm(5), row.names = letters[1:5])
#'
#' ## move x to back
#' repos_back(d, x)
#'
#' @return Reordered data frame.
repos_back <- function(data, ...) {
  re <- select_cols(data, ...)
  as_tbl(cbind(data[!names(data) %in% names(re)], re))
}
