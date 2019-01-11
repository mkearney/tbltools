
#' Bind rows
#'
#' Convenient wrapper around \code{\link[base]{do.call}("rbind", ...)} that
#' (a) sets the 'quote' argument to TRUE and (b) fills data frames with missing
#' columns with NAs of the appropriate class.
#'
#' @param x Input list of data frames
#' @param fill Logical indicating whether to fill missing columns in data frames
#'   with missing values.
#' @return The list collapsed into a single data frame
#' @examples
#'
#' ## list of data frames with inconsistent columns
#' x <- as_tbl(mtcars[1:3, ])
#' xx <- x
#' xx$y <- "a"
#' l <- list(x, xx, mtcars)
#'
#' ## bind rows and fill missing columns with NAs
#' do_call_rbind(l)
#'
#' @export
do_call_rbind <- function(x, fill = TRUE) {
  stopifnot(is.list(x))
  if (length(x) == 1L && is.data.frame(x)) return(x)
  is_df <- sapply(x, is.data.frame)
  x <- x[is_df & lengths(x) > 0]
  if (length(x) == 0L) return(data.frame())
  if (length(x) == 1L) return(x[[1]])
  if (fill && !same_names(x)) {
    cls <- lapply(x, function(.x) {
      data_tbl(
        name = names(.x),
        class = lapply(.x, class)
      )
    })
    cls <- do.call("rbind", cls, quote = TRUE)
    cls <- cls[!duplicated(cls$name), ]

    for (i in seq_along(x)) {
      if (any(!cls$name %in% names(x[[i]]))) {
        not_in_x <- which(!cls$name %in% names(x[[i]]))
        for (j in not_in_x) {
          x[[i]][[cls$name[j]]] <- NA
          class(x[[i]][[cls$name[j]]]) <- cls$class[[j]]
        }
      }
    }
  }
  do.call("rbind", x, quote = TRUE)
}

same_names <- function(x) {
  if (n_uq(lengths(x)) != 1L) {
    return(FALSE)
  }
  nms <- uq_names(x)
  all(sapply(x, function(.x) all(nms %in% names(.x))))
}

uq_names <- function(x) unique(unlist(lapply(x, names)))
