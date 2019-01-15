#' Number of observersations
#'
#' Returns number of observations in group (if no group then number of obs
#' in data frame)
#'
#' @return Number of observations in group
#' @export
n_obs <- function() {
  if (identical(parent.frame(), base::.GlobalEnv)) {
    stop("n_obs() should not be used in global environment", call. = FALSE)
  }
  vars <- ls(all.names = TRUE, envir = parent.frame())
  if (length(vars) == 0) return(0)
  length(get(vars[1], envir = parent.frame()))
}
