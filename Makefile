GENERATED_FILES = \
	.git/hooks/pre-commit \
	.git/hooks/post-rewrite \
	man \
	needs.R \
	package.json

SOURCE_FILES = R/*.R

all: $(GENERATED_FILES) $(SOURCE_FILES) _id

clean:
	rm -rf $(GENERATED_FILES) _id

MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

.PHONY: all clean check files

.SECONDARY:

.git/hooks/pre-commit .git/hooks/post-rewrite:
	ln -sf ../../bin/pre-commit $@
	chmod u+x $@

_id: * **/*
	echo 1 > inst/extdata/promptUser
	bin/generate-id > $@

check:
	Rscript --vanilla -e "devtools::check()"

man: $(SOURCE_FILES)
	mkdir -p data
	Rscript --vanilla -e "devtools::document()"	

man/%.Rd:
	make man

needs.R: $(SOURCE_FILES)
	Rscript --vanilla bin/build.R

package.json: DESCRIPTION
	Rscript --vanilla bin/build.R
