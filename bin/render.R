library(rmarkdown)

render("readme-src.Rmd", output_file = "README.md",
       html_document(keep_md = T, variant = "markdown_github"),
       quiet = T)
