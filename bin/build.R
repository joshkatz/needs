
### write needs.R ###
source("R/needs.R")
source("R/toProfile.R")
source("R/template.R")

toProfile(append = F)
invisible(file.rename(".Rprofile", "needs.R"))
