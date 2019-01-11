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

#' Ungroup data
#'
#' Ungroups grouped data
#'
#' @param .data Grouped data
#' @return Data grame without groups attribute
#' @export
ungroup_data <- function(.data) {
  UseMethod("ungroup_data")
}

#' @export
ungroup_data.default <- function(.data) {
  structure(
    .data,
    class = c("tbl_df", "tbl", "data.frame")
  )
}

#' @export
mutate_data.grouped_data <- function(.data, ...) {
  gd <- group_data_data(.data)
  .data <- ungroup_data(.data)
  .data <- lapply(gd, function(i) {
    lvs <- unique(i)
    e <- lapply(lvs, function(j) .data[i == j, ])
    e <- lapply(e, function(.x) unique(mutate_data(.x, ...)))
    e <- do_call_rbind(e)
    unique(e)
  })
  .data <- do_call_rbind(.data)
  row.names(.data) <- NULL
  group_data_str(.data, names(gd))
}

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
    e <- do_call_rbind(e)
    unique(e)
  })
  d <- do_call_rbind(d)
  d <- as_tbl(d)
  nms <- names(d)
  for (i in seq_along(gd)) {
    d[[names(gd)[i]]] <- unique(gd[[i]])
  }
  d
}
