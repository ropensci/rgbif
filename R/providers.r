#' Get data providers and their unique keys.
#'
#' Beware: It takes a while to retrieve the full list of providers - so
#' go get more coffee.
#'
#' @import RCurl XML plyr
#' @param name data provider name search string, by default searches all
#' 		data providers by defining name = ''
#' @param isocountrycode return only providers from the country identified by
#'  	the supplied 2-letter ISO code.
#' @param modifiedsince return only records which have been indexed or modified
#'    on or after the supplied date (format YYYY-MM-DD, e.g. 2006-11-28)
#' @param  startindex  return the subset of the matching records that starts at
#'    the supplied (zero-based index).
#' @param maxresults max number of results to return
#' @examples \dontrun{
#' # Test the function for a few providers
#' providers(maxresults=10)
#'
#' # By data provider name
#' providers('University of Texas-Austin')
#' }
#' @examples \dontest{
#' # All data providers
#' providers()
#' }
#' @export
providers <- function(name = "", isocountrycode = NULL, modifiedsince = NULL,
		startindex = NULL, maxresults = NULL)
{
	url = "http://data.gbif.org/ws/rest/provider/list"
	args <- compact(list(name = name, isocountrycode=isocountrycode, 
                       modifiedsince=modifiedsince,startindex=startindex,
                       maxresults=maxresults))

	temp <- getForm(url, .params=args)
	tt <- xmlParse(temp)
	names_ <- xpathSApply(tt, "//gbif:dataProvider/gbif:name",
												xmlValue)
	dataproviderkey <- xpathSApply(tt, "//gbif:dataProvider", xmlAttrs)[1,]
	data.frame(names_, dataproviderkey)
}
