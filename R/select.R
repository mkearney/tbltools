
#' Select columns
#'
#' Select columns with non-standard evaluation
#'
#' @param .data Input data frame
#' @param ... Unquoted names of columns to select
#' @export
#' @return Data frame with select columns
select_data <- function(.data, ...) {
  UseMethod("select_data")
}

#' @export
select_data.default <- function(.data, ...) {
  dots <- pretty_dots(...)
  if (length(dots) == 0) {
    return(.data)
  }
  e <- call_env()
  vars.dots <- names(dots)
  vars.data <- sub("^-", "", vars.dots)
  if (all(grepl("^-\\S+", vars.dots))) {
    .d <- .data
  } else {
    .d <- list()
  }
  assign("-", function(x) NULL, envir = e)
  on.exit(rm("-", envir = e), add = TRUE)
  assign(":", function(lhs, rhs) {
    .data_vars <- rev(
      ls(all.names = TRUE, sorted = FALSE, envir = as.environment(.data))
    )
    lhs <- deparse(substitute(lhs))
    rhs <- deparse(substitute(rhs))
    kp <- seq.int(
      which(.data_vars == lhs),
      which(.data_vars == rhs)
    )
    .data[kp]
  }, envir = e)
  on.exit(rm(":", envir = e), add = TRUE)
  for (i in seq_along(dots)) {
    vd <- vars.data[i]
    if (grepl("\\S\\:\\S", vd)) {
      vd <- strsplit(vd, ":")[[1]]
      vd <- names(.data)[
        seq(which(names(.data) == vd[1]), which(names(.data) == vd[2]))
      ]
      .d[vd] <- eval(dots[[vars.dots[i]]], .data, e)
    } else {
      .d[[vd]] <- eval(dots[[vars.dots[i]]], .data, e)
    }
  }
  structure(
    .d,
    names = names(.d),
    row.names = .set_row_names(length(.d[[1]])),
    class = c("tbl_data", "tbl_df", "tbl", "data.frame")
  )
}

