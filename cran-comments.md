## Test environments
* local OS X install, R 3.2.3
* win-builder (devel and release)

## R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 NOTE: it is the first time this package has been submitted.

## Downstream dependencies
There are currently no downstream dependencies for this package.

## Additional notes
When the package is loaded in an interactive session for the first time, users are asked to confirm whether they want to allow the package to autoload. If yes, the following line is appended to the `Rprofile.site` system file:

autoloads("needs", "needs")

If no, no action is taken and the user is not prompted again.
