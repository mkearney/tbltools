

#' as_tbl
#'
#' See \code{tibble::\link[tibble]{as_tibble}} for details.
#'
#' @param x Data
#' @param row_names Logical indicating whether to convert non-null row names
#'   into the first column.
#' @rdname as_tbl
#' @importFrom tibble as_tibble
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
  isdf <- which(vapply(x, is.data.frame, FUN.VALUE = logical(1),
    USE.NAMES = FALSE))
  if (length(isdf) > 0) {
    for (i in isdf) {
      x[[i]] <- x[[i]]
    }
  }
  #x[isdf] <- lapply(x[isdf], list)
  if (row_names && !identical(as.character(seq_len(nrow(x))), row.names(x))) {
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
#' @examples
#' ## data with row names
#' d <- data.frame(x = rnorm(5), y = rnorm(5), row.names = letters[1:5])
#'
#' ## move y to front
#' repos_front(d, y)
#'
#' @return Reordered data frame.
repos_front <- function(data, ...) {
  re <- rlang::with_env(data, tidyselector(data, ...))
  as_tbl(cbind(re, data[!names(data) %in% names(re)]))
}

#' move vars to back
#'
#' @param data data frame
#' @param ... columns to move to back
#' @export
#' @examples
#' ## data with row names
#' d <- data.frame(x = rnorm(5), y = rnorm(5), row.names = letters[1:5])
#'
#' ## move x to back
#' repos_back(d, x)
#'
#' @return Reordered data frame.
repos_back <- function(data, ...) {
  re <- rlang::with_env(data, tidyselector(data, ...))
  as_tbl(cbind(data[!names(data) %in% names(re)], re))
}

#' tidyselector
#'
#' Select columns using tidy eval
#'
#' @param data data frame
#' @param ... vars to select
#' @return Data with selected columns.
#' @examples
#' ## data with row names
#' d <- data.frame(x = rnorm(5), y = rnorm(5), row.names = letters[1:5])
#'
#' ## select only x
#' tidyselector(d, x)
#'
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
