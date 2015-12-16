library(devtools)

options(repos = "https://cran.rstudio.com/")
check(cran = TRUE, check_version = TRUE, manual = TRUE)
write(1, file = "inst/extdata/promptUser")
release(check = F)
