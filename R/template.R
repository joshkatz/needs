template <- list(

  render = function(name, contents) {
    insert <- function(text, key) {
      target <- sprintf("\\{\\{#%s\\}\\}", key)
      out <<- gsub(target, text, out)
    }
    out <- template[[as.character(name)]]
    mapply(insert, contents, names(contents))
    out
  },

  parser = 'parser <- function(...) {
  {{#parse}}
  grouped\n}',

  profile = 'tryCatch(needs(), error = function(e) {
  while (".needs" %in% search()) detach(.needs)
  .needs <- new.env(parent = .GlobalEnv)
  .needs$needs <- function(...) {{#body}}

  # attach to the search path
  attach(.needs)\n})\n'

)
