
#' Bind rows
#'
#' Convenient wrapper around \code{\link[base]{do.call}("rbind", ...)} that
#' (a) sets the 'quote' argument to TRUE and (b) fills data frames with missing
#' columns with NAs of the appropriate class.
#'
#' @param ... Input data frames or list of data frames
#' @param fill Logical indicating whether to fill missing columns in data frames
#'   with missing values.
#' @return The list collapsed into a single data frame
#' @examples
#'
#' ## list of data frames with inconsistent columns
#' x <- as_tbl_data(mtcars[1:3, ])
#' xx <- x
#' xx$y <- "a"
#' l <- list(x, xx, mtcars)
#'
#' ## bind rows and fill missing columns with NAs
#' bind_rows_data(l)
#'
#' @export
bind_rows_data <- function(..., fill = TRUE) {
  x <- peel_list_alist(list(...))
  if (length(x) == 1L) return(x[[1]])
  if (fill && !same_names(x)) {
    cls <- lapply(x, function(.x) {
      tbl_data(
        name = names(.x),
        class = lapply(.x, class)
      )
    })
    cls <- c(as.list(cls), stringsAsFactors = FALSE)
    cls <- do.call(base::rbind, cls, quote = FALSE)
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
  x <- c(as.list(x), stringsAsFactors = FALSE)
  as_tbl_data(do.call(base::rbind, x, quote = FALSE))
}

same_names <- function(x) {
  if (n_uq(lengths(x)) != 1L) {
    return(FALSE)
  }
  nms <- uq_names(x)
  all(sapply(x, function(.x) all(nms %in% names(.x))))
}

uq_names <- function(x) unique(unlist(lapply(x, names)))
