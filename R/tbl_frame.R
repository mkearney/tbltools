#' Create tbl_data_frame
#'
#' Creates a data frame using non-standard evaluation
#'
#' @param ... Column vectors or expressions that reduce down to desired column vectors of
#'   data frame
#' @export
#' @examples
#'
#' ## create data frame with two random variables
#' tbl_data_frame(
#'   a = rnorm(10),
#'   b = rnorm(10)
#' )
#'
#' ## create variables calculated using previous variables
#' tbl_data_frame(
#'   a = rnorm(10),
#'   b = rnorm(10),
#'   c = (a + b) / 2,
#'   d = a + b + c
#' )
#'
#' @return A tbl_data data frame
tbl_data_frame <- function(...) {
  UseMethod("tbl_data_frame")
}

#' @export
tbl_data_frame <- function(...) {
  dots <- pretty_dots(...)
  vars <- names(dots)
  e <- call_env()
  for (i in vars) {
    dots[[i]] <- eval(dots[[i]], dots, e)
  }
  as_tbl_data(dots)
}

.foo <- function(...) {
  x <- tryCatch(list(...),
    error = function(e) return("ERROR_TRY_OTHER")
  )
  if (identical(x, "ERROR_TRY_OTHER")) {
    x <- pretty_dots(...)
    for (i in seq_along(x)) {
      if (i == 1) {
        x[[i]] <- eval(x[[i]])
      } else {
        x[[i]] <- eval(x[[i]], x)
      }
    }
  } else if (length(x) == 1L && is.data.frame(x[[1]])) {
    x <- x[[1]]
  }
  as_tbl_data(x)
}


