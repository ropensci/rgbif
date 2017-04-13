#' @param facet (character) a character vector of length 1 or greater.
#' Required.
#' @param facetMincount (numeric) minimum number of records to be included
#' in the faceting results
#' @param facetMultiselect (logical) Set to `TRUE` to still return counts
#' for values that are not currently filtered. See examples.
#' Default: `FALSE`
#'
#' **Faceting**:
#' All fields can be faceted on except for last "lastInterpreted",
#' "eventDate", and "geometry"
#'
#' You can do facet searches alongside searching occurrence data, and
#' return both, or only return facets, or only occurrence data, etc.
