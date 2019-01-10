

#' as_tbl
#'
#' Converts data objects to tibbles.
#'
#' @param x Data frame or data frame-like input.
#' @param row_names Logical indicating whether to convert non-null row names
#'   into the first column.
#' @rdname as_tbl
#' @examples
#' ## data with row names
#' d <- data.frame(x = rnorm(5), y = rnorm(5), row.names = letters[1:5])
#'
#' ## convert to tibble
#' as_tbl(d)
#'
#' ## convert to tibble and create row_names variable
#' as_tbl(d, row_names = TRUE)
#'
#' @export
as_tbl <- function(x, row_names = FALSE) {
  UseMethod("as_tbl")
}

#' @export
as_tbl.table <- function(x, row_names = FALSE) {
  df <- as.data.frame(x, stringsAsFactors = FALSE)
  names(df) <- c(names(dimnames(x)), "n")
  as_tbl(df)
}

#' @export
as_tbl.default <- function(x, row_names = FALSE) {
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
    class = c("tbl_df", "tbl", "data.frame")
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
      x <- as_tbl(x, row_names = row_names)
      message("Converting ", o[i], " into tbl_df")
      assign(o[i], x, envir = env)
    }
  }
  message("Done!")
}
