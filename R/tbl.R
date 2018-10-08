

#' as_tbl
#'
#' See \code{tibble::\link[tibble]{as_tibble}} for details.
#'
#' @param x Data
#' @param row.names Logical indicating whether to convert non-null row names
#'   into the first column.
#' @rdname as_tbl
#' @importFrom tibble as_tibble
#' @export
as_tbl <- function(x, row.names = FALSE) {
  isdf <- which(vapply(x, is.data.frame, FUN.VALUE = logical(1),
    USE.NAMES = FALSE))
  if (length(isdf) > 0) {
    for (i in isdf) {
      x[[i]] <- x[[i]]
    }
  }
  #x[isdf] <- lapply(x[isdf], list)
  if (row.names && !identical(as.character(seq_len(nrow(x))), row.names(x))) {
    x$row_names <- row.names(x)
    x <- x[c(ncol(x), 1:(ncol(x) - 1))]
    row.names(x) <- NULL
  }
  tibble::as_tibble(x)
}


#' move vars to front
#'
#' @param data data frame
#' @param ... columns to move to front
#' @export
repos_front <- function(data, ...) {
  re <- rlang::with_env(data, tidyselector(data, ...))
  as_tbl(cbind(re, data[!names(data) %in% names(re)]))
}

#' move vars to front
#'
#' @param data data frame
#' @param ... columns to move to front
#' @export
repos_back <- function(data, ...) {
  re <- rlang::with_env(data, tidyselector(data, ...))
  #re <- re[rev(seq_len(ncol(re)))]
  as_tbl(cbind(data[!names(data) %in% names(re)], re))
}

#' tidyselector
#'
#' Select columns using tidy eval
#'
#' @param data data frame
#' @param ... vars to select
#' @export
tidyselector <- function(data, ...) {
  vars <- tryCatch(tidyselect::vars_select(names(data), ...),
    error = function(e) return(NULL))
  #if (is.null(vars)) return(data)
  if (length(vars) > 0) {
    data <- data[vars]
  }
  data
}
