#' GBIF datause descriptiom.
#' 
#' @import RCurl
#' @param url Base url for call, don't change.
#' @examples \dontrun{
#' gbifdatause()
#' }
#' @export
gbifdatause <- function(url="http://data.gbif.org/tutorial/datasharingagreement") 
{
    getURLContent(url)
}