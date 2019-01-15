#' Summarise data
#'
#' Returns a summary-level data frame
#'
#' @param .data Data frame
#' @param ... One or more namecd expressions evaluating with non-standard evaluation
#'   to a single summary value.
#' @return A summary-level data frame
#' @export
summarise_data <- function(.data, ...) {
  UseMethod("summarise_data")
}

#' @export
summarise_data.default <- function(.data, ...) {
  dots <- pretty_dots(...)
  e <- call_env()
  as_tbl_data(lapply(dots, function(.x) eval(.x, .data, e)))
}

summarise_data_default <- function(.data, dots, e) {
  as_tbl_data.list(lapply(dots, function(.x) eval(.x, .data, e)))
}


#' @export
summarise_data.grouped_data <- function(.data, ...) {
  gd <- group_by_data_data(.data)
  .data <- ungroup_data(.data)
  e <- call_env()
  dots <- pretty_dots(...)
  .data <- lapply(gd$.row_num, function(.i) {
    summarise_data_default(.data[.i, , drop = FALSE], dots, e)
  })
  .data <- bind_rows_data(.data, fill = FALSE)
  gd$.row_num <- NULL
  for (i in seq_along(gd)) {
    .data[[names(gd)[i]]] <- gd[[i]]
  }
  .data[unique(c(names(gd), names(.data)))]
}
