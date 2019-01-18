#' Mutate data
#'
#' Wrangle data by adding or transforming columns
#'
#' @param .data Data frame
#' @param ... One or more expressions using non-standard evaluation designed
#'   to return a column of values. These should be named variables. Any names
#'   already found in the input data will override those input data frame columns
#' @return Mutated data frame
#' @export
mutate_data <- function(.data, ...) {
  UseMethod("mutate_data")
}

#' @export
mutate_data.default <- function(.data, ...) {
  dots <- pretty_dots(...)
  vars <- names(dots)
  e <- call_env()
  for (i in seq_along(vars)) {
    .data[[vars[i]]] <- eval(dots[[i]], .data, e)
  }
  .data
}


mutate_data_default <- function(.data, group_names, vars, dots, e) {
  for (i in seq_along(vars)) {
    .data[[vars[i]]] <- eval(dots[[i]], .data, e)
  }
  as_tbl_data(.data)
}

#' @export
mutate_data.grouped_data <- function(.data, ...) {
  e <- call_env()
  dots <- pretty_dots(...)
  vars <- names(dots)
  group_names <- attr(.data, "group_names")
  .row_num <- attr(.data, ".row_num")
  .data <- lapply(split_groups(.data),
    mutate_data_default,
    group_names, vars, dots, e)
  .data <- bind_rows_data(.data, fill = FALSE)
  group_by_data_str(.data, group_names)
}
