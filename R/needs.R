#' Attach/install packages
#'
#' @description \code{needs} loads and attaches packages, automatically
#'   installing (and attaching) any it can't find in your libraries. It accepts
#'   any number of arguments, given as names or character strings. Optionally,
#'   supply a minimum version on a per-package basis to update old packages as
#'   needed.
#'
#' @param ... Packages, given as unquoted names or character strings. Specify a
#'   required package version as \code{package = "version"}.
#'
#' @param .printConflicts Logical, specifying whether to print a summary of
#'   objects that exist in multiple places on the search path along with their
#'   respective locations. Set to \code{TRUE} to identify any masked functions.
#'   Objects in the base package and the global environment are ignored.
#'   Defaults to \code{FALSE}.
#'
#' @details Recommended use is to allow the function to autoload when prompted
#'   the first time the package is loaded interactively. To change this setting
#'   later, run \code{needs:::autoload(TRUE)} or \code{needs:::autoload(FALSE)}
#'   to turn autoloading on or off, respectively.
#'
#' @seealso \code{\link{needs-package}}
#' @export
#'
#' @examples
#' \dontrun{
#' needs()   # returns NULL
#'
#' needs(foo, bar)
#'
#' # require a minimum version
#' needs(foo,
#'       bar = "0.9.1",
#'       baz = "0.4.3")
#'
#'
#' }
#'


needs <- function(..., .printConflicts = F) {
  needs_ <- function(...) {
    pkgs <- unlist(...)
    if (length(pkgs)) {
      loaded <- suppressWarnings(suppressMessages(
        sapply(pkgs, library, character = T, logical = T)))
      if (any(!loaded)) {
        missing <- pkgs[!loaded]
        cat("installing packages:\n")
        cat(missing, sep = "\n")
        utils::install.packages(missing,
                                quiet = T)
      }
      # attach packages
      suppressWarnings(suppressMessages(sapply(pkgs, library, character = T)))
    }
  }

  packageInfo <- utils::installed.packages()

  #{{parse}}
  if (!missing(...)) {

    pkgs <- as.list(substitute(list(...)))[-1]
    parsed <- if (is.null(names(pkgs))) {
      as.character(pkgs)
    } else {
      mapply(paste, names(pkgs), as.character(pkgs),
             MoreArgs = list(sep = ":"))
    }
    parts <- lapply(strsplit(parsed, "[:=(, ]+"), function(d) { d[d != ""] })
    grouped <- split(parts, sapply(parts, length))
    #{{/parse}}

    # load latest/current version of packages
    needs_(grouped$`1`)

    # if version specified...
    toCheck <- grouped$`2`

    if (length(toCheck)) {
      installedPackages <- packageInfo[, "Package"]
      needsPackage <- sapply(toCheck, `[`, 1)
      needsVersion <- sapply(toCheck, function(x) {
        gsub("[^0-9.-]+", "", x[2])
      })

      installed <- needsPackage %in% installedPackages
      needs_(needsPackage[!installed])

      compared <- mapply(utils::compareVersion, needsVersion[installed],
                         packageInfo[needsPackage[installed], "Version"])
      if (any(compared == 1)) {
        toUpdate <- needsPackage[installed][compared == 1]
        cat("updating packages:\n")
        cat(toUpdate, sep = "\n")
        utils::update.packages(oldPkgs = toUpdate, ask = F)
      }
      needs_(needsPackage[installed])
    }

  }

  if (.printConflicts) {
    s <- search()
    conflict <- conflicts(detail = T)
    conflict[names(conflict) %in% c("package:base", "Autoloads", ".GlobalEnv")] <- NULL
    tab <- table(unlist(sapply(conflict, unique)))
    fxns <- names(tab[tab > 1])
    where <- sapply(fxns, function(f) {
      i <- 1
      while (!length(ls(pos = i, pattern = sprintf("^%s$", f)))) {
        i <- i + 1
        if (i > length(s)) break
      }
      s[i]
    })
    if (length(where)) {
      df <- data.frame(FUNCTION = names(where),
                       LOCATION = paste0("   ", where[order(names(where))]),
                       stringsAsFactors = F)
      print(df, row.names = F)
    }
  }

  invisible()
}
