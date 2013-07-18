#' Search for taxa in GBIF.
#'
#' Search for a taxon using scientific name. Optionally, include taxonomic
#' 		rank in the search. Returns list of TaxonConcept key values.
#'
#' @import httr XML plyr
#' @param scientificname  scientific name of taxon (character, see example)
#' @param rank  rank of taxon, see taxrank() (character)
#' @param maxresults  return at most the specified number of records. The
#'   	default (and maximum supported) is 1000 records.
#' @param dataproviderkey Filter records to those provided by the supplied
#'    numeric key for a data provider. See provider(). (character)
#' @param dataresourcekey Filter records to those provided by the supplied
#'    numeric key for a data resource See resource(). (character)
#' @param resourcenetworkkey  count only records which have been made available by
#'    resources identified as belonging to the network identified by the 
#'    supplied numeric key.
#' @param hostisocountrycode  return only records served by providers from the country
#'    identified by the supplied 2-letter ISO code.
#' @param startindex  return the subset of the matching records that starts at
#'    the supplied (zero-based index).
#' @param accepted_status Status in the GIBF portal
#' @description 
#' When searching for taxa, keep in mind that unless you want taxon identifiers 
#' for a specific data source, leave dataproviderkey as the default of 1, which 
#' is the GBIF backbone taxonomy. Also, always specify the taxonomic rank you 
#' are searching for - GBIF says the search is more efficient if rank is given.
#' @return A data.frame.
#' @examples \dontrun{
#' # Do specify the taxonomic rank the you are searching for, rank of species here
#' taxonsearch(scientificname = 'Puma concolor', rank="species")
#' 
#' # Fabaceae (rank of genus)
#' taxonsearch(scientificname = 'Abies', rank="genus")
#' 
#' # Fabaceae (rank of family)
#' taxonsearch(scientificname = 'Fabaceae', rank="family")
#' }
#' @export
taxonsearch <- function(scientificname = NULL, rank = NULL, maxresults = 10,
   dataproviderkey = 1, dataresourcekey = NULL, resourcenetworkkey = NULL,
   hostisocountrycode = NULL, startindex = NULL, accepted_status = FALSE)
{
	url = "http://data.gbif.org/ws/rest/taxon/list"
	args <- compact(list(
		scientificname = scientificname, dataproviderkey = dataproviderkey,
		dataresourcekey = dataresourcekey,  resourcenetworkkey = resourcenetworkkey,
		hostisocountrycode = hostisocountrycode, rank=rank, maxresults=maxresults,
		startindex=startindex))
  tt <- content(GET(url, query=args))
  nodes <- getNodeSet(tt, "//tc:TaxonConcept")

  if (length(nodes) < 1)
	  stop("No results found")
  
  gbifkey <- sapply(nodes, function(x) xmlGetAttr(x, "gbifKey"))
	status <- sapply(nodes, function(x) xmlGetAttr(x, "status"))
	name <- xpathSApply(tt, "//tn:nameComplete", xmlValue)
	rank <- xpathSApply(tt, "//tn:rankString", xmlValue)
	sci <- xpathSApply(tt, "//tn:scientific", xmlValue)
	accordingto <- xpathSApply(tt, "//tc:accordingToString", xmlValue)
	primary <- xpathSApply(tt, "//tc:primary", xmlValue)
	
  out <- data.frame(gbifkey=gbifkey,status=status,name=name,rank=rank,sci=sci,
                    source=accordingto,primary=primary)
     
  if(accepted_status)
    as.numeric(as.character(out[out$status %in% "accepted",]))
  else
    out
}