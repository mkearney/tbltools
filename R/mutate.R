#' Mutate data
#'
#' Wrangle data by adding or transforming columns
#'
#' @param .data Data frame
#' @param ... One or more expressions using non-standard evaluation designed
#'   to return a column of values. These should be named variables. Any names
#'   already found in the input data will override those input data frame columns
#' @return Mutated data frame
#' @family mutate
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

mutate_data_default <- function(.data, group_names, vars, dots, e) {
  for (i in seq_along(vars)) {
    .data[[vars[i]]] <- eval(dots[[i]], .data, e)
  }
  as_tbl_data(.data)
}





#' Mutate certain columns
#'
#' Wrangle only columns that pass a logical test
#'
#' @param .data Input data frame
#' @param .predicate Function applied to each column evaluating to a logical
#' @param .f Function applied to each .predicate-passing column. Can be written
#'   in the formula \code{~ .x} format.
#' @return Data frame with .predicate-passing columns mutated.
#' @family mutate
#' @export
mutate_if_data <- function(.data, .predicate, .f) {
  UseMethod("mutate_if_data")
}


is_lang <- function(x) identical(typeof(x), "language")

#' @export
mutate_if_data.default <- function(.data, .predicate, .f, e) {
  .col <- vapply(.data, .predicate, logical(1), USE.NAMES = FALSE)
  if (is_lang(.f)) {
    e <- call_env()
    .f <- eval(.f, envir = e)[[2]]
    .data[.col] <- lapply(.data[.col], function(.x) eval(.f, list(.x = .x), e))
  } else {
    .data[.col] <- lapply(.data[.col], .f)
  }
  .data
}

#' @export
mutate_if_data.grouped_data <- function(.data, .predicate, .f) {
  .col <- vapply(.data, .predicate, logical(1), USE.NAMES = FALSE)
  e <- call_env()
  group_names <- attr(.data, "group_names")
  .row_num <- attr(.data, ".row_num")
  .data <- lapply(split_groups(.data), mutate_if_data_default, .col, .f, e)
  .data <- bind_rows_data(.data, fill = FALSE)
  group_by_data_str(.data, group_names)
}

mutate_if_data_default <- function(.data, .col, .f, e) {
  if (is_lang(.f)) {
    e <- call_env()
    .f <- eval(.f, envir = e)[[2]]
    .data[.col] <- lapply(.data[.col], function(.x) eval(.f, list(.x = .x), e))
  } else {
    .data[.col] <- lapply(.data[.col], .f)
  }
  .data
}
