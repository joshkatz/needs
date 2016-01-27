#' Re-attach packages to prevent masking.
#'
#' @description \code{prioritize} detaches packages from the search path, then re-attaches them, placing them at the beginning of the search path to prevent masking.
#'
#' @param ... Packages, given as unquoted names or character strings. Earlier arguments will be attached later (and therefore get a higher priority).
#'
#' @export
#'

prioritize <- function(...) {
  if (missing(...)) return(invisible())
  pkgs <- as.list(substitute(list(...)))[-1]
  for (pkg in paste0("package:", packages)) {
    while (pkg %in% search()) {
      detach(pkg, character.only = T, force = T)
    }
  }
  do.call(needs, rev(packages))
}

