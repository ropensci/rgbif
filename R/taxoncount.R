#'Search by taxon to retrieve number of records in GBIF.
#'@import RCurl XML
#'@param sciname  scientitic name of taxon (character, see example)
#'@param rank  rank of taxon, see taxrank() (character)
#'@param dataresourcekey Filter records to those provided by the supplied
#'    numeric key for a data resource. See resources(). (character)
#'@param url the base GBIF API url for the function (should be left to default)
#'@param ... optional additional curl options (debugging tools mostly)
#'@param curl If using in a loop, call getCurlHandle() first and pass
#' the returned value in here (avoids unnecessary footprint)
#'@export
#'@examples \dontrun{
#'taxoncount('Puma concolor')
#'taxoncount('Helianthus annuus')
#'taxoncount(rank = 'family')
#'}
taxoncount <- function(sciname = NULL, rank = NULL,
    dataresourcekey = NULL, url = "http://data.gbif.org/ws/rest/taxon/count?",
    ..., curl = getCurlHandle()) {
    if (!is.null(sciname)) {
        sciname2 <- paste("scientificname=", sub(" ", "+", sciname),
            sep = "")
    } else {
        sciname2 <- NULL
    }
    if (!is.null(rank)) {
        rank2 <- paste("rank=", rank, sep = "")
    } else {
        rank2 <- NULL
    }
    if (!is.null(dataresourcekey)) {
        datakey2 <- paste("dataresourcekey=", dataresourcekey,
            sep = "")
    } else {
        datakey2 <- NULL
    }
    args <- paste(sciname2, rank2, datakey2, sep = "&")
    url2 <- paste(url, args, sep = "")
    tt <- getURLContent(url2)
    out <- xmlTreeParse(tt)$doc$children$gbifResponse
    as.numeric(xmlToList(out)[[8]])
}
