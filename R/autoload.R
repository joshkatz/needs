autoload <- function(flag) {
  sysfile <- system.file("extdata", "promptUser", package = "needs")
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

  if (flag) {
    if (!any(grepl("^[:blank:]*autoload\\(\"needs\", \"needs\"\\)", lines))) {
      write('\n\nautoload("needs", "needs")\n\n', file = siteProfile, append = T)
    }
  } else {
    lines[grepl("^[:blank:]*autoload\\(\"needs\", \"needs\"\\)", lines)] <- ""
    k <- write(paste(lines, collapse = "\n"), file = siteProfile, append = F)
  }

  close(cxn)
  options(needs.promptUser = F)
  write(0, file = sysfile)

  return(flag)
}
