library(jsonlite)
library(yaml)

### write package.json ###
config <- yaml.load_file("DESCRIPTION")
authors <- eval(parse(text = config$`Authors@R`))
author <- authors[[sapply(authors, function(d) {
  "aut" %in% d$role
})]]


out <- list(
  name = config$Package,
  version = config$Version,
  description = config$Description,
  author = list(
    name = paste(author$given, author$family),
    email = author$email
  ),
  repository = paste(tail(strsplit(config$URL, "/")[[1]], 2), collapse = "/")
)

cat(toJSON(out, pretty = T, auto_unbox = T), file = "package.json")


### write needs.R ###
source("R/needs.R")
source("R/toProfile.R")
source("R/template.R")

toProfile(append = F)
file.rename(".Rprofile", "needs.R")
