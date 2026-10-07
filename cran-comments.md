## Test environments

* local windows, R 4.2.3
* windows latest R "release" version (GitHub Actions)
* ubuntu latest, R "release" version (GitHub Actions)
* macOS latest, R "release" version (GitHub Actions)
* winbuilder (R-devel, 2026-08-17 r90424)

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

I have run R CMD check on 26 reverse dependencies, comparing the CRAN and
development versions of rgbif. Results:
<https://github.com/ropensci/rgbif/actions/runs/37003298289>

* One package has a new test failure: intSDM (2.1.2). The failure is in
  `test-species_model.R:317`, where intSDM's `workflow$biasFields()` test
  encounters an error about a dataset not being included in the workflow.
  This appears unrelated to changes in rgbif.
* Six package checks timed out with both the CRAN and development versions:
  caretSDM, geoflow, intSDM, RuHere, taxify, and tidysdm.
* geoflow also reports an unused Imports NOTE for `lwgeom` and `smoothr` in
  both versions.

## Breaking changes

This release includes a major breaking change: the default taxonomy has changed 
from GBIF Backbone to COL (Catalogue of Life) Extended Release. 

**Backward compatibility**: Existing code using numeric taxonomic keys will 
continue to work. The package automatically detects numeric keys and switches 
to the GBIF Backbone taxonomy with a warning message, giving users time to 
migrate at their own pace.

**Migration support**: 
* A new function `gbif_to_col()` helps users convert existing GBIF Backbone 
  numeric keys to COL XR alpha-numeric keys
* A comprehensive migration guide vignette is included
* See NEWS.md for full details

--------

Hello,

This version includes a major taxonomy migration GBIF Backbone to COL XR along with new features and bug fixes. All reverse dependency maintainers have been notified on 08-19-2026. 

Thanks!
John Waller