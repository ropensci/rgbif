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
#' are not implemented in \pkg{rgbif}, and are meant more for integration
#' with web based maps.
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
#' @name rgbif-package
#' @aliases rgbif
#' @docType package
#' @author Scott Chamberlain
#' @author Karthik Ram
#' @author Dan Mcglinn
#' @author Vijay Barve
#' @author John Waller
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
