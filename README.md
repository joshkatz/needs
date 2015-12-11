# needs

`needs` is a simple R package for safe package loading / installation &mdash; use it in place of `library` to attach packages and automatically install any that are missing. You can also supply a minimum version number, and it will update old packages as needed. No more changing your code to reinstall packages every time you update R &mdash; `needs` does it for you.

```r
devtools::install_github("joshkatz/needs")
```

### Usage
Use `needs.R` as all or part of an Rprofile or source it into R code directly prior to any package loading. Even better, now you can install as a package &mdash; select "yes" when prompted, then use just as you would `library`.
```r
needs(dplyr, magrittr, rvest)
```

### Rprofile
`needs` can help make code-sharing easier. In your project directory:
```r
needs::renderProfile()
```
This extracts the package contents and appends it to the Rprofile in your working directory. Now if someone else clones your project, your code runs without requiring any extra installation or throwing errors for uninstalled packages.


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
      jsonlite: v0.9.1)
```
