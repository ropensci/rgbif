#' @param facet  A list of facet names used to retrieve the 100 most frequent
#' values for a field. Allowed facets are: datasetKey, highertaxonKey, rank,
#' status, extinct, habitat, and nameType. Additionally threat and
#' nomenclaturalStatus are legal values but not yet implemented, so data will
#' not yet be returned for them.
#' @param facetMincount Used in combination with the facet parameter. Set
#' \code{facetMincount={#}} to exclude facets with a count less than {#}, e.g.
#' http://bit.ly/1bMdByP only shows the type value 'ACCEPTED' because the other
#' statuses have counts less than 7,000,000
#' @param facetMultiselect  Used in combination with the facet parameter. Set
#' facetMultiselect=true to still return counts for values that are not
#' currently filtered, e.g. http://bit.ly/19YLXPO still shows all status
#' values even though status is being filtered by \code{status=ACCEPTED}
