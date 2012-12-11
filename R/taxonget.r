#' Get taxonomic information on a specific taxon or taxa in GBIF by their taxon
#' 		concept keys.
#'
#' @import RCurl XML plyr
#' @param key A single key, or many keys in a vector, for a taxon.
#' @param url the base GBIF API url for the function (leave to default).
#' @return A single data.frame of taxonomic information if  single data.frame is
#' 		supplied, or a list of data.frame's if a list of keys is supplied.
#' @examples \dontrun{
#' keys <- taxonsearch(scientificname = 'Puma concolor')
#' taxonget(keys)
#'
#' # Just for one key
#' taxonget(51780668) # taxonconceptkey for Puma concolor
#' }
#' @export
taxonget <- function(key = NULL, url = "http://data.gbif.org/ws/rest/taxon/get")
{
	doit <- function(x) {
		args <- compact(list(key = x))
		temp <- getForm(url, .params=args)
		tt <- xmlParse(temp)
		taxonconceptkeys <- sapply(getNodeSet(tt, "//tc:TaxonConcept[@gbifKey]"), xmlGetAttr, "gbifKey")
		sciname <- sapply(getNodeSet(tt, "//tn:nameComplete"), xmlValue)
		rank <- sapply(getNodeSet(tt, "//tn:rankString"), xmlValue)
		data.frame(sciname, taxonconceptkeys, rank)
	}
	lapply(key, doit)
}
