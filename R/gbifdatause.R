#' gbifdatause - description
#' @import RCurl
#' @param  None
#' @export
#' @examples \dontrun{
#' gbifdatause()
#' }
gbifdatause <- function(url = 'http://data.gbif.org/tutorial/datasharingagreement',
  ...,
  curl = getCurlHandle() )
{
  getURLContent(url)
}