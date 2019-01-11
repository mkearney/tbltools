
#' @export
group_data <- function(.data, ...) {
  UseMethod("group_data")
}

#' @export
group_data.grouped_data <- function(.data, ...) {
  .data <- ungroup_data(.data)
  group_data(.data)
}

#' @export
group_data.default <- function(.data, ...) {
  g <- select_cols(.data, ...)
  is_fct <- dapr::vap_lgl(g, is.factor)
  g[!is_fct] <- lapply(g[!is_fct], factor)
  lvs <- dapr::lap(g, levels)
  group_names <- names(g)
  rows <- vector("list", length(group_names))
  for (i in seq_along(lvs)) {
    rows[[i]] <- tfse::this_in_that(.data[[group_names[i]]], lvs[[i]], value = lvs[[i]])
  }
  names(rows) <- group_names
  attr(.data, "groups") <- rows
  structure(
    .data,
    class = c("grouped_data", "tbl_df", "tbl", "data.frame")
  )
}

#' @export
group_data_groups <- function(x) names(attr(x, "groups"))

#' @export
group_data_data <- function(x) attr(x, "groups")


#' @export
mutate_data <- function(.data, ...) {
  UseMethod("mutate_data")
}

#' @export
mutate_data.default <- function(.data, ...) {
  dots <- pretty_dots(...)
  e <- call_env()
  d2 <- as_tbl(lapply(dots, function(.x) eval(.x, .data, e)))
  .data <- .data[tfse::nin(names(.data), d2)]
  cbind(.data, d2)
}

#' @export
ungroup_data <- function(.data) {
  UseMethod("ungroup_data")
}

#' @export
ungroup_data.default <- function(.data) {
  structure(
    .data,
    class = c("tbl_df", "tbl", "data.frame")
  )
}

#' @export
mutate_data.grouped_data <- function(.data, ...) {
  gd <- group_data_data(.data)
  .data <- ungroup_data(.data)
  d <- lapply(gd, function(i) {
    lvs <- unique(i)
    e <- lapply(lvs, function(j) .data[i == j, ])
    e <- lapply(e, function(.x) unique(mutate_data(.x, ...)))
    e <- do_call_rbind(e)
    unique(e)
  })
  d <- do_call_rbind(d)
  as_tbl(d)
}

#' @export
summarise_data <- function(.data, ...) {
  UseMethod("summarise_data")
}

#' @export
summarise_data.default <- function(.data, ...) {
  dots <- pretty_dots(...)
  e <- call_env()
  as_tbl(lapply(dots, function(.x) eval(.x, .data, e)))
}

#' @export
summarise_data.grouped_data <- function(.data, ...) {
  gd <- group_data_data(.data)
  .data <- ungroup_data(.data)
  d <- lapply(gd, function(i) {
    lvs <- unique(i)
    e <- lapply(lvs, function(j) .data[i == j, ])
    e <- lapply(e, function(.x) unique(summarise_data(.x, mpg = mean(mpg))))
    e <- do_call_rbind(e)
    unique(e)
  })
  d <- do_call_rbind(d)
  d <- as_tbl(d)
  nms <- names(d)
  for (i in seq_along(gd)) {
    d[[names(gd)[i]]] <- unique(gd[[i]])
  }
  d
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

#' @export
print.tbl_df <- function(x) {
  if (!isNamespaceLoaded("tibble")) {
    pcat(gray_text("# A pseudo tibble: ", nrow(x), " x ", ncol(x)))
    #m <- ncol(x) * 10
    x <- as.data.frame(x)
    x <- head(x, 10)
    is_chr <- dapr::vap_lgl(x, is.character)
    x[is_chr] <- dapr::lap(x[is_chr], substr, 1, 15)
    chars <- sapply(seq_len(ncol(x)), function(i)
      1 + max(nchar(c(names(x)[i], x[[i]])), na.rm = TRUE))
    w <- getOption("width", 80)
    kp <- which(cumsum(chars) < w)
    print(x[kp])
  } else {
    tibble:::print.tbl(x)
  }
}
