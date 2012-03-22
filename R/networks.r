#'Get data networks and their unique keys.
#'
#'Beware: It takes a while to retrieve the full list of providers - so
#'go get more coffee.
#'
#'@import RCurl XML
#'@param name data network name search string, by default searches all
#' data networks by defining name = ''
#'@param maxresults max number of results to return
#'@param url the base GBIF API url for the function (should be left to default)
#'@param ... optional additional curl options (debugging tools mostly)
#'@param curl If using in a loop, call getCurlHandle() first and pass
#' the returned value in here (avoids unnecessary footprint)
#'@export
#'@examples \dontrun{
#'# Test the function for a few networks
#'networks(maxresults=10)
#'#'# All data providers
#'networks()
#'}
networks <- function(name = "", maxresults = NA, url = "http://data.gbif.org/ws/rest/network/list",
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
    gbifkey <- xpathSApply(tt, "//gbif:resourceNetwork", xmlAttrs)[1,
        ]
    data.frame(names_, gbifkey)
}
