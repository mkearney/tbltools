
#' tabsort
#'
#' Returns a sorted (descending) frequency tbl
#'
#' @param .data Data
#' @param ... Unquoted column names of variables to include in table. Default
#'   is to use all columns.
#' @param prop Logical indicating whether to include a proportion of total
#'   obs column.
#' @param sort Logical indicating whether to sort the returned object.
#' @param na_omit Logical indicating whether to exclude missing. If all
#'   responses are missing, a missing value is used as the single category.
#' @return Frequency tbl
#' @examples 
#' 
#' x <- sample(letters[1:4], 200, replace = TRUE)
#' y <- sample(letters[5:8], 200, replace = TRUE)
#' dat <- data.frame(x, y)
#' tabsort(x)
#' tabsort(dat, x)
#' tabsort(dat, x, y)
#' 
#' @export
tabsort <- function(.data, ..., prop = TRUE, na_omit = TRUE, sort = TRUE) {
  vars <- names(rlang::enquos(...))
  if (any(vars == "")) {
    vars2 <- rlang::enquos(...)
    vars2 <- sapply(vars2[vars == ""], function(.x) encodeString(as.character(.x)[2]))
    vars[vars == ""] <- vars2
  }
  if (!is.logical(prop)) {
    stop("'prop' should be logical, indicating whether to return proportions. ",
      "If you supplied a vector with the name 'prop' please rename to ",
      "something else", call. = FALSE)
  }
  ## if only named objects are supplied
  if (missing(.data) && length(vars) > 0) {
    .data <- data.frame(..., stringsAsFactors = FALSE)

    ## if no data at all is supplied
  } else if (missing(.data)) {
    stop("must supply data or named object")

    ## if unnamed atomic vector & one or more named objects are supplied
  } else if (!is.recursive(.data) && length(vars) > 0) {

    ## if .data is already a name, then find a simple alphanumeric name to use
    ## otherwise just name it .data
    if (".data" %in% vars) {
      assignname <- NULL
      i <- 0
      ltrs <- letters
      while (is.null(assignname) || assignname %in% vars) {
        i <- i + 1
        if (i > length(ltrs)) {
          i <- 1
          if (any(grepl("[A-Z]", ltrs))) {
            ltrs <- paste0(tolower(ltrs), i)
          } else if (any(grepl("[a-z]", ltrs)) & any(grepl("[0-9]", ltrs))) {
            ltrs <- paste0(LETTERS, i)
          } else {
            ltrs <- toupper(ltrs)
          }
        }
        assignname <- ltrs[i]
      }
    } else {
      assignname <- ".data"
    }
    ## if "n" in vars, rename with dot
    if ("n" %in% vars) {
      warning("variable n renamed to .n", call. = FALSE)
      vars[vars == "n"] <- ".n"
    }
    .data <- structure(list(.data, ...), class = "list", names = c(assignname, vars))

    ## if single unnamed vector is supplied
  } else if (!is.recursive(.data)) {
    .data <- data.frame(x = .data, stringsAsFactors = FALSE)

    ## otherwise use tidy selection of any supplied var names
  } else {
    .data <- tidyselector(.data, ...)
    if ("n" %in% names(.data)) {
      warning("variable n renamed to .n", call. = FALSE)
      names(.data)[names(.data) == "n"] <- ".n"
    }
    if ("prop" %in% names(.data)) {
      warning("variable prop renamed to .prop", call. = FALSE)
      names(.data)[names(.data) == "prop"] <- ".prop"
    }
  }
  if (na_omit) {
    .data <- tfse::na_omit(.data)
  }
  x <- as_tbl(do.call("table", .data))
  if (prop) {
    x$prop <- x$n / sum(x$n, na.rm = TRUE)
  }
  if (sort) {
    x <- x[order(x$n, decreasing = TRUE), ]
  }
  x
}


#' @inheritParams tabsort
#' @rdname tabsort
#' @export
ntbl <- function(.data, ...) {
  .data <- rlang::with_env(.data, tidyselector(.data, ...))
  as_tbl(table(.data))
}
