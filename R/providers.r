#'Get data providers and their unique keys.
#'
#'Beware: It takes a while to retrieve the full list of providers - so
#'go get more coffee.
#'#'@import RCurl XML
#'@param name data provider name search string, by default searches all
#' data providers by defining name = ''
#'@param maxresults max number of results to return
#'@param url the base GBIF API url for the function (should be left to default)
#'@param ... optional additional curl options (debugging tools mostly)
#'@param curl If using in a loop, call getCurlHandle() first and pass
#' the returned value in here (avoids unnecessary footprint)
#'@export
#'@examples \dontrun{
#'# Test the function for a few providers
#'providers(maxresults=10)
#'#'# All data providers
#'providers()
#'}
providers <- function(name = "", maxresults = NA,
    url = "http://data.gbif.org/ws/rest/provider/list", ...,
    curl = getCurlHandle()) {
    args <- list()
    if (!is.na(name))
        args$name <- name
    if (!is.na(maxresults))
        args$maxresults <- maxresults
    out <- getForm(url, .params = args, ..., curl = curl)
    tt <- xmlParse(out)
    names_ <- xpathSApply(tt, "//gbif:dataProvider/gbif:name",
        xmlValue)
    gbifkey <- xpathSApply(tt, "//gbif:dataProvider", xmlAttrs)[1,
        ]
    data.frame(names_, gbifkey)
}
