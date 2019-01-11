call_env <- function (n = 1) parent.frame(n + 1)

capture_dots <- function(...) {
  eval(substitute(alist(...)), envir = parent.frame())
}

expr_names <- function(args) {
  vapply(
    args,
    deparse,
    USE.NAMES = FALSE,
    FUN.VALUE = character(1)
  )
}

pretty_dots <- function(...) {
  ## capture dots as arg list
  dots <- capture_dots(...)

  ## if none provided, return NULL
  if (length(dots) == 0) {
    return(NULL)
  }

  ## if no names, inherit expression text
  if (is.null(names(dots))) {
    names(dots) <- expr_names(dots)
  }

  ## dots names
  nms <- names(dots)

  ## if any names missing, assign expression text
  if ("" %in% nms) {
    names(dots)[nms == ""] <- expr_names(dots[nms == ""])
  }

  dots
}

pcat <- function(...) {
  cat(paste0(c(...), collapse = ""), fill = TRUE)
}

pcat_lines <- function (...) {
  cat(paste0(..., "\n"), sep = "")
}

gray_text <- function(...) {
  paste0("\033[38;5;243m", paste0(c(...), collapse = ""), "\033[39m")
}


n_uq <- function(x) NROW(unique(x))


nin <- function(lhs, rhs, value = TRUE) {
  x <- !lhs %in% rhs
  if (value) {
    x <- lhs[x]
  }
  x
}

this_in_that <- function(this, that, value = NULL) {
  m <- match(this, that)
  if (is.null(value)) {
    return(m)
  }
  if (length(that) != length(value)) {
    stop("'value' must be same length as 'that' (table)",
      call. = FALSE)
  }
  value[m]
}

all_na <- function(x) all(is.na(unlist(x, use.names = FALSE)) | lengths(x) == 0)

na_omit_data.frame <- function(x) {
  na_rows <- vapply(seq_len(nrow(x)), function(i)
    all_na(x[i, ]), logical(1), USE.NAMES = FALSE)
  x[!na_rows, , drop = FALSE]
}

na_omit_list <- function(x) {
  na_elems <- vapply(x, all_na, logical(1))
  x[!na_elems]
}
