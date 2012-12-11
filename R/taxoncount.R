#' Search by taxon to retrieve number of records in GBIF.
#'
#' @import RCurl XML plyr
#' @param scientificname Scientitic name of taxon (character, see example)
#' @param rank Rank of taxon, see taxrank() (character)
#' @param dataresourcekey Filter records to those provided by the supplied
#'    numeric key for a data resource. See resources(). (character)
#' @param url The base GBIF API url for the function (should be left to default).
#' @examples \dontrun{
#' taxoncount(scientificname = 'Puma concolor')
#' taxoncount(scientificname = 'Helianthus annuus')
#' taxoncount(rank = 'family')
#' }
#' @export
taxoncount <- function(scientificname = NULL, rank = NULL,
    dataresourcekey = NULL, url = "http://data.gbif.org/ws/rest/taxon/count")
{
	args <- compact(list(scientificname = scientificname, rank = rank,
											 dataresourcekey = dataresourcekey))
	temp <- getForm(url, .params=args)
	tt <- xmlParse(temp)
	as.numeric(xmlGetAttr(getNodeSet(tt, "//gbif:summary", namespaces="gbif")[[1]], "totalMatched"))
}
