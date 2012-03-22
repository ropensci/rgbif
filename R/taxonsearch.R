#'Search for taxa in GBIF
#'
#'Search for a taxon using scientific name. Optionally, include taxonomic
#'rank in the search.
#'
#'@import XML RCurl
#'@param sciname  scientitic name of taxon (character, see example)
#'@param rank  rank of taxon, see taxrank() (character)
#'@param maxresults  return at most the specified number of records. The
#'   default (and maximum supported) is 1000 records.
#'@param url the base GBIF API url for the function (should be left to default)
#'@param ... optional additional curl options (debugging tools mostly)
#'@param curl If using in a loop, call getCurlHandle() first and pass
#' the returned value in here (avoids unnecessary footprint)
#'@export
#'@examples \dontrun{
#'taxonsearch(sciname = 'Puma concolor')
#'}
taxonsearch <- function(sciname = NA, rank = NA, maxresults = 10,
    url = "http://data.gbif.org/ws/rest/taxon/list?", ..., curl = getCurlHandle()) {
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
    maxresults2 <- paste("&maxresults=", maxresults, sep = "")
    args <- paste(sciname2, rank2, maxresults2, sep = "")
    query <- paste(url, args, sep = "")
    tt <- getURL(query, ..., curl = curl)
    xmlTreeParse(tt)$doc$children$gbifResponse
}
# out <- taxonsearch(sciname = 'Accipiter erythronemius', maxresults = 1000)
# tt_ <- xmlToList(out)
# tt_$header$statements
# url2 <- 'http://data.gbif.org/ws/rest/taxon/list?scientificname=Accipiter+erythronemius&maxresults=10'
# xmlTreeParse(getURL(url2))
