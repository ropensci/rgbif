#' Search for taxa in GBIF.
#'
#' Search for a taxon using scientific name. Optionally, include taxonomic
#' 		rank in the search. Returns list of TaxonConcept key values.
#'
#' @import RCurl XML plyr
#' @param scientificname  scientific name of taxon (character, see example)
#' @param rank  rank of taxon, see taxrank() (character)
#' @param maxresults  return at most the specified number of records. The
#'   	default (and maximum supported) is 1000 records.
#' @param dataproviderkey Filter records to those provided by the supplied
#'    numeric key for a data provider. See provider(). (character)
#' @param dataresourcekey Filter records to those provided by the supplied
#'    numeric key for a data resource See resource(). (character)
#' @param resourcenetworkkey  count only records which have been made available by 
#'    resources identified as belonging to the network identified by the supplied numeric key.
#' @param hostisocountrycode  return only records served by providers from the country 
#'    identified by the supplied 2-letter ISO code.
#' @param startindex  return the subset of the matching records that starts at 
#'    the supplied (zero-based index). 
#' @param url the base GBIF API url for the function (should be left to default)
#' @return List of TaxonConcept key values.
#' @examples \dontrun{
#' taxonsearch(scientificname = 'Puma concolor')
#' }
#' @export
taxonsearch <- function(scientificname = NULL, rank = NULL, maxresults = 10,
   dataproviderkey = NULL, dataresourcekey = NULL, resourcenetworkkey = NULL,
   hostisocountrycode = NULL, startindex = NULL,
   url = "http://data.gbif.org/ws/rest/taxon/list") 
{
	args <- compact(list(
		scientificname = scientificname, dataproviderkey = dataproviderkey, 
		dataresourcekey = dataresourcekey,  resourcenetworkkey = resourcenetworkkey,	
		hostisocountrycode = hostisocountrycode, rank=rank, maxresults=maxresults, 
		startindex=startindex))
# 	temp <- GET(url, query = args)
# 	out <- content(temp, as="text")
# 	tt <- xmlParse(out)	
	temp <- getForm(url, .params=args)
	tt <- xmlParse(temp)
	nodes <- getNodeSet(tt, "//tc:TaxonConcept")
	out2 <- NULL
	if (length(nodes) < 1){
		cat("No results found")
		return(invisible(NULL))
	}
	for (i in 1:length(nodes)){
		out2[i] <- xmlGetAttr(nodes[[i]],"gbifKey")
	}
	out2
}