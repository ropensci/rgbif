#' Facet GBIF occurrences
#'
#' @export
#' @param facet (character) a character vector of length 1 or greater. Required.
#' @param facetMincount (numeric) minimum number of records to be included
#' in the faceting results
#' @param ... Facet parameters, such as for paging based on each facet
#' variable, e.g., `country.facetLimit`
#' @template occ
#' @seealso [occ_search()] also has faceting ability, but
#' can include occurrence data in addition to facets.
#' @details All fields can be faceted on except for last "lastInterpreted",
#' "eventDate", and "geometry"
#'
#' If a faceted variable is not found, it is silently dropped, returning
#' nothing for that query
#' @return A list of tibbles (data.frame's) for each facet (each element of
#' the facet parameter).
#' @examples \dontrun{
#' occ_facet(facet = "country")
#'
#' # facetMincount - minimum number of records to be included
#' #   in the faceting results
#' occ_facet(facet = "country", facetMincount = 30000000L)
#' occ_facet(facet = c("country", "basisOfRecord"))
#'
#' # paging with many facets
#' occ_facet(
#'   facet = c("country", "basisOfRecord", "hasCoordinate"),
#'   country.facetLimit = 3,
#'   basisOfRecord.facetLimit = 6
#' )
#'
#' # paging
#' ## limit
#' occ_facet(facet = "country", country.facetLimit = 3)
#' ## offset
#' occ_facet(facet = "country", country.facetLimit = 3,
#'   country.facetOffset = 3)
#'
#' # Pass on curl options
#' occ_facet(facet = "country", country.facetLimit = 3,
#'   curlopts = list(verbose = TRUE))
#' }
occ_facet <- function(facet, facetMincount = NULL, 
curlopts = list(http_version = 2), ...) {
  .Deprecated(msg="occ_facet() is deprecated since rgbif 3.7.6. Use occ_count(facet='x') instead.")
  args <- rgbif_compact(list(facetMincount = facetMincount, limit = 0))
  args <- c(args, collargs("facet"), yank_args(...))
  tt <- gbif_GET(paste0(gbif_base(), '/occurrence/search'), args,
                 FALSE, curlopts)
  stats::setNames(lapply(tt$facets, function(z) {
    tibble::as_tibble(
      data.table::rbindlist(z$counts, use.names = TRUE, fill = TRUE)
    )
  }), vapply(tt$facets, function(x) to_camel(x$field), ""))
}

