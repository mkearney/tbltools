#'
#' #' @export
#' print.tbl_df <- function(x) {
#'   if (!isNamespaceLoaded("tibble")) {
#'     pcat(gray_text("# A pseudo tibble: ", nrow(x), " x ", ncol(x)))
#'     #m <- ncol(x) * 10
#'     x <- as.data.frame(x)
#'     x <- head(x, 10)
#'     is_chr <- sapply(x, is.character)
#'     x[is_chr] <- lapply(x[is_chr], substr, 1, 15)
#'     chars <- sapply(seq_len(ncol(x)), function(i)
#'       1 + max(nchar(c(names(x)[i], x[[i]])), na.rm = TRUE))
#'     w <- getOption("width", 80)
#'     kp <- which(cumsum(chars) < w)
#'     print(x[kp])
#'   } else {
#'     tibble:::print.tbl(x)
#'   }
#' }
