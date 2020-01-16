PACKAGE := $(shell grep '^Package:' DESCRIPTION | sed -E 's/^Package:[[:space:]]+//')
RSCRIPT = Rscript --no-init-file

all: move rmd2md

move:
		cp inst/vign/rgbif_vignette.md vignettes;\
		cp inst/vign/issues.md vignettes;\
		cp inst/vign/taxonomic_names.md vignettes;\
		cp inst/vign/downloads.md vignettes;\
		cp -r inst/vign/figure/ vignettes/figure/

rmd2md:
		cd vignettes;\
		mv rgbif_vignette.md rgbif.Rmd;\
		mv issues.md issues.Rmd;\
		mv taxonomic_names.md taxonomic_names.Rmd;\
		mv downloads.md downloads.Rmd

install: doc build
	R CMD INSTALL . && rm *.tar.gz

build:
	R CMD build .

doc:
	${RSCRIPT} -e "devtools::document()"

eg:
	${RSCRIPT} -e "devtools::run_examples()"

codemeta:
	${RSCRIPT} -e "codemetar::write_codemeta()"

check: build
	_R_CHECK_CRAN_INCOMING_=FALSE R CMD CHECK --as-cran --no-manual `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -f `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -rf ${PACKAGE}.Rcheck

test:
	${RSCRIPT} -e 'devtools::test()'
