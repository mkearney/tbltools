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
  for (i in vars) {
    .data[[i]] <- eval(dots[[i]], .data, e)
  }
  .data
}


mutate_data_default <- function(.data, vars, dots, e) {
  for (i in vars) {
    .data[[i]] <- eval(dots[[i]], .data, e)
  }
  .data
}

#' @export
mutate_data.grouped_data <- function(.data, ...) {
  gd <- group_by_data_data(.data)
  .data <- ungroup_data(.data)
  dots <- pretty_dots(...)
  e <- call_env()
  vars <- names(dots)
  .data <- lapply(gd$.row_num, function(.i) {
    mutate_data_default(.data[.i, , drop = FALSE], vars, dots, e)
  })
  .data <- bind_rows_data(.data, fill = FALSE)
  group_by_data_str(.data, names(gd)[-ncol(gd)])
}
