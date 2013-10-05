#' Get number of occurrence records.
#' 
#' @template all
#' @import httr
#' @import plyr
#' @param nubKey Species key
#' @param georeferenced Return only occurence records with lat/long data (TRUE) or
#'    all records (FALSE, default). 
#' @param basisOfRecord Basis of record
#' @param datasetKey Dataset key
#' @param date Collection date
#' @param year Year data were collected in
#' @param catalogNumber Catalog number
#' @param country Country data was collected in
#' @param hostCountry Country that hosted the data
#' @param callopts Pass on options to httr::GET for more refined control of 
#'    http calls, and error handling
#' @return A single numeric value
#' @examples \dontrun{
#' occ_count(basisOfRecord='OBSERVATION')
#' occ_count(georeferenced=TRUE)
#' occ_count(country='DENMARK')
#' occ_count(hostCountry='FRANCE')
#' occ_count(datasetKey='9e7ea106-0bf8-4087-bb61-dfe4f29e0f17')
#' occ_count(year=2012)
#' occ_count(nubKey=2435099)
#' occ_count(nubKey=2435099, georeferenced=TRUE)
#' occ_count(datasetKey='8626bd3a-f762-11e1-a439-00145eb45e9a', basisOfRecord='PRESERVED_SPECIMEN')
#' occ_count(datasetKey='8626bd3a-f762-11e1-a439-00145eb45e9a', nubKey=2435099, basisOfRecord='PRESERVED_SPECIMEN')
#' }
#' @export
occ_count <- function(nubKey=NULL, georeferenced=NULL, basisOfRecord=NULL, 
  datasetKey=NULL, date=NULL, catalogNumber=NULL, country=NULL, hostCountry=NULL, 
  year=NULL, callopts=list())
{
  url = 'http://api.gbif.org/v0.9/occurrence/count'
  args <- compact(list(nubKey=nubKey, georeferenced=georeferenced, 
                       basisOfRecord=basisOfRecord, datasetKey=datasetKey, 
                       date=date, catalogNumber=catalogNumber, country=country,
                       hostCountry=hostCountry, year=year))
  tt <- GET(url, query=args, callopts)
  stop_for_status(tt)
  as.numeric(content(tt, as="text"))
}