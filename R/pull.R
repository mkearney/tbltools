

pull_data <- function(.data, ...) {
  UseMethod("pull_data")
}

pull_data.default <- function(.data, ...) {
  eval(capture_dots(...)[[1]], .data, parent.frame())
}
