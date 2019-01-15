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
    nce <- if (n < 20) ceiling(1.9 * n) else n
    if (nrow(x) > nce) {
      trunc_rows <- "*"
      ll <- sprintf("*%s rows not printed",
        formatC(nrow(x) - n, big.mark = ","))
    } else {
      trunc_rows <- ""
      ll <- ""
    }
    n_cols <- ncol(x)
    x <- head_data(as_data_frame_data_frame(x), n)
    is_chr <- vapply(x, is.character, logical(1), USE.NAMES = FALSE)
    nms <- substr_dots(names(x), 14)
    nms[duplicated(nms)] <- names(x)[duplicated(nms)]
    names(x) <- nms
    x[is_chr] <- lapply(x[is_chr], substr_dots, stop = 12)
    is_psx <- vapply(
      x, inherits, c("POSIXct", "POSIXt"),
      FUN.VALUE = logical(1),
      USE.NAMES = FALSE
    )
    x[is_psx] <- lapply(x[is_psx], substr_dots, stop = 10)
    ## max number of chars per column
    chars <- vapply(
      seq_len(ncol(x)),
      function(i) 2 + max(nchar(c(names(x)[i], x[[i]])), na.rm = TRUE),
      numeric(1),
      USE.NAMES = FALSE
    )
    ## get width
    w <- getOption("width", 80)
    ## only print columns
    chars[1] <- chars[1] + 1
    kp <- which(cumsum(chars) < w)
    if (length(kp) < n_cols) {
      trunc_cols <- "\u002b"
      if (!identical(ll, "")) {
        ll <- paste0(ll, sprintf(";  \u002b%s columns not printed",
          formatC(n_cols - length(kp), big.mark = ",")))
      } else {
        ll <- sprintf("\u002b%s columns not printed",
          formatC(n_cols - length(kp), big.mark = ","))
      }
    } else {
      trunc_cols <- ""
    }
    ## print top-level info
    pcat(gray_text("# A pseudo tibble: ",
      formatC(n_rows, big.mark = ","),
      trunc_rows, " x ",
      n_cols, trunc_cols))
    ## print data
    x <- x[kp]
    if ((ncol(x) * nrow(x)) > getOption("max.print", 10000)) {
      rn <- getOption("max.print", 10000) / ncol(x)
    } else {
      rn <- nrow(x)
    }
    if (n < 10) {
      rn <- sprintf("%1d) ", seq_len(rn))
    } else if (n < 100) {
      rn <- sprintf("%2d) ", seq_len(rn))
    } else if (n < 1000) {
      rn <- sprintf("%3d) ", seq_len(rn))
    } else {
      rn <- sprintf("%4d) ", seq_len(rn))
    }
    print(x, ..., right = TRUE, row.names = rn)
    ## print truncation info
    if (!identical(ll, "")) pcat(gray_text(ll))
  }
}


head_data <- function(x, n = 10) {
  n1.9 <- ceiling(n * 1.9)
  if (n > 20) n1.9 <- n
  if (nrow(x) > n1.9) {
    x <- x[seq_len(n), ]
  }
  x
}

substr_dots <- function(x, stop = 10) {
  ## adjust stop depending on extent to which mean char is greater than stop
  if (all(is.na(x))) return(x)
  x <- iconv(x, to = "ascii", sub = "byte")
  ncs <- nchar(x)
  if (mean(ncs, na.rm = TRUE) >= (stop * 5.0)) {
    stop <- ceiling(stop * 2.0)
  } else if (mean(ncs, na.rm = TRUE) >= (stop * 4.0)) {
    stop <- ceiling(stop * 1.7)
  } else if (mean(ncs, na.rm = TRUE) >= (stop * 3.0)) {
    stop <- ceiling(stop * 1.4)
  } else if (mean(ncs, na.rm = TRUE) >= (stop * 2.0)) {
    stop <- ceiling(stop * 1.2)
  } else {
    stop <- ceiling(stop * 0.9)
  }
  mw <- stop
  na <- is.na(x)
  s <- strsplit(x[!na], "")
  w <- lapply(lengths(s), function(i) rep(1, i))
  o <- rep(NA_character_, length(x))
  o[!na] <- vapply(
    seq_along(s),
    function(i) {
      if (any(cumsum(w[[i]]) >= mw)) {
        e <- "\u2026"
      } else {
        e <- ""
      }
      paste0(paste0(s[[i]][cumsum(w[[i]]) <= mw], collapse = ""), e)
    },
    FUN.VALUE = character(1),
    USE.NAMES = FALSE
  )
  o
}
