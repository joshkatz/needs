#' Attach/install packages.
#'
#' @description \code{needs} loads and attaches packages, automatically installing (and attaching) any it can't find in your libraries. It accepts any number of arguments, given as names or character strings. Optionally, supply a minimum version on a per-package basis to update old packages as needed.
#'
#' @param ... Packages, given as unquoted names or character strings. Specify a required package version as \code{package = "version"}.
#'
#' @details Recommended use is to allow the function to autoload when prompted the
#' first time the package is loaded interactively. To change this setting later,
#' run \code{needs:::autoload(TRUE)} or \code{needs:::autoload(FALSE)} to turn
#' autoloading on or off, respectively.
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
#' }
#'

needs <- function(...) {
  needs_ <- function(...) {
    pkgs <- unlist(...)
    if (length(pkgs)) {
      loaded <- suppressMessages(suppressWarnings(
        sapply(pkgs, library, character = T, logical = T)))
      if (any(!loaded)) {
        missing <- pkgs[!loaded]
        cat("installing packages:\n")
        cat(missing, sep = "\n")
        utils::install.packages(missing, repos = "http://cran.rstudio.com/",
                                quiet = T)
      }
      # attach packages
      suppressMessages(suppressWarnings(
        sapply(pkgs, library, character = T)))
    }
  }

  packageInfo <- utils::installed.packages()

  #{{parse}}
  if (missing(...)) return(invisible())
  pkgs <- match.call()[-1]
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

  invisible()
}
