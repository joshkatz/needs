tryCatch(needs(), error = function(e) {
  while (".needs" %in% search()) detach(.needs)
  .needs <- new.env(parent = .GlobalEnv)
  .needs$needs <- function(...) 
{
    needs_ <- function(...) {
        pkgs <- unlist(...)
        if (length(pkgs)) {
            loaded <- suppressWarnings(suppressMessages(sapply(pkgs, 
                library, character = T, logical = T)))
            if (any(!loaded)) {
                missing <- pkgs[!loaded]
                cat("installing packages:n")
                cat(missing, sep = "n")
                utils::install.packages(missing,
                  quiet = T)
            }
            suppressWarnings(suppressMessages(sapply(pkgs, library, 
                character = T)))
        }
    }
    packageInfo <- utils::installed.packages()
    if (!missing(...)) {
        pkgs <- as.list(substitute(list(...)))[-1]
        parsed <- if (is.null(names(pkgs))) {
            as.character(pkgs)
        }
        else {
            mapply(paste, names(pkgs), as.character(pkgs), MoreArgs = list(sep = ":"))
        }
        parts <- lapply(strsplit(parsed, "[:=(, ]+"), function(d) {
            d[d != ""]
        })
        grouped <- split(parts, sapply(parts, length))
        needs_(grouped$`1`)
        toCheck <- grouped$`2`
        if (length(toCheck)) {
            installedPackages <- packageInfo[, "Package"]
            needsPackage <- sapply(toCheck, `[`, 1)
            needsVersion <- sapply(toCheck, function(x) {
                gsub("[^0-9.-]+", "", x[2])
            })
            installed <- needsPackage %in% installedPackages
            needs_(needsPackage[!installed])
            compared <- mapply(utils::compareVersion, needsVersion[installed], 
                packageInfo[needsPackage[installed], "Version"])
            if (any(compared == 1)) {
                toUpdate <- needsPackage[installed][compared == 
                  1]
                cat("updating packages:n")
                cat(toUpdate, sep = "n")
                utils::update.packages(oldPkgs = toUpdate, ask = F)
            }
            needs_(needsPackage[installed])
        }
    }
    if (.printConflicts) {
        s <- search()
        conflict <- conflicts(detail = T)
        conflict[names(conflict) %in% c("package:base", "Autoloads", 
            ".GlobalEnv")] <- NULL
        tab <- table(unlist(sapply(conflict, unique)))
        fxns <- names(tab[tab > 1])
        where <- sapply(fxns, function(f) {
            i <- 1
            while (!length(ls(pos = i, pattern = sprintf("^%s$", 
                f)))) {
                i <- i + 1
                if (i > length(s)) 
                  break
            }
            s[i]
        })
        if (length(where)) {
            df <- data.frame(FUNCTION = names(where), LOCATION = paste0("   ", 
                where[order(names(where))]), stringsAsFactors = F)
            print(df, row.names = F)
        }
    }
    invisible()
}

  # attach to the search path
  attach(.needs)
})
