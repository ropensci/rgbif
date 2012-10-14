#' Get individual records for a given occurrence record.
#' 
#' @import RCurl XML plyr
#' @param key numeric key uniquely identifying the occurrence record within the GBIF
#' @param format specifies the format in which the records are to be returned, one of: brief, darwin or kml (character)
#' @param mode specifies whether the response data should (as far as possible) be the raw values originally retrieved from the data resource or processed (normalised) values used within the data portal (character)
#' @param url the base GBIF API url for the function (should be left to default)
#' @details Currently, the function returns the record as a list, hopefully
#' 		in future will return a data.frame.
#' @examples \dontrun{
#' occurrenceget(key = 13749100)
#' }
#' @export
occurrenceget <- function(key = NULL, format = NULL, mode = NULL,
    url = "http://data.gbif.org/ws/rest/occurrence/get") 
{
	args <- compact(list(key=key, format=format, mode=mode))
# 	temp <- GET(url, query = args)
# 	out <- content(temp, as="text")
	temp <- getForm(url, .params=args)
	tt <- xmlParse(temp)
	xmlToList(tt)$data
}