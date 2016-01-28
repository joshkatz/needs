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

  # priorities environment
  if (sum(pos) > 0) {
    while (".prioritiesEnv" %in% search()) {
      detach(".prioritiesEnv", character.only = T, force = T)
    }
    .prioritiesEnv <- new.env()
    priorities <- pkgs[pos]
    functions <- unlist(sapply(priorities, eval))
    packages <- rep(names(priorities),
                    sapply(priorities, length) - 1)
    mapply(function(p, f) {
      assign(f, getExportedValue(p, f), envir = .prioritiesEnv)
    }, packages, functions)
    attach(.prioritiesEnv, warn.conflicts = F)
  }
}

