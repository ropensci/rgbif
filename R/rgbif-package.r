#' @title Interface to the Global Biodiversity Information Facility API.
#'
#' @description rgbif: A programmatic interface to the Web Service methods provided by the
#' Global Biodiversity Information Facility.
#'
#' @section About:
#'
#' This package gives you access to data from GBIF \url{http://www.gbif.org/} via their API.
#'
#' @section A note about the old GBIF API:
#'
#' The old GBIF API was at \url{http://data.gbif.org/tutorial/services}, but is now defunct -
#' that is, not available anymore. We used to have functions that worked with the old API, but
#' those functions are now not available anymore because GBIF made the old API defunct.
#'
#' @section Documentation for the GBIF API:
#'
#' \itemize{
#'   \item summary \url{http://www.gbif.org/developer/summary} - Summary of the GBIF API
#'   \item registry \url{http://www.gbif.org/developer/registry} - Metadata on datasets, and
#'   contributing organizations
#'   \item species names \url{http://www.gbif.org/developer/species} - Species names and metadata
#'   \item occurrences \url{http://www.gbif.org/developer/occurrence} - Occurrences
#'   \item maps \url{http://www.gbif.org/developer/maps} - Maps - these APIs are not implemented
#'   in \code{rgbif}, and are meant more for intergration with web based maps.
#' }
#'
#' @importFrom methods is
#' @importFrom utils browseURL head unzip packageVersion
#' @importFrom stats na.omit complete.cases
#' @importFrom data.table rbindlist fread setDF
#' @importFrom ggplot2 geom_point position_jitter map_data ggplot
#' geom_polygon aes scale_color_brewer labs theme_bw theme guides
#' guide_legend coord_fixed element_blank
#' @importFrom httr GET POST DELETE HEAD content stop_for_status http_status
#' add_headers authenticate write_disk content_type_json accept_json
#' user_agent
#' @importFrom xml2 read_xml xml_text xml_find_all
#' @importFrom jsonlite toJSON fromJSON
#' @importFrom oai id list_identifiers list_records list_metadataformats
#' list_sets get_records
#' @importFrom geoaxe chop to_wkt
#' @name rgbif-package
#' @aliases rgbif
#' @docType package
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @author Karthik Ram \email{karthik@@ropensci.org}
#' @author Dan Mcglinn \email{danmcglinn@@gmail.com}
#' @author Vijay Barve \email{vijay.barve@@gmail.com}
NULL

#' Defunct functions in rgbif
#'
#' \itemize{
#'  \item \code{\link{density_spplist}}: service no longer provided
#'  \item \code{\link{densitylist}}: service no longer provided
#'  \item \code{\link{gbifdata}}: service no longer provided
#'  \item \code{\link{gbifmap_dens}}: service no longer provided
#'  \item \code{\link{gbifmap_list}}: service no longer provided
#'  \item \code{\link{occurrencedensity}}: service no longer provided
#'  \item \code{\link{providers}}: service no longer provided
#'  \item \code{\link{resources}}: service no longer provided
#'  \item \code{\link{taxoncount}}: service no longer provided
#'  \item \code{\link{taxonget}}: service no longer provided
#'  \item \code{\link{taxonsearch}}: service no longer provided
#'  \item \code{\link{stylegeojson}}: moving this functionality to spocc package, will be removed soon
#'  \item \code{\link{togeojson}}: moving this functionality to spocc package, will be removed soon
#'  \item \code{\link{gist}}: moving this functionality to spocc package, will be removed soon
#' }
#'
#' The above functions have been removed. See \url{https://github.com/ropensci/rgbif} and poke
#' around the code if you want to find the old functions in previous versions of the package, or
#' email Scott at \email{myrmecocystus@@gmail.com}
#'
#' @name rgbif-defunct
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

#' Vector of fields in the output for the function \code{occ_search}
#'
#' These fields can be specified in the \code{fields} parameer in the \code{occ_search} function.
#'
#' @name occ_fields
#' @docType data
#' @keywords data
NULL
