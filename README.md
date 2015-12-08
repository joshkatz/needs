# needs

`needs` is an R function for safe package loading / installation -- use it in place of `library` to automatically install, then attach, any missing packages.

Supply a minimum version number to update packages as needed.

`needs` can be used as all or part of an Rprofile or sourced into R code directly, prior to any package loading.

```r
source("needs.R")
needs(dplyr, rvest)
```

### Syntax

Give arguments as unquoted names `needs(dplyr)`, as character strings `needs("dplyr")`, or as a mixture of the two `needs("dplyr", jsonlite, "magrittr")`.

You can specify a required package version using `:` or as a pairlist:
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
