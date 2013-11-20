vignettes: 
	Rscript -e 'library(knitr); knit("rgbif_vignette.Rmd"); knit("rgbif_vignette.Rmd")'
	Rscript -e 'library(knitr); knit("rgbif_vignette_oldapi.Rmd"); knit("rgbif_vignette_oldapi.Rmd")'
	
	pandoc -H margins.sty rgbif_vignette.md -o rgbif_vignette.html
	pandoc -H margins.sty rgbif_vignette.md -o rgbif_vignette.pdf
	pandoc -H margins.sty rgbif_vignette_oldapi.md -o rgbif_vignette_oldapi.html
	pandoc -H margins.sty rgbif_vignette_oldapi.md -o rgbif_vignette_oldapi.pdf
	
	cp rgbif_vignette.md ../../vignettes/rgbif_vignette.md
	cp rgbif_vignette.html ../../vignettes/rgbif_vignette.html
	cp rgbif_vignette.Rmd ../../vignettes/rgbif_vignette.Rmd
	cp rgbif_vignette.pdf ../../vignettes/rgbif_vignette.pdf

	cp rgbif_vignette_oldapi.md ../../vignettes/rgbif_vignette_oldapi.md
	cp rgbif_vignette_oldapi.html ../../vignettes/rgbif_vignette_oldapi.html
	cp rgbif_vignette_oldapi.Rmd ../../vignettes/rgbif_vignette_oldapi.Rmd
	cp rgbif_vignette_oldapi.pdf ../../vignettes/rgbif_vignette_oldapi.pdf