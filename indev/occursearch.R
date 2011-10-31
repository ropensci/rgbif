# occursearch.R

occursearch <- 
# Args:
#   sciname: scientitic name of taxon, as e.g., "Puma concolor" (character)
#   format: code format, one of darwin or kml (character)
# Examples:
#   occursearch("Puma concolor", "darwin")

function(sciname = NA, codeformat = NA,
  url = 'http://data.gbif.org/ws/rest/occurrence/list',
  ..., 
  curl = getCurlHandle() ) 
{
#   if(!is.null(sciname)) {
#     sciname2 <- paste("scientificname=", sub(" ", "+", sciname), sep = "")} else
#       {sciname2 <- NULL}
#   if(!is.null(rank)){
#     rank2 <- paste("rank=", rank, sep = "")} else
#       {rank2 <- NULL}
#   if(!is.null(datakey)){
#     datakey2 <- paste("dataresourcekey=", datakey, sep = "")} else
#       {datakey2 <- NULL}
#   args <- paste(sciname2, rank2, datakey2, sep = "&")
#   url2 <- paste(url, args, sep = "")
#   tt <- getURLContent(url2)
#   out <- xmlTreeParse(tt)$doc$children$gbifResponse
#   out2 <- as.numeric(xmlToList(out)[[8]])
#   
  args <- list()
  if(!is.na(sciname))
    args$scientificname <- sub(" ", "+", sciname)
  if(!is.na(codeformat))
    args$format <- codeformat
  tt <- getForm(url, 
    .params = args,
    ...,
    curl = curl,
    verbose=TRUE)
  out <- xmlTreeParse(tt)
#          $doc$children$gbifResponse
  return(out)
}


# http://data.gbif.org/ws/rest/occurrence/list?scientificname=Puma+concolor&format=darwin
getURLContent("http://data.gbif.org/ws/rest/occurrence/list?scientificname=Puma+concolor&format=darwin")

outt <- xmlRoot(xmlTreeParse(getURLContent("http://data.gbif.org/ws/rest/occurrence/list?scientificname=Helianthus+petiolaris&format=darwin&enddate=1900-12-31")))
outt[["dataProviders"]] # and use similar code for grabbing certain data
### Need to figure out how to parse the data within dataproviders...


