#' @title Interface to the Global Biodiversity Information Facility API.
#'
#' @description rgbif: A programmatic interface to the Web Service methods
#' provided by the Global Biodiversity Information Facility.
#'
#' @section About:
#'
#' This package gives you access to data from GBIF <https://www.gbif.org/>
#' via their API.
#'
#' @section A note about the old GBIF API:
#'
#' The old GBIF API is now defunct - that is, not available anymore. We used
#' to have functions that worked with the old API, but those functions are
#' now not available anymore because GBIF made the old API defunct.
#'
#' @section Documentation for the GBIF API:
#'
#' - summary <https://www.gbif.org/developer/summary> - Summary of
#' the GBIF API
#' - registry <https://www.gbif.org/developer/registry> - Metadata
#' on datasets, and contributing organizations
#' - species names <https://www.gbif.org/developer/species> - Species
#' names and metadata
#' - occurrences <https://www.gbif.org/developer/occurrence> -
#' Occurrences
#' - maps <https://www.gbif.org/developer/maps> - Maps - these APIs
#' are not implemented in \pkg{rgbif}, and are meant more for intergration
#' with web based maps.
#'
#' @note See [many-values] for discussion of how functions vary in how
#' they accept values (single vs. many for the same HTTP request vs. many
#' for different HTTP requests)
#'
#' @importFrom data.table rbindlist fread setDF
#' @importFrom ggplot2 geom_point position_jitter map_data ggplot
#' geom_polygon aes scale_color_brewer labs theme_bw theme guides
#' guide_legend coord_fixed element_blank
#' @importFrom xml2 read_xml xml_text xml_find_all
#' @importFrom jsonlite toJSON fromJSON unbox
#' @importFrom oai id list_identifiers list_records list_metadataformats
#' list_sets get_records
#' @importFrom lazyeval lazy_dots lazy_eval
#' @importFrom R6 R6Class
#' @importFrom conditionz ConditionKeeper
#' @importFrom wellknown wkt_bounding validate_wkt
#' @name rgbif-package
#' @aliases rgbif
#' @docType package
#' @author Scott Chamberlain
#' @author Karthik Ram
#' @author Dan Mcglinn
#' @author Vijay Barve
NULL

#' Defunct functions in rgbif
#'
#' - [density_spplist()]: service no longer provided
#' - [densitylist()]: service no longer provided
#' - [gbifdata()]: service no longer provided
#' - [gbifmap_dens()]: service no longer provided
#' - [gbifmap_list()]: service no longer provided
#' - [occurrencedensity()]: service no longer provided
#' - [providers()]: service no longer provided
#' - [resources()]: service no longer provided
#' - [taxoncount()]: service no longer provided
#' - [taxonget()]: service no longer provided
#' - [taxonsearch()]: service no longer provided
#' - [stylegeojson()]: moving this functionality to spocc package, will be
#' removed soon
#' - [togeojson()]: moving this functionality to spocc package, will be
#' removed soon
#' - [gist()]: moving this functionality to spocc package, will be
#' removed soon
#' - [occ_spellcheck()]: GBIF has removed the `spellCheck` parameter
#' from their API
#'
#' The above functions have been removed. See
#' <https://github.com/ropensci/rgbif> and poke around the code if you
#' want to find the old functions in previous versions of the package
#'
#' @name rgbif-defunct
NULL

#' Table of country two character ISO codes, and GBIF names
#'
#' - code. Two character ISO country code.
#' - name. Name of country.
#' - gbif_name. Name of country used by GBIF - this is the name
#'   you want to use when searching by country in this package.
#'
#' @name isocodes
#' @docType data
#' @keywords data
NULL

#' Type status options for GBIF searching
#'
#' - name. Name of type.
#' - description. Description of the type.
#'
#' @name typestatus
#' @docType data
#' @keywords data
NULL

#' Vector of fields in the output for the function [occ_search()]
#'
#' These fields can be specified in the `fields` parameer in the
#' [occ_search()] function.
#'
#' @name occ_fields
#' @docType data
#' @keywords data
NULL
