#' Go get a package.
#'
#' Attempts to attach packages. If it fails, first installs, then attaches. Use
#' it in place of \code{library} to automatically install, then attach, any
#' missing packages. Supply a minimum version number to update old packages as
#' needed.
#'
#' \code{needs} can be used as all or part of an \code{\link{Rprofile}} or
#' sourced into R code directly, prior to any package loading.
#'
#' @section Versioning:
#' Syntax for specifying minimum version numbers
#'
#' @param ... Package names, as unquoted names or character strings.
#' @seealso \code{\link{needs-package}}
#' @export

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
				# TODO: better error catching / repo selection here
				install.packages(missing, repos = "http://cran.rstudio.com/",
												 quiet = T)
			}
			# attach packages
			suppressMessages(suppressWarnings(
				sapply(pkgs, library, character = T)))
		}
	}

	if (missing(...)) return(invisible())

	packageInfo <- utils::installed.packages()

	pkgs <- match.call()[-1]
	parsed <- if (is.null(names(pkgs))) {
		as.character(pkgs)
	} else {
		mapply(paste, names(pkgs), as.character(pkgs),
					 MoreArgs = list(sep = ":"))
	}
	parts <- lapply(strsplit(parsed, "[:=(, ]+"), function(d) { d[d != ""] })
	grouped <- split(parts, sapply(parts, length))

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
			update.packages(oldPkgs = toUpdate, ask = F)
		}
		needs_(needsPackage[installed])

	}

	invisible()
}
