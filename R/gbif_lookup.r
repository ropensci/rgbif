#' Lookup names in the GBIF backbone taxonomy.
#' 
#' @import httr
#' @importFrom plyr compact
#' @param name
#' @param kingdom
#' 
#' @export
#' @examples \dontrun{
#' gbif_lookup(name='Helianthus annuus', kingdom='plants')
#' }
gbif_lookup <- function(name, kingdom=NULL)
{
  url = 'http://api.gbif.org/lookup/name_usage'
  args <- compact(list(name=name, kingdom=kingdom))
  tt <- content(GET(url, query=args))
  tt
}
# http://api.gbif.org/lookup/name_usage/?name=helianthus%20annuus&kingdom=plants