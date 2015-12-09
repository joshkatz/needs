# needs

`needs` is an R function for safe package loading / installation &mdash; use it in place of `library` to attach packages and automatically install any that are missing. You can also supply a minimum version number, and it will update old packages as needed. No more changing your code to reinstall packages every time you update R &mdash; `needs` does it for you.

### Usage
Use `needs.R` as all or part of an Rprofile or source it into R code directly prior to any package loading.

##### Rprofile
One-line installer:
```
curl https://raw.githubusercontent.com/joshkatz/needs/master/needs.R >> ~/.Rprofile
```
Now within R, use `needs` just as you would `library`.
```r
needs(dplyr, rvest)
```

##### Source
If you use npm, needs can help make code-sharing easier. In your project directory:
```
npm install joshkatz/needs --save
```
In your R code:
```r
source("node_modules/needs/needs.R")
needs(dplyr, rvest)
```
Now if someone else clones your project, they can run your R scripts without worrying about package installation.

### Syntax

Give arguments as unquoted names `needs(shiny)`, character strings `needs("RColorBrewer")`, or a mixture of the two `needs("knitr", jsonlite, "magrittr")`.

You can specify a required package version using `:` or with a pairlist:
```r
needs(dplyr = "0.4.3",
      jsonlite: `0.9.1`)
```

Alternate syntax is okay too.
```r
needs(jsonlite(v0.9.1),
      "jsonlite = 0.9.1",
      jsonlite: v0.9.1,
      jsonlite/v0.9.1,
      jsonlite: "0.9.1")
```
