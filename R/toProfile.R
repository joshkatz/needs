#' Append to Rprofile in current working directory.
#'
#' Exports the package functionality to .Rprofile in the current working
#' directory. Now the same code you run can be run on another system without
#' requiring any extra installation or throwing errors for uninstalled packages.
#'
#' @param dir Target directory for Rprofile. Defaults to working directory.
#'
#' @param append Whether to append to the current Rprofile, if one exists. Set
#'   to false to overwrite.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' toProfile()
#' }
#'

toProfile <- function(dir = NULL, append = T) {
  contents <- paste(c("", deparse(needs:::install)), collapse = "\n")
  dir <- ifelse(is.null(dir), getwd(), dir)
  path <- file.path(dirname(dir), basename(dir), ".Rprofile")
  cat(contents, file = path, append = append)
}
