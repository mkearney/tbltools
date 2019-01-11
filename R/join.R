
are_fct <- function(x) vapply(x, is.factor, logical(1), USE.NAMES = FALSE)


#' Joins
#'
#' Full join: join two data frames preserving all possible information
#'
#' @param x Left or first data frame
#' @param y Right or second data frame
#' @param by Name (character) of variable(s) on which to join
#' @return Joined (merged) data frame
#' @rdname join
#' @examples
#'
#' d1 <- data.frame(
#'   x = 1:10,
#'   y = rnorm(10),
#'   z = letters[1:10],
#'   stringsAsFactors = FALSE
#' )
#' d2 <- data.frame(
#'   x = sample(1:10, 20, replace = TRUE),
#'   y2 = rnorm(20)
#' )
#'
#' ## left join
#' left_join_data(d1, d2)
#'
#' ## right join
#' right_join_data(d1, d2)
#'
#' ## full join
#' full_join_data(d1, d2)
#'
#' @export
full_join_data <- function(x, y, by = NULL) {
  #x[are_fct(x)] <- lapply(x[are_fct(x)], as.character)
  #y[are_fct(y)] <- lapply(y[are_fct(y)], as.character)
  if (is.null(by)) {
    by <- intersect(names(x), names(y))
    message("Joining, by = ", paste0(by, collapse = ", "))
  }
  nms <- unique(c(names(x), names(y)))
  nms <- unlist(lapply(nms, function(.x) c(.x, paste0(.x, ".x"), paste0(.x, ".y"))))
  x$merge.x___x.merge <- seq_len(nrow(x))
  y$merge.y___y.merge <- seq_len(nrow(y))
  m <- merge(x, y, by = by, all = TRUE, sort = FALSE)
  m <- arrange_data(m, merge.x___x.merge, merge.y___y.merge, desc = FALSE)
  m$merge.x___x.merge <- NULL
  m$merge.y___y.merge <- NULL
  o <- order(match(names(m), nms))
  as_tbl(m)[, o]
}

#' Left join
#'
#' Left join: Join two data frames by matching the second (right) data frame to the left (first) such that the
#'   structure of the first (left) data frame is preserved
#'
#' @inheritParams full_join
#' @rdname join
#' @export
left_join_data <- function(x, y, by = NULL) {
  #x[are_fct(x)] <- lapply(x[are_fct(x)], as.character)
  #y[are_fct(y)] <- lapply(y[are_fct(y)], as.character)
  if (is.null(by)) {
    by <- intersect(names(x), names(y))
    message("Joining, by = ", paste0(by, collapse = ", "))
  }
  nms <- unique(c(names(x), names(y)))
  nms <- unlist(lapply(nms, function(.x) c(.x, paste0(.x, ".x"), paste0(.x, ".y"))))
  x$merge.x___x.merge <- seq_len(nrow(x))
  m <- merge(x, y, by.x = by, all = FALSE, all.x = TRUE, all.y = FALSE, sort = FALSE)
  m <- arrange_data(m, merge.x___x.merge, desc = FALSE)
  m$merge.x___x.merge <- NULL
  o <- order(match(names(m), nms))
  as_tbl(m)[, o]
}

#' Right join
#'
#' Right join: Join two data frames by matching the first (left) data frame to the right (second) such that the
#'   structure of the second (right) data frame is preserved
#' @inheritParams full_join
#' @rdname join
#' @export
right_join_data <- function(x, y, by = NULL) {
  #left_join_data(y, x, by)
  #x[are_fct(x)] <- lapply(x[are_fct(x)], as.character)
  #y[are_fct(y)] <- lapply(y[are_fct(y)], as.character)
  if (is.null(by)) {
    by <- intersect(names(x), names(y))
    message("Joining, by = ", paste0(by, collapse = ", "))
  }
  nms <- unique(c(names(x), names(y)))
  nms <- unlist(lapply(nms, function(.x) c(.x, paste0(.x, ".x"), paste0(.x, ".y"))))
  x$merge.x___x.merge <- seq_len(nrow(x))
  y$merge.y___y.merge <- seq_len(nrow(y))
  m <- merge(x, y, by.y = by, all = FALSE, all.x = FALSE, all.y = TRUE, sort = FALSE)
  m <- arrange_data(m, merge.y___y.merge, merge.x___x.merge, desc = FALSE)
  m$merge.x___x.merge <- NULL
  m$merge.y___y.merge <- NULL
  o <- order(match(names(m), nms))
  as_tbl(m)[, o]
}



