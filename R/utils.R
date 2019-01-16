set_class <- function(x, class) `class<-`(x, class)

as_tibble_tibble <- function(x) {
  set_class(x, c("tbl_df", "tbl", "data.frame"))
}

as_data_frame_data_frame <- function(x) {
  set_class(x, "data.frame")
}

is_list <- function(x) inherits(x, "list")

is_list_alist <- function(x) {
  is_list(x) &&
    length(x) == 1 &&
    is_list(x[[1]])
}

is_list_recursive <- function(x) {
  is_list(x) &&
    length(x) == 1 &&
    is.list(x[[1]])
}

peel_list_alist <- function(x) {
  if (is_list_alist(x)) {
    x <- x[[1]]
  }
  x
}

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
  dots <- paste0(c(...), collapse = "")
  if (interactive()) {
    paste0("\033[38;5;243m", dots, "\033[39m")
  } else {
    dots
  }
}

n_uq <- function(x) NROW(unique(x))

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

as_fct <- function(x) {
  levels <- unique(x)
  x <- as.character(x)
  f <- match(x, levels)
  levels(f) <- as.character(levels)
  class(f) <- "factor"
  f
}

split_default <- function(.data, .i) {
  split(.data, as_fct(.i), drop = TRUE)
}

split_groups <- function(.data) {
  .row_num <- attr(.data, ".row_num")
  class(.data) <- "data.frame"
  attributes(.data) <- attributes(.data)[c("names", "row.names", "class")]
  lapply(
    split_default(seq_len(nrow(.data)), .row_num),
    function(.i) unclass(.data[.i, , drop = FALSE])
  )
}
