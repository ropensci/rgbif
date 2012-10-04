#' Get data networks and their unique keys.
#'
#' Beware: It takes a while to retrieve the full list of networks - so
#'  go get more coffee.
#'
#' @import RCurl XML
#' @param name data network name search string, by default searches all
#'    data networks by defining name = ''
#' @param code return networks identified by the supplied short identifier code.
#' @param modifiedsince return only records which have been indexed or modified
#'    on or after the supplied date (format YYYY-MM-DD, e.g. 2006-11-28)
#' @param  startindex  return the subset of the matching records that starts at 
#'    the supplied (zero-based index). 
#' @param maxresults max number of results to return
#' @param url the base GBIF API url for the function (should be left to default)
#' @param ... optional additional curl options (debugging tools mostly)
#' @param curl If using in a loop, call getCurlHandle() first and pass
#'   the returned value in here (avoids unnecessary footprint)
#' @export
#' @examples \dontrun{
#' # Test the function for a few networks
#' networks(maxresults=10)
#' # All data providers
#' networks()
#' }
networks <- function(name = "", code = NA, modifiedsince = NA,  
                     startindex = NA, maxresults = NA, 
                     url = "http://data.gbif.org/ws/rest/network/list",
                     ..., curl = getCurlHandle()) {
    args <- list()
    if (!is.na(name))
        args$name <- name
    if (!is.na(maxresults))
        args$maxresults <- maxresults
    out <- getForm(url, .params = args, ..., curl = curl)
    tt <- xmlParse(out)
    names_ <- xpathSApply(tt, "//gbif:resourceNetwork/gbif:name",
        xmlValue)
    networkkey <- xpathSApply(tt, "//gbif:resourceNetwork", xmlAttrs)[1,]
    data.frame(names_, networkkey)
}
