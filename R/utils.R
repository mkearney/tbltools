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
