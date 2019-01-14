

#' as_tbl_data
#'
#' Converts data objects to tibbles.
#'
#' @param x Data frame or data frame-like input.
#' @param row_names Logical indicating whether to convert non-null row names
#'   into the first column.
#' @rdname as_tbl_data
#' @examples
#' ## data with row names
#' d <- data.frame(x = rnorm(5), y = rnorm(5), row.names = letters[1:5])
#'
#' ## convert to tibble
#' as_tbl_data(d)
#'
#' ## convert to tibble and create row_names variable
#' as_tbl_data(d, row_names = TRUE)
#'
#' @export
as_tbl_data <- function(x, row_names = FALSE) {
  UseMethod("as_tbl_data")
}

#' @export
as_tbl_data.table <- function(x, row_names = FALSE) {
  df <- as.data.frame(x, stringsAsFactors = FALSE)
  names(df) <- c(names(dimnames(x)), "n")
  as_tbl_data(df)
}

#' @export
as_tbl_data.default <- function(x, row_names = FALSE) {
  isdf <- which(vapply(x, is.data.frame, FUN.VALUE = logical(1),
    USE.NAMES = FALSE))
  if (length(isdf) > 0) {
    for (i in isdf) {
      x[[i]] <- x[[i]]
    }
  }
  if (row_names && !identical(as.character(seq_len(nrow(x))), row.names(x))) {
    x$row_names <- row.names(x)
    x <- x[c(ncol(x), 1:(ncol(x) - 1))]
    row.names(x) <- NULL
  }
  structure(
    x,
    row.names = .set_row_names(length(x[[1]])),
    class = c("tbl_data", "tbl_df", "tbl", "data.frame")
  )
}

#' Convert all data frames in environment into tibbles
#'
#' Converts data frames found in a given environment into tibbles (tbl_df)
#'
#' @param env Name of environment from which data frames should be converted to tibbles.
#'   Defaults to global environment.
#' @param row_names Logical indicating whether to create a row_names variable if non-auto
#'   row names are found.
#' @return The function will print messages when converting occurs and it will print a final
#'   completion message, but otherwise returns nothing.
#' @examples
#' ## data with row names
#' d <- data.frame(x = rnorm(5), y = rnorm(5), row.names = letters[1:5])
#'
#' ## convert data frames in global environment to tibbles
#' env_tbls()
#'
#' @export
env_tbls <- function(env = globalenv(), row_names = TRUE) {
  o <- ls(envir = env, all.names = TRUE)
  for (i in seq_along(o)) {
    x <- get(o[i], envir = env)
    if (is.data.frame(x)) {
      x <- as_tbl_data(x, row_names = row_names)
      message("Converting ", o[i], " into tbl_df")
      assign(o[i], x, envir = env)
    }
  }
  message("Done!")
}


#' tbl data
#'
#' Create a tibble data frame
#'
#' @param ... A data frame, vector, or list of values of equal or single-value
#'   length–similar to \link[base]{data.frame}.
#' @return An object of class \code{c("tbl_data", "tbl_df", "tbl", "data.frame")}
#' @export
tbl_data <- function(...) {
  x <- list(...)
  if (length(x) == 1L && is.data.frame(x[[1]])) {
    x <- x[[1]]
  }
  lens <- lengths(x)
  if (n_uq(lens) == 2L && 1L %in% lens) {
    x[lens == 1L] <- lapply(x[lens == 1L], rep, max(lens))
  }
  nms <- names(x)
  no_nms <- !nzchar(nms)
  nms[no_nms] <- paste0("x", seq_len(sum(no_nms)))
  structure(x, names = nms, row.names = .set_row_names(length(x[[1]])),
    class = c("tbl_data", "tbl_df", "tbl", "data.frame"))
}
