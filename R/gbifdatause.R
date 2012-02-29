#'gbifdatause - description
#'
#'@param  None
#'@keywords
#'@seealso
#'@return
#'@alias
#'@export
#'@examples \dontrun{
#' gbifdatause()
#' }
gbifdatause <-

function(url = 'http://data.gbif.org/tutorial/datasharingagreement',
  ...,
  curl = getCurlHandle() )
{
  tt <- getURLContent(url)
#   jsonout <- xmlTreeParse(I(tt))
  return(tt)
}