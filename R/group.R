
#' Group data
#'
#' Indicate grouping variables in data frame
#'
#' @param .data Data frame
#' @param ... Unquoted (non-standard evaluation) name(s) of group variable(s).
#' @examples
#' d <- data.frame(a = c("a", "b", "c"), b = 1:3, stringsAsFactors = FALSE)
#' group_by_data(d, a)
#' @return A data frame with groups attribute
#' @export
group_by_data <- function(.data, ...) {
  UseMethod("group_by_data")
}

#' @export
group_by_data.grouped_data <- function(.data, ...) {
  .data <- ungroup_data(.data)
  group_by_data(.data, ...)
}

#' @export
group_by_data.default <- function(.data, ...) {
  g <- select_data(.data, ...)
  is_fct <- sapply(g, is.factor)
  lvs <- lapply(g, unique)
  lvs[is_fct] <- lapply(g[is_fct], levels)
  group_names <- names(g)
  rows <- vector("list", length(group_names))
  for (i in seq_along(lvs)) {
    rows[[i]] <- this_in_that(g[[i]], lvs[[i]], value = lvs[[i]])
  }
  names(rows) <- group_names
  attr(.data, "groups") <- rows
  structure(
    .data,
    class = c("grouped_data", "tbl_data", "tbl_df", "tbl", "data.frame")
  )
}

group_by_data_str <- function(.data, groups) {
  g <- .data[groups]
  is_fct <- sapply(g, is.factor)
  lvs <- lapply(g, unique)
  lvs[is_fct] <- lapply(g[is_fct], levels)
  group_names <- names(g)
  rows <- vector("list", length(group_names))
  for (i in seq_along(lvs)) {
    rows[[i]] <- this_in_that(g[[i]], lvs[[i]], value = lvs[[i]])
  }
  names(rows) <- group_names
  attr(.data, "groups") <- rows
  structure(
    .data,
    class = c("grouped_data", "tbl_data", "tbl_df", "tbl", "data.frame")
  )
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
    class = c("tbl_data", "tbl_df", "tbl", "data.frame")
  )
}

#' Groups in grouped data
#'
#' Returns grouping variable names of grouped data
#'
#' @param x Grouped data frame
#' @return Names of grouping variables
#' @export
group_by_data_groups <- function(x) names(attr(x, "groups"))

#' Group row numbers in grouped data
#'
#' Returns row numbers for each group in grouped data
#'
#' @param x Groupted data frame
#' @return List of row numbers for each group
#' @export
group_by_data_data <- function(x) attr(x, "groups")

