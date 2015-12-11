GENERATED_FILES = \
	.git/hooks/pre-commit \
	.git/hooks/post-rewrite \
	inst/extdata/promptUser \
	man/* \
	needs.R \
	package.json

all: $(GENERATED_FILES)

clean:
	rm -rf $(GENERATED_FILES)

MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

.PHONY: all clean check files

.git/hooks/pre-commit .git/hooks/post-rewrite:
	ln -sf ../../bin/pre-commit $@
	chmod u+x $@

check: R/*
	Rscript --vanilla -e "devtools::check()"

man/%.Rd: R/%.R
	Rscript --vanilla -e "devtools::document()"	

files:
	Rscript --vanilla build-src/build.R

needs.R: R/*
	make files

package.json: DESCRIPTION
	make files

inst/extdata/promptUser:
	echo 1 > $@
