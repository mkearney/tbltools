
#' Group data
#'
#' Indicate grouping variables in data frame
#'
#' @param .data Data frame
#' @param ... Unquoted (non-standard evaluation) name(s) of group variable(s).
#' @examples
#' d <- data.frame(a = c("a", "b", "c"), b = 1:3, stringsAsFactors = FALSE)
#' group_data(d, a)
#' @return A data frame with groups attribute
#' @export
group_data <- function(.data, ...) {
  UseMethod("group_data")
}

#' @export
group_data.grouped_data <- function(.data, ...) {
  .data <- ungroup_data(.data)
  group_data(.data)
}

#' @export
group_data.default <- function(.data, ...) {
  g <- select_cols(.data, ...)
  is_fct <- dapr::vap_lgl(g, is.factor)
  g[!is_fct] <- lapply(g[!is_fct], factor)
  lvs <- dapr::lap(g, levels)
  group_names <- names(g)
  rows <- vector("list", length(group_names))
  for (i in seq_along(lvs)) {
    rows[[i]] <- tfse::this_in_that(.data[[group_names[i]]], lvs[[i]], value = lvs[[i]])
  }
  names(rows) <- group_names
  attr(.data, "groups") <- rows
  structure(
    .data,
    class = c("grouped_data", "tbl_df", "tbl", "data.frame")
  )
}

#' Groups in grouped data
#'
#' Returns grouping variable names of grouped data
#'
#' @param x Grouped data frame
#' @return Names of grouping variables
#' @export
group_data_groups <- function(x) names(attr(x, "groups"))

#' Group row numbers in grouped data
#'
#' Returns row numbers for each group in grouped data
#'
#' @param x Groupted data frame
#' @return List of row numbers for each group
#' @export
group_data_data <- function(x) attr(x, "groups")

