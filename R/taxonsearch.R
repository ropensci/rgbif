#' Search for taxa in GBIF
#'
#' Search for a taxon using scientific name. Optionally, include taxonomic
#' rank in the search.
#'
#' Returns list of TaxonConcept key values
#'
#' @import XML RCurl
#' @param sciname  scientitic name of taxon (character, see example)
#' @param rank  rank of taxon, see taxrank() (character)
#' @param maxresults  return at most the specified number of records. The
#'   	default (and maximum supported) is 1000 records.
#' @param  dataproviderkey Filter records to those provided by the supplied
#'    numeric key for a data provider. See provider(). (character)
#' @param  dataresourcekey Filter records to those provided by the supplied
#'    numeric key for a data resource See resource(). (character)
#' @param  resourcenetworkkey  count only records which have been made available by 
#'    resources identified as belonging to the network identified by the supplied numeric key.
#' @param  hostisocountrycode  return only records served by providers from the country 
#'    identified by the supplied 2-letter ISO code.
#' @param  startindex  return the subset of the matching records that starts at 
#'    the supplied (zero-based index). 
#' @param url the base GBIF API url for the function (should be left to default)
#' @param ... optional additional curl options (debugging tools mostly)
#' @param curl If using in a loop, call getCurlHandle() first and pass
#' 		the returned value in here (avoids unnecessary footprint)
#' @export
#' @examples \dontrun{
#' taxonsearch(sciname = 'Puma concolor')
#' }
taxonsearch <- function(sciname = NA, rank = NA, maxresults = 10,
                        dataproviderkey = NA, dataresourcekey = NA, resourcenetworkkey = NA,
                        hostisocountrycode = NA, startindex = NA,
                        url = "http://data.gbif.org/ws/rest/taxon/list?",
                        ..., curl = getCurlHandle()) 
{
  if (!is.na(sciname)) {
    sciname2 <- paste("scientificname=", sub(" ", "+", sciname),
                      sep = "")
  } else {
    sciname2 <- NULL
  }
  if (!is.na(rank)) {
    rank2 <- paste("&rank=", rank, sep = "")
  } else {
    rank2 <- NULL
  }
  if (!is.na(dataproviderkey)) {
    dataproviderkey2 <- paste("&dataproviderkey=", dataproviderkey, sep = "")
  } else {
    dataproviderkey2 <- NULL
  }
  if (!is.na(dataresourcekey)) {
    dataresourcekey2 <- paste("&dataresourcekey=", dataresourcekey, sep = "")
  } else {
    dataresourcekey2 <- NULL
  }
  if (!is.na(resourcenetworkkey)) {
    resourcenetworkkey2 <- paste("&resourcenetworkkey=", resourcenetworkkey, sep = "")
  } else {
    resourcenetworkkey2 <- NULL
  }
  if (!is.na(hostisocountrycode)) {
    hostisocountrycode2 <- paste("&hostisocountrycode=", hostisocountrycode, sep = "")
  } else {
    hostisocountrycode2 <- NULL
  }
  if (!is.na(startindex)) {
    startindex2 <- paste("&startindex=", startindex, sep = "")
  } else {
    startindex2 <- NULL
  }
  maxresults2 <- paste("&maxresults=", maxresults, sep = "")
  args <- paste(sciname2, rank2, dataproviderkey2, dataresourcekey2, 
                resourcenetworkkey2, hostisocountrycode2, startindex2, 
                maxresults2, sep = "")
  query <- paste(url, args, sep = "")
  doc = xmlInternalTreeParse(query)
  nodes <- getNodeSet(doc, "//tc:TaxonConcept")
  out <- NULL
  if (length(nodes) < 1){
    cat("No results found")
    return(invisible(NULL))
  }
  for (i in 1:length(nodes)){
    out[i] <- xmlGetAttr(nodes[[i]],"gbifKey")
  }
  out
}