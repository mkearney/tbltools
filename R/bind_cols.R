#' Bind columns
#'
#' Bind together the columns of two or more data frames.
#'
#' @param ... Data frames
#' @return Single data frame with combined columns
#' @export
bind_cols_data <- function(...) {
  dots <- peel_list_alist(list(...))
  as_tbl_data(do.call(base::cbind, dots, quote = FALSE))
}
