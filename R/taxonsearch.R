#'taxonsearch <brief desc>
#'
#'<full description>
#'@param sciname  scientitic name of taxon (character, see example)
#'@param rank  <what param does>
#'@param maxresults  <what param does>
#'@param url internal use
#'@param curl internal use
#'@keywords
#'@seealso
#'@return
#'@alias
#'@export
#'@examples \dontrun{
#' taxonsearch(sciname = "Puma concolor")
#' }
taxonsearch <-function(sciname = NA, rank = NA, maxresults = 10,
  url = 'http://data.gbif.org/ws/rest/taxon/list?',
  ...,
  curl = getCurlHandle() )
{
  if(!is.na(sciname)) {sciname2 <- paste('scientificname=', sub(" ", "+", sciname), sep='')} else
    {sciname2 <- NULL}
  if(!is.na(rank)) {rank2 <- paste('&rank=', rank, sep='')} else
    {rank2 <- NULL}
  maxresults2 <- paste('&maxresults=', maxresults, sep='')
  args <- paste(sciname2, rank2, maxresults2, sep='')
  query <- paste(url, args, sep='')
  tt <- getURL(query,
    ...,
    curl = curl)
  xmlTreeParse(tt)$doc$children$gbifResponse
}

out <- taxonsearch(sciname = "Accipiter erythronemius", maxresults = 1000)
tt_ <- xmlToList(out)
tt_$header$statements


# url2 <- 'http://data.gbif.org/ws/rest/taxon/list?scientificname=Accipiter+erythronemius&maxresults=10'
# xmlTreeParse(getURL(url2))


