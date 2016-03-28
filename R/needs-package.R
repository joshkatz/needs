#' Easier package loading / auto-installation
#'
#' @docType package
#' @name needs-package
#' @description \strong{needs} is a simple R function to make package loading /
#' installation hassle-free --- use it in place of \code{library} to attach
#' packages and automatically install any that are missing. You can also supply
#' a minimum version number, and it will update old packages as needed. No more
#' changing your code to reinstall packages every time you update R ---
#' \code{needs} does it for you.
#' @author Josh Katz
#' @references Source repo: \url{http://www.github.com/joshkatz/needs}
NULL

.onLoad <- function(libname, pkgname) {
  while (".needs" %in% search()) detach(.needs)
  sysfile <- system.file("extdata", "promptUser", package = "needs")
  promptUser <- as.logical(scan(sysfile, quiet = T))
  options(needs.promptUser = promptUser)

  if (getOption("needs.promptUser")) {

    if (interactive()) {

      q <- "Should `needs` load itself when it's... needed?\n  (this is recommended)"
      choices <- sample(c("Yes", "No"))
      yes <- choices[utils::menu(choices, title = q)] == "Yes"

      if (isTRUE(yes)) {

        siteProfile <- if (is.na(Sys.getenv("R_PROFILE", unset = NA))) {
          file.path(Sys.getenv("R_HOME"), "etc", "Rprofile.site")
        } else {
          Sys.getenv("R_PROFILE")
        }
        if (!file.exists(siteProfile)) {
          file.create(siteProfile)
        }
        cxn <- file(siteProfile)
        lines <- readLines(cxn)
        if (!any(grepl("^[:blank:]*autoload\\(\"needs\", \"needs\"\\)", lines))) {
          write('\n\nautoload("needs", "needs")\n\n', file = siteProfile, append = T)
        }
        close(cxn)

      }

      options(needs.promptUser = F)
      write(0, file = sysfile)

    }
  }
}

.onAttach <- function(libname, pkgname) {
  if (getOption("needs.promptUser") && !interactive()) {
    packageStartupMessage("\nLoad `package:needs` in an interactive session to set auto-load flag\n")
  }
}
