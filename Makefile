all: move pandoc rmd2md

vignettes: 
		cd inst/vign;\
		Rscript -e 'library(knitr); knit("rgbif_vignette.Rmd"); knit("rgbif_vignette.Rmd")'
		Rscript -e 'library(knitr); knit("rgbif_vignette_oldapi.Rmd"); knit("rgbif_vignette_oldapi.Rmd")'

move:
		cp inst/vign/rgbif_vignette.md vignettes;\
		cp inst/vign/rgbif_vignette_oldapi.md vignettes;\
		cp -r inst/vign/figure/ vignettes/figure/

pandoc:
		cd vignettes;\
		pandoc -H margins.sty rgbif_vignette.md -o rgbif_vignette.html;\
		pandoc -H margins.sty rgbif_vignette.md -o rgbif_vignette.pdf;\
		pandoc -H margins.sty rgbif_vignette_oldapi.md -o rgbif_vignette_oldapi.html;\
		pandoc -H margins.sty rgbif_vignette_oldapi.md -o rgbif_vignette_oldapi.pdf

rmd2md:
		cd vignettes;\
		cp rgbif_vignette.md rgbif_vignette.Rmd;\
		cp rgbif_vignette_oldapi.md rgbif_vignette_oldapi.Rmd

cleanup:
		cd inst/vign;\
		rm rgbif_vignette.md rgbif_vignette_oldapi.md
		rm -r vignettes/figure/