#' Filter rows
#'
#' Filter rows via integer/numeric position or logical vector
#'
#' @param .data Data frame or two dimensional array
#' @param ... This should evaluate and reduce down to a numeric (row number)
#'   or logical vector. Row numbers higher than what exists in x will be
#'   ignored. Any numeric vector must be either all positive or all negative.
#' @return Sliced/filtered data frame
#' @export
filter_rows <- function(.data, ...) UseMethod("filter_rows")

#' @export
filter_rows.default <- function(.data, ...) {
  if (length(dim(.data)) != 2) {
    stop("filter_rows method requires two-dimensional object", call. = FALSE)
  }
  dots <- tfse:::capture_dots(...)
  i <- lapply(dots, function(.x) {
    o <- eval(.x, as.list(.data), parent.frame())
    if (is.logical(o)) o <- which(o)
    o
  })
  it <- table(unlist(i))
  i <- as.integer(names(it[it == length(i)]))
  #i <- unlist(lapply(list(...), eval))
  if (length(i) == 0) return(.data)
  if (is.logical(i)) i <- which(i)
  i <- i[i <= nrow(.data)]
  .data <- `[`(.data, i, )
  row.names(.data) <- NULL
  .data
}
