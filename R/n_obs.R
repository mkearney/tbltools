#' Number of observersations
#'
#' Returns number of observations in group (if no group then number of obs
#' in data frame)
#'
#' @return Number of observations in group
#' @export
n_obs <- function() {
  vars <- ls(all.names = TRUE, envir = parent.frame())
  if (length(vars) == 0) return(0)
  length(get(vars[1], envir = parent.frame()))
}

#' @export
foo_e <- function() {
  structure(
    environment(),
    class = "environment",
    name = "..tbltools::mutate"
  )
}
