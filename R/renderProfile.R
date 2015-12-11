#' Generate Rprofile
#'
#' Write to Rprofile
#'
#' Writes to Rprofile in the current working directory.
#'
#' @param append Whether to overwrite or append to the current Rprofile, if one exists. Defaults to true.
#'
#' @export

renderProfile <- function(append = T) {
  template <- templates$profile
  body <- paste(deparse(body(needs)), collapse = "\n")
  profileText <- paste0("\n", sub("\\{\\{#body\\}\\}", body, template))
  cat(profileText, file = ".Rprofile", append = append)
}
