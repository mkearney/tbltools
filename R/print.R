#' Print tbl_data
#'
#' Method for printing pseduo tibble
#'
#' @param x Input object
#' @param n Maximum number of rows to print, defaults to 10
#' @param ... Other args passed to tibble or data.frame print.
#' @export
print.tbl_data <- function(x, n = 10, ...) {
  ## if tibble is installed and loaded, print as tbl_df
  if (isNamespaceLoaded("tibble")) {
    x <- as_tibble_tibble(x)
    print(x, n = n, ...)

    ## otherwise print as pseudo tibble
  } else {
    ## get dimensions
    n_rows <- nrow(x)
    n_cols <- ncol(x)
    x <- head_data(as_data_frame_data_frame(x), n)
    is_chr <- vapply(x, is.character, logical(1), USE.NAMES = FALSE)
    x[is_chr] <- lapply(x[is_chr], substr, 1, 15)
    ## max number of chars per column
    chars <- vapply(
      seq_len(ncol(x)),
      function(i) 1 + max(nchar(c(names(x)[i], x[[i]])), na.rm = TRUE),
      numeric(1),
      USE.NAMES = FALSE
    )
    ## get width
    w <- getOption("width", 80)
    ## only print columns
    kp <- which(cumsum(chars) < w)
    if (length(kp) < n_cols) {
      trunc_cols <- "** (** some columns not printed below!)"
    } else {
      trunc_cols <- ""
    }
    ## print top-level info
    pcat(gray_text("# A pseudo tibble: ", n_rows, " x ", n_cols, trunc_cols))
    ## print data
    print(x[kp], ...)
  }
}


head_data <- function(x, n = 10) {
  if (n > nrow(x)) {
    x <- x[seq_len(n), ]
  }
  x
}
