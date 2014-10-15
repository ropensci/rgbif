all: move rmd2md

move:
		cp inst/vign/rgbif_vignette.md vignettes;\
		cp inst/vign/issues_vignette.md vignettes;\
		cp -r inst/vign/figure/ vignettes/figure/

rmd2md:
		cd vignettes;\
		mv rgbif_vignette.md rgbif_vignette.Rmd;\
		mv issues_vignette.md issues_vignette.Rmd
