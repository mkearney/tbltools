#' Arrange rows
#'
#' Arrange rows via descending or ascending column values
#'
#' @param .data data frame
#' @param ... The name of up to two column names on which to arrange the rows
#' @param desc Logical indicating whether to arrange by descending (default) or
#'   ascending values.
#' @return Rearranged data frame
#' @export
arrange_rows <- function(.data, ..., desc = TRUE) {
  UseMethod("arrange_rows")
}

#' @export
arrange_rows.default <- function(.data, ..., desc = TRUE) {
  row_names <- order(select_cols(.data, ...)[[1]], decreasing = desc)
  .data <- .data[row_names, ]
  if (ncol(select_cols(.data, ...)) > 1L) {
    col1 <- select_cols(.data, ...)[[1]]
    col2 <- select_cols(.data, ...)[[2]]
    row_names <- seq_len(nrow(.data))
    if (tfse::n_uq(col1) < nrow(.data)) {
      uqv <- unique(col1)
      for (i in seq_along(uqv)) {
        if (sum(col1 == uqv[i]) > 1) {
          o <- order(col2[col1 == uqv[i]], decreasing = desc)
          row_names[col1 == uqv[i]] <- row_names[col1 == uqv[i]][o]
        }
      }
    }
    .data <- .data[row_names, ]
  }
  row.names(.data) <- NULL
  .data
}
