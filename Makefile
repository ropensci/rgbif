PACKAGE := $(shell grep '^Package:' DESCRIPTION | sed -E 's/^Package:[[:space:]]+//')
RSCRIPT = Rscript --no-init-file

vignettes:
	cd vignettes;\
	${RSCRIPT} -e "Sys.setenv(NOT_CRAN='true'); knitr::knit('rgbif.Rmd.og', output = 'rgbif.Rmd'); knitr::knit('taxonomic_names.Rmd.og', output = 'taxonomic_names.Rmd'); knitr::knit('gbif_citations.Rmd.og', output = 'gbif_citations.Rmd'); knitr::knit('downloading_a_long_species_list.Rmd.og', output = 'downloading_a_long_species_list.Rmd'); knitr::knit('getting_occurrence_data.Rmd.og', output = 'getting_occurrence_data.Rmd'); knitr::knit('gbif_credentials.Rmd.og', output = 'gbif_credentials.Rmd'); knitr::knit('multiple_values.Rmd.og', output = 'multiple_values.Rmd')"\
	cd ..

install: doc build
	R CMD INSTALL . && rm *.tar.gz

build:
	R CMD build .

doc:
	${RSCRIPT} -e "devtools::document()"

eg:
	${RSCRIPT} -e "Sys.setenv(RGBIF_BASE_URL='https://api.gbif-uat.org/v1'); cat(paste0('gbif api base url: ', Sys.getenv('RGBIF_BASE_URL', 'api.gbif.org/v1'), '\n')); devtools::run_examples(run = TRUE)"

codemeta:
	${RSCRIPT} -e "codemetar::write_codemeta()"

check: build
	_R_CHECK_CRAN_INCOMING_=FALSE R CMD CHECK --as-cran --no-manual `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -f `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -rf ${PACKAGE}.Rcheck

check_windows:
	${RSCRIPT} -e "devtools::check_win_devel(); devtools::check_win_release()"

test:
	${RSCRIPT} -e 'devtools::test()'

readme:
	${RSCRIPT} -e 'knitr::knit("README.Rmd")'
