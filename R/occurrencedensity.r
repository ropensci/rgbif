#' Returns summary counts of occurrence records by one-degree cell for a single
#' 		taxon, country, dataset, data publisher or data network.
#' 		
#' @import httr XML plyr
#' @param taxonconceptkey numeric key uniquely identifying the taxon
#' @param dataproviderkey numeric key uniquely identifying the data provider
#' @param dataresourcekey numeric key uniquely identifying the data resource
#' @param resourcenetworkkey numeric key uniquely identifying the data network
#' @param originisocountrycode numeric key uniquely identifying the country
#' @param format specifies the format in which the records are to be returned,
#' 		one of: brief, darwin or kml (character)
#' @param url the base GBIF API url for the function (should be left to default)
#' @param ... optional additional curl options (debugging tools mostly)
#' @param curl If using in a loop, call getCurlHandle() first and pass
#' 		the returned value in here (avoids unnecessary footprint)
#' @examples \dontrun{
#' occurrencedensity(originisocountrycode='CA')
#' occurrencedensity(taxonconceptkey=45)
#' }
#' @export
occurrencedensity <- function(taxonconceptkey = NULL,
    dataproviderkey = NULL, dataresourcekey = NULL, resourcenetworkkey = NULL,
    originisocountrycode = NULL, format = NULL, 
		url = "http://data.gbif.org/ws/rest/density/list") 
{
    args <- compact(list(taxonconceptkey=taxonconceptkey, 
    	dataproviderkey=dataproviderkey,dataresourcekey=dataresourcekey,
    	resourcenetworkkey=resourcenetworkkey,
    	originisocountrycode=originisocountrycode,format=format))
    temp <- GET(url, query = args)
    out <- content(temp, as="text")
    tt <- xmlParse(out)
    data.frame(cellid = xpathSApply(tt, "//gbif:densityRecord", xmlAttrs), 
    	minlat = xpathSApply(tt, "//gbif:densityRecord/gbif:minLatitude", xmlValue), 
    	maxlat = xpathSApply(tt, "//gbif:densityRecord/gbif:maxLatitude", xmlValue), 
    	minlong = xpathSApply(tt, "//gbif:densityRecord/gbif:minLongitude", xmlValue), 
    	maxlong = xpathSApply(tt, "//gbif:densityRecord/gbif:maxLongitude", xmlValue), 
    	count = xpathSApply(tt, "//gbif:densityRecord/gbif:count", xmlValue)
    )
}