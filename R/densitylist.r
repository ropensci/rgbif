#' The density web service provides access to records showing the density
#' 		of occurrence records from the GBIF Network by one-degree cell.
#'
#' @import RCurl XML plyr
#' @param taxonconceptKey Unique key for taxon (numeric). Count only records which are 
#'		for the taxon identified by the supplied numeric key, including any records provided 
#'		under synonyms of the taxon concerned, and any records for child taxa 
#'		(e.g. all genera and species within a family).  May be repeted in single request.
#' @param dataproviderkey Filter records to those provided by the supplied
#'    numeric key for a data provider. See provider(). (character)
#' @param dataresourcekey Filter records to those provided by the supplied
#'    numeric key for a data resource See resource(). (character)
#' @param resourcenetworkkey  count only records which have been made available by 
#'    resources identified as belonging to the network identified by the supplied numeric key.
#' @param originisocountrycode Return density records for occurrences which 
#' 		occurred within the country identified by the supplied 2-letter ISO code.
#' @param format Specifies the format in which the records are to be returned,
#' 		one of: brief or kml (character)
#' @param url the base GBIF API url for the function (should be left to default)
#' @return A data.frame with results.
#' @examples \dontrun{
#' head( densitylist(originisocountrycode = "CA") )
#' }
#' @export
densitylist <- function(taxonconceptKey = NULL, dataproviderkey = NULL,
	dataresourcekey = NULL, resourcenetworkkey = NULL, originisocountrycode = NULL,
	format = NULL, url = "http://data.gbif.org/ws/rest/density/list") 
{
	args <- compact(list(taxonconceptKey = taxonconceptKey, 
		dataproviderkey = dataproviderkey, dataresourcekey = dataresourcekey, 
		resourcenetworkkey = resourcenetworkkey, 
		originisocountrycode = originisocountrycode, format = format))
	temp <- getForm(url, .params=args)
	tt <- xmlParse(temp)	
	cellid <- as.numeric(xpathSApply(tt, "//gbif:densityRecord", xmlAttrs))
	minLatitude <- as.numeric(sapply(getNodeSet(tt, "//gbif:minLatitude"), xmlValue))
	maxLatitude <- as.numeric(sapply(getNodeSet(tt, "//gbif:maxLatitude"), xmlValue))
	minLongitude <- as.numeric(sapply(getNodeSet(tt, "//gbif:minLongitude"), xmlValue))
	maxLongitude <- as.numeric(sapply(getNodeSet(tt, "//gbif:maxLongitude"), xmlValue))
	count <- as.numeric(sapply(getNodeSet(tt, "//gbif:count"), xmlValue))
	data.frame(cellid=cellid, minLatitude=minLatitude, maxLatitude=maxLatitude, 
						 minLongitude=minLongitude, maxLongitude=maxLongitude,
						 count=count)
}