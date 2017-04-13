#' Enumerations.
#'
#' Many parts of the GBIF API make use of enumerations, i.e. controlled
#' vocabularies for specific topics - and are available via these functions
#'
#' @export
#'
#' @param x A given enumeration.
#' @template occ
#' @return `enumeration` returns a character vector, while
#' `enumeration_country` returns a data.frame.
#' @examples \dontrun{
#' # basic enumeration
#' enumeration()
#' enumeration("NameType")
#' enumeration("MetadataType")
#' enumeration("TypeStatus")
#'
#' # country enumeration
#' enumeration_country()
#'
#' # curl options
#' enumeration(curlopts = list(verbose=TRUE))
#' }
enumeration <- function(x = NULL, curlopts = list()) {
  url <- paste0(gbif_base(), "/enumeration/basic/", x)
  gbif_GET(url, NULL, parse = TRUE, curlopts)
}

#' @export
#' @rdname enumeration
enumeration_country <- function(curlopts = list()) {
  url <- paste0(gbif_base(), "/enumeration/country/")
  gbif_GET(url, NULL, parse = TRUE, curlopts = curlopts)
}
