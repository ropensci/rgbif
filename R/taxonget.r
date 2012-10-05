#' Get taxonomic information on a specific taxon or taxa in GBIF by their taxon 
#' 		concept keys.
#'
#' @import httr XML plyr
#' @param key Key for a taxon.
#' @return Data.frame of taxonomic information.
#' @examples \dontrun{
#' keys <- taxonsearch(scientificname = 'Puma concolor')
#' taxonget(key = keys[[1]])
#' }
#' @export
taxonget <- function(key = NULL,
   url = "http://data.gbif.org/ws/rest/taxon/get") 
{
	args <- compact(list(key = key))
	temp <- GET(url, query = args)
	out <- content(temp, as="text")
	tt <- xmlParse(out)	
	gbifkeys <- sapply(getNodeSet(tt, "//tc:TaxonConcept[@gbifKey]"), xmlGetAttr, "gbifKey")
	sciname <- sapply(getNodeSet(tt, "//tn:nameComplete"), xmlValue)
	rank <- sapply(getNodeSet(tt, "//tn:rankString"), xmlValue)
	data.frame(sciname, gbifkeys, rank)	
}