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
  vars <- names(dots)
  e <- call_env()
  .data <- unclass(.data)
  for (i in vars) {
    .data[[i]] <- eval(dots[[i]], .data, e)
  }
  as_tbl_data(.data[vars])
}

summarise_data_default <- function(.data, vars, dots, e) {
  vars <- names(dots)
  .data <- unclass(.data)
  for (i in vars) {
    .data[[i]] <- eval(dots[[i]], .data, e)
  }
  as_tbl_data(.data[vars])
}


#' @export
summarise_data.grouped_data <- function(.data, ...) {
  gd <- group_by_data_data(.data)
  .data <- ungroup_data(.data)
  e <- call_env()
  dots <- pretty_dots(...)
  vars <- names(dots)
  .data <- lapply(unique(gd$.row_num), function(.i) {
    summarise_data_default(.data[gd$.row_num == .i, , drop = FALSE], vars, dots, e)
  })
  .data <- bind_rows_data(.data, fill = FALSE)
  gd$.row_num <- NULL
  gd <- unique(gd)
  for (i in seq_along(gd)) {
    .data[[names(gd)[i]]] <- gd[[i]]
  }
  .data[unique(c(names(gd), names(.data)))]
}
