# taxoncount.R

taxoncount <-
# Args:
#   sciname: scientitic name of taxon, as e.g., "Puma concolor" (character)
#   rank: taxonomic rank (character)
#   datakey:  (character)
# Examples:
#   taxoncount("Puma concolor")
#   taxoncount("Helianthus annuus")
#   taxoncount(rank = "family", datakey = 12)
#   taxoncount(rank = "family")

function(sciname = NULL, rank = NULL, datakey = NULL,
  url = 'http://data.gbif.org/ws/rest/taxon/count?',
  ...,
  curl = getCurlHandle() )
{
  if(!is.null(sciname)) {
    sciname2 <- paste("scientificname=", sub(" ", "+", sciname), sep = "")} else
      {sciname2 <- NULL}
  if(!is.null(rank)){
    rank2 <- paste("rank=", rank, sep = "")} else
      {rank2 <- NULL}
  if(!is.null(datakey)){
    datakey2 <- paste("dataresourcekey=", datakey, sep = "")} else
      {datakey2 <- NULL}
  args <- paste(sciname2, rank2, datakey2, sep = "&")
  url2 <- paste(url, args, sep = "")
  tt <- getURLContent(url2)
  out <- xmlTreeParse(tt)$doc$children$gbifResponse
  out2 <- as.numeric(xmlToList(out)[[8]])
  return(out2)
}