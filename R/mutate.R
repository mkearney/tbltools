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
  e <- call_env()
  d2 <- as_tbl(lapply(dots, function(.x) eval(.x, .data, e)))
  .data <- .data[nin(names(.data), d2)]
  as_tbl(cbind(.data, d2))
}


#' @export
mutate_data.grouped_data <- function(.data, ...) {
  gd <- group_by_data_data(.data)
  # .data <- ungroup_data(.data)
  # .d <- lapply(gd, function(i) {
  #   lvs <- unique(i)
  #   e <- lapply(lvs, function(j) .data[i == j, ])
  #   e <- lapply(e, function(.x) mutate_data(.x, ...))
  #   bind_rows_data(e)
  # })
  # d <- bind_rows_data(.d)
  #row.names(.d) <- NULL
  #group_by_data_str(.d, names(gd))


  .d <- ungroup_data(.data)
  d <- lapply(gd, function(i) {
    lvs <- unique(i)
    e <- lapply(lvs, function(j) .d[i == j, ])
    e <- lapply(e, function(.x) mutate_data(.x, ...))
    bind_rows_data(e)
  })
  d <- bind_rows_data(d)
  group_by_data_str(d, names(gd))
  #nms <- names(d)
  #for (i in seq_along(gd)) {
  #  d[[names(gd)[i]]] <- gd[[i]]
  #}
  #d

}


