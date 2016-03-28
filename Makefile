GENERATED_FILES = \
	.git/hooks/pre-commit \
	.git/hooks/post-rewrite \
	man \
	needs.R \
	README.md

SOURCE_FILES = R/*.R

all: $(GENERATED_FILES) $(SOURCE_FILES)

clean:
	rm -rf $(GENERATED_FILES)

MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

.PHONY: all clean check

.SECONDARY:

.git/hooks/pre-commit .git/hooks/post-rewrite:
	ln -sf ../../bin/pre-commit $@
	chmod u+x $@

check:
	Rscript -e "devtools::check()"
	echo 1 > inst/extdata/promptUser

man: $(SOURCE_FILES)
	mkdir -p man
	Rscript --vanilla -e "devtools::document()"	

man/%.Rd:
	make man

README.md: readme-src.Rmd
	Rscript --vanilla bin/render.R

needs.R: $(SOURCE_FILES)
	Rscript --vanilla bin/build.R
