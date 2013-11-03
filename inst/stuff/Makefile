vignettes: 
	Rscript -e 'library(knitr); knit("alm_vignette.Rmd"); knit("vignette.Rmd")'
	# pandoc alm_vignette.md -o alm_vignette.tex
	# mv alm_vignette.tex alm_vignette.Rnw
	pandoc -H margins.sty alm_vignette.md -o alm_vignette.pdf
	pandoc -H margins.sty vignette.md -o vignette.pdf
	# cp alm_vignette.Rnw ../../vignettes/alm_vignette.Rnw
	cp vignette.Rmd ../../vignettes/vignette.Rmd
	cp vignette.pdf ../../vignettes/vignette.pdf