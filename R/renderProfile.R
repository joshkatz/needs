#' Append to Rprofile in current working directory.
#'
#' Exports the package functionality to .Rprofile in the current working
#' directory. Now the same code you run can be run on another system without
#' requiring any extra installation or throwing errors for uninstalled packages.
#'
#' @param append Whether to append to the current Rprofile, if one exists. Set
#'   to false to overwrite.
#'
#' @export

renderProfile <- function(append = T) {
  template <- templates$profile
  body <- paste(deparse(body(needs)), collapse = "\n")
  profileText <- paste0("\n", sub("\\{\\{#body\\}\\}", body, template))
  cat(profileText, file = ".Rprofile", append = append)
}
