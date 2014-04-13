#' rgbif: A programmatic interface to the Web Service methods provided by the 
#' Global Biodiversity Information Facility.
#' 
#' @section About:
#' 
#' This package gives you access to data from GBIF \url{http://www.gbif.org/} via their API.
#' 
#' @section Transitioning to the new GBIF API:
#' 
#' Note that development is rapid at this point so expect changes, but changes should 
#' slow down with time...
#' 
#' The old GBIF API
#' 
#' \itemize{
#'   \item See documentation here \url{http://data.gbif.org/tutorial/services}
#' }
#'   
#' The new GBIF API
#' 
#' \itemize{
#'   \item See documentation here: \url{http://www.gbif.org/developer/summary}
#' }
#' 
#' The functions for the old GBIF API give deprecation messages, signaling that they are on 
#' their way out. A future version of \code{rgbif} will remove functions for the old API, 
#' so do transition to the functions for the new API soon.
#' 
#' The new GBIF API only uses JSON as a data format - no more XML. Of course this probably 
#' doesn't matter to you unless you are a hacker...
#' 
#' @section Function changes:
#' 
#' Changes in the new GBIF API from last with respect to rgbif, the first 
#' column giving the function name, the second column giving the state of the function 
#' in the new package version, and any reasoning in the third column.
#' 
#' \tabular{lll}{
#'   rgb_country_codes \tab same \tab none \cr
#'   density_spplist \tab deprecated \tab service no longer provided \cr
#'   densitylist \tab deprecated \tab service not provided anymore \cr
#'   gbifdata \tab deprecated \tab not needed \cr
#'   gbifmap_dens \tab deprecated \tab none \cr
#'   gbifmap_list \tab deprecated \tab none \cr
#'   is.gbifdens \tab deprecated \tab none \cr
#'   is.gbiflist \tab deprecated \tab none \cr
#'   networks \tab same \tab some parameters differ \cr
#'   occurrencecount \tab occ_count \tab some parameters differ \cr
#'   occurrencedensity \tab deprecated \tab service not provided anymore \cr
#'   occurrenceget \tab occ_get \tab none \cr
#'   occurrencelist \tab occ_search \tab none \cr
#'   occurrencelist_all \tab occ_search \tab none \cr
#'   occurrencelist_many \tab occ_search \tab none \cr
#'   providers \tab deprecated \tab see note 1 \cr
#'   resources \tab deprecated \tab see note 1 \cr
#'   stylegeojson \tab same \tab not implemented yet \cr
#'   taxoncount \tab deprecated \tab See ?occ_count \cr
#'   taxonget \tab deprecated \tab See ?name_lookup \cr
#'   taxonsearch \tab deprecated \tab See note 2 \cr
#'   taxrank \tab same \tab none \cr
#'   togeojson \tab same \tab not implemented yet
#' }
#' 
#' Note 1: See \code{\link{datasets}}, \code{\link{networks}}, \code{\link{nodes}}, 
#' and \code{\link{organizations}}
#' 
#' Note 2: See \code{\link{name_lookup}} for names across all of GBIF and 
#' \code{\link{name_backbone}} for names only in the GBIF backbone taxonomy.
#' 
#' @docType package
#' @name rgbif
NULL 

#' Deprecated functions in rgbif
#' 
#' \itemize{
#'  \item \code{\link{density_spplist}}: service no longer provided
#'  \item \code{\link{densitylist}}: service no longer provided
#'  \item \code{\link{gbifdata}}: service no longer provided
#'  \item \code{\link{gbifmap_dens}}: service no longer provided
#'  \item \code{\link{gbifmap_list}}: service no longer provided
#'  \item \code{\link{is.gbifdens}}: service no longer provided
#'  \item \code{\link{is.gbiflist}}: service no longer provided
#'  \item \code{\link{occurrencedensity}}: service no longer provided
#'  \item \code{\link{providers}}: service no longer provided
#'  \item \code{\link{resources}}: service no longer provided
#'  \item \code{\link{taxoncount}}: service no longer provided
#'  \item \code{\link{taxonget}}: service no longer provided
#'  \item \code{\link{taxonsearch}}: service no longer provided
#' }
#' 
#' @name rgbif-deprecated
NULL

#' Table of country two character ISO codes, and GBIF names
#' 
#' \itemize{
#'   \item code. Two character ISO country code.
#'   \item name. Name of country.
#'   \item gbif_name. Name of country used by GBIF - this is the name
#'   you want to use when searching by country in this package.
#' }
#' 
#' @name isocodes
#' @docType data
#' @keywords data
NULL

#' Type status options for GBIF searching
#' 
#' \itemize{
#'   \item name. Name of type.
#'   \item description. Description of the type.
#' }
#' 
#' @name typestatus
#' @docType data
#' @keywords data
NULL