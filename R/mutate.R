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
  as_tbl_data(.data)
}


#' @export
mutate_data.grouped_data <- function(.data, ...) {
  gd <- group_by_data_data(.data)
  .d <- ungroup_data(.data)
  d <- lapply(gd$.row_num, function(.i) {
    e <- .d[.i, , drop = FALSE]
    mutate_data(e, ...)
  })
  d <- bind_rows_data(d)
  group_by_data_gd(d, gd)
}
