# needs

Still in development mode.

`needs` is an R package for safe package loading / installation -- use it in place of `library` to automatically install, then attach, any missing packages.

Supply a minimum version number to update old packages as needed.

`needs` can be used as all or part of an Rprofile or sourced into R code directly, prior to any package loading.

```r
source("needs.R")
needs(dplyr, rvest)
```
### Installation

If you use npm, needs can help make code-sharing easier. Just add this to your package.json dependencies:
```"needs": "joshkatz/needs"```

And use this in your R code:
```r
source("node_modules/needs/needs.R")
needs(knitr)
```

Now if someone else clones your project, they can run your R scripts without worrying about package installation.

### Syntax

Give arguments as unquoted names `needs(shiny)`, character strings `needs("RColorBrewer")`, or as a mixture of the two `needs("dplyr", jsonlite, "magrittr")`.

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
