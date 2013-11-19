#' @param facet  A list of facet names used to retrieve the 100 most frequent values 
#'    for a field. Allowed facets are: dataset_key, highertaxon_key, rank, status, 
#'    extinct, habitat, and name_type. Additionally threat and nomenclatural_status 
#'    are legal values but not yet implemented, so data will not yet be returned for them.
#' @param facet_only Used in combination with the facet parameter. Set facet_only=true 
#'    to exclude search results.
#' @param facet_mincount Used in combination with the facet parameter. Set 
#'    facet_mincount={#} to exclude facets with a count less than {#}, e.g. 
#'    http://bit.ly/1bMdByP only shows the type value 'ACCEPTED' because the other 
#'    statuses have counts less than 7,000,000
#' @param facet_multiselect  Used in combination with the facet parameter. Set 
#'    facet_multiselect=true to still return counts for values that are not currently 
#'    filtered, e.g. http://bit.ly/19YLXPO still shows all status values even though 
#'    status is being filtered by status=ACCEPTED