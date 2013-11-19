vignettes: 
	Rscript -e 'library(knitr); knit("rgbif_vignette.Rmd"); knit("rgbif_vignette.Rmd")'
	Rscript -e 'library(knitr); knit("rgbif_vignette_oldapi.Rmd"); knit("rgbif_vignette_oldapi.Rmd")'
	# pandoc alm_vignette.md -o alm_vignette.tex
	# mv alm_vignette.tex alm_vignette.Rnw
	pandoc -H margins.sty rgbif_vignette.md -o rgbif_vignette.pdf
	pandoc -H margins.sty rgbif_vignette_oldapi.md -o rgbif_vignette_oldapi.pdf
	# cp alm_vignette.Rnw ../../vignettes/alm_vignette.Rnw
	cp rgbif_vignette.Rmd ../../vignettes/rgbif_vignette.Rmd
	cp rgbif_vignette_oldapi.Rmd ../../vignettes/rgbif_vignette_oldapi.Rmd
	cp rgbif_vignette.pdf ../../vignettes/rgbif_vignette.pdf
	cp rgbif_vignette_oldapi.pdf ../../vignettes/rgbif_vignette_oldapi.pdf