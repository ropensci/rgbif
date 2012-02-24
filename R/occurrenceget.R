#`getoccurrence - description
#`
#`<full description>
#`@param key numeric key uniquely identifying the occurrence record within the GBIF
#`@param stylesheet sets the URL of the stylesheet to be associated with the response document
#`@param format specifies the format in which the records are to be returned, one of: brief, darwin or kml (character)
#`@param  mode: specifies whether the response data should (as far as possible) be the raw values originally retrieved from the data resource or processed (normalised) values used within the data portal (character)
#`@param url  internal use
#`@param  curl internal use
#`@keywords
#`@seealso
#`@return
#`@alias
#`@export
#`@examples \dontrun{
#`getoccurrence(key = 13749100)
#` }
getoccurrence <- function(key = NA, style = NA, format = NA, mode = NA,
  url = 'http://data.gbif.org/ws/rest/occurrence/get?',
  ...,
  curl = getCurlHandle())
{
  if(!is.na(key)) {key2 <- paste('key=', key, sep='')} else
    {key2 <- NULL}
  if(!is.na(style)) {style2 <- paste('stylesheet=', style, sep='')} else
    {style2 <- NULL}
  if(!is.na(format)) {format2 <- paste('format=', format, sep='')} else
    {format2 <- NULL}
  if(!is.na(mode)) {mode2 <- paste('mode=', mode, sep='')} else
    {mode2 <- NULL}
  args <- paste(key2, style2, format2, mode2, sep='&')
  query <- paste(url, args, sep='')
  tt <- getURL(query,
#     ...,
    curl = curl)
  xmlTreeParse(tt)$doc$children$gbifResponse
}

tt <- getoccurrence(key = 13850822)
tt_ <- xmlTreeParse(tt)
xmlTreeParse(tt_)
getNodeSet

#


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