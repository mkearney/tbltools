
#' Select columns
#'
#' Select columns with non-standard evaluation
#'
#' @param .data Input data frame
#' @param ... Unquoted names of columns to select
#' @export
#' @return Data frame with select columns
select_data <- function(.data, ...) {
  UseMethod("select_data")
}

#' @export
select_data.default <- function(.data, ...) {
  dots <- pretty_dots(...)
  if (length(dots) == 0) {
    return(.data)
  }
  e <- call_env()
  .data <- lapply(dots, function(.x) eval(.x, .data, e))
  structure(
    .data,
    row.names = .set_row_names(length(.data[[1]])),
    class = c("tbl_data", "tbl_df", "tbl", "data.frame")
  )
}

