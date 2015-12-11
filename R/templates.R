templates <- list(
  profile = 'tryCatch(needs(), error = function(e) {
	while (".needs" %in% search()) detach(.needs)
	.needs <- new.env(parent = .GlobalEnv)
	.needs$needs <- function(...) {{#body}}

	# attach to the search path
	attach(.needs)
})
')
