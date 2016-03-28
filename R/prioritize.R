#' Re-attach packages to prevent masking
#'
#' @description \code{prioritize} detaches packages from the search path, then
#'   re-attaches them, placing them at the beginning of the search path to
#'   prevent masking. This allows for the loading of packages with conflicting
#'   function names in any order.
#'
#' @param ... Packages, given as unquoted names or character strings. Earlier
#'   arguments will be attached later (and therefore get a higher priority).
#'
#' @details If you find yourself calling this function a lot, you're probably
#'   doing something wrong.
#'
#' @examples
#' \dontrun{
#'
#' # loading plyr after dplyr causes badness
#' needs(dplyr, plyr)
#'
#' # prioritize the functions in dplyr
#' prioritize(dplyr)
#'
#' }
#'
#' @export
#'

prioritize <- function(...) {
  if (missing(...)) return(invisible())
  pkgs <- as.list(substitute(list(...)))[-1]
  pos <- if (is.null(names(pkgs))) {
    rep(F, length(pkgs))
  } else {
    nchar(names(pkgs)) > 0
  }

  for (pkg in paste0("package:", pkgs[!pos])) {
    while (pkg %in% search()) {
      detach(pkg, character.only = T, force = T)
    }
  }
  do.call(needs, rev(pkgs[!pos]))
}

