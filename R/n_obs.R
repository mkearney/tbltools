#' Number of observersations
#'
#' Returns number of observations in group (if no group then number of obs
#' in data frame)
#'
#' @return Number of observations in group
#' @export
n_obs <- function() {
  if (identical(call_env(), base::.GlobalEnv)) {
    stop("`n_obs()` should not be used in global environment", call. = FALSE)
  }
  vars <- ls(all.names = TRUE, envir = call_env(), sorted = TRUE)
  if (length(vars) == 0) return(0)
  lens <- integer(length(vars))
  for (i in seq_along(vars)) {
    lens[i] <- length(get(vars[i], envir = call_env()))
  }
  max(lens)
}
