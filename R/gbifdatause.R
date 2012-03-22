#'gbifdatause - description
#'@import RCurl
#'@param  url Base url for call, don't change.
#'@export
#'@examples \dontrun{
#'gbifdatause()
#'}
gbifdatause <- function(url = "http://data.gbif.org/tutorial/datasharingagreement") {
    getURLContent(url)
}
