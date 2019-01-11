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
  as_tbl(lapply(dots, function(.x) eval(.x, .data, e)))
}

#' @export
summarise_data.grouped_data <- function(.data, ...) {
  gd <- group_data_data(.data)
  .data <- ungroup_data(.data)
  d <- lapply(gd, function(i) {
    lvs <- unique(i)
    e <- lapply(lvs, function(j) .data[i == j, ])
    e <- lapply(e, function(.x) unique(summarise_data(.x, ...)))
    e <- bind_rows_data(e)
    unique(e)
  })
  d <- bind_rows_data(d)
  d <- as_tbl(d)
  nms <- names(d)
  for (i in seq_along(gd)) {
    d[[names(gd)[i]]] <- unique(gd[[i]])
  }
  d
}