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
  if (any(lengths(.data[vars]) > 1L)) {
    stop("summarise evaluated to more than 1 value")
  }
  as_tbl_data(
    lapply(.data[vars], base::`[`, 1L)
  )
}

summarise_data_default <- function(.data, group_names, vars, dots, e) {
  .data <- unclass(.data)
  for (i in vars) {
    .data[[i]] <- eval(dots[[i]], .data, e)
  }
  if (any(lengths(.data[vars]) > 1L)) {
    stop("summarise evaluated to more than 1 value")
  }
  as_tbl_data(
    lapply(.data[c(group_names, vars)], base::`[`, 1L)
  )
}

#' @export
summarise_data.grouped_data <- function(.data, ...) {
  dots <- pretty_dots(...)
  vars <- names(dots)
  e <- call_env()
  group_names <- attr(.data, "group_names")
  .data <- lapply(split_groups(.data),
    summarise_data_default,
    group_names, vars, dots, e)
  bind_rows_data(.data, fill = FALSE)
}
