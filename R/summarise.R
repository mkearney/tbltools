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

#' @export
summarise_data.grouped_data <- function(.data, ...) {
  gd <- group_by_data_data(.data)
  .d <- ungroup_data(.data)
  d <- lapply(gd$.row_num, function(.i) {
    e <- .d[.i, , drop = FALSE]
    summarise_data(e, ...)
  })
  d <- bind_rows_data(d)
  d <- as_tbl_data(d)
  nms <- names(d)
  gd$.row_num <- NULL
  for (i in seq_along(gd)) {
    d[[names(gd)[i]]] <- gd[[i]]
  }
  d[unique(c(names(gd), names(d)))]
}
