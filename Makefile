all: move rmd2md

vignettes:
		cd inst/vign;\
		Rscript --vanilla -e 'library(knitr); knit("rgbif_vignette.Rmd"); knit("rgbif_vignette.Rmd")'

move:
		cp inst/vign/rgbif_vignette.md vignettes;\
		cp -r inst/vign/figure/ vignettes/figure/

# pandoc:
# 		cd vignettes;\
# 		pandoc -H margins.sty rgbif_vignette.md -o rgbif_vignette.html --highlight-style=tango;\
# 		pandoc -H margins.sty rgbif_vignette.md -o rgbif_vignette.pdf --highlight-style=tango;\
# 		pandoc -H margins.sty rgbif_vignette_oldapi.md -o rgbif_vignette_oldapi.html --highlight-style=tango;\
# 		pandoc -H margins.sty rgbif_vignette_oldapi.md -o rgbif_vignette_oldapi.pdf --highlight-style=tango

rmd2md:
		cd vignettes;\
		mv rgbif_vignette.md rgbif_vignette.Rmd

# cleanup:
# 		cd inst/vign;\
# 		rm rgbif_vignette.md rgbif_vignette_oldapi.md
# 		rm -r vignettes/figure/
