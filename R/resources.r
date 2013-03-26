#' Get data resources and their unique keys.
#'
#' Beware: It takes a while to retrieve the full list of resources - so
#' go get more coffee.
#'
#' @import RCurl XML plyr
#' @param name data provider name search string, by default searches all
#' 		data resources by defining name = ''
#' @param  providerkey Filter records to those provided by the supplied
#'    numeric key for a data provider. See \link{providers}(). (character)
#' @param  basisofrecordcode  return only records with the specified basis of record.
#'    Supported values are: "specimen, observation, living, germplasm, fossil, unknown".
#'    (character)
#' @param modifiedsince return only records which have been indexed or modified
#'    on or after the supplied date (format YYYY-MM-DD, e.g. 2006-11-28)
#' @param  startindex  return the subset of the matching records that starts at
#'    the supplied (zero-based index).
#' @param maxresults max number of results to return
#' @examples \dontrun{
#' # Test the function for a few resources
#' resources(maxresults=30)
#'
#' # By name
#' resources('Flora')
#' }
#' @examples \dontest{
#' # All data providers
#' resources()
#' }
#' @export
resources <- function(name = "", providerkey = NULL, basisofrecordcode = NULL,
   modifiedsince = NULL,  startindex = NULL, maxresults = NULL)
{
	url = "http://data.gbif.org/ws/rest/resource/list"
	args <- compact(list(name = name, providerkey = providerkey,
											 basisofrecordcode = basisofrecordcode,
											 modifiedsince = modifiedsince, startindex = startindex,
											 maxresults = maxresults))

	temp <- getForm(url, .params=args)
	tt <- xmlParse(temp)
	names_ <- xpathSApply(tt, "//gbif:dataResource/gbif:name",
												xmlValue)
	resourcekey <- xpathSApply(tt, "//gbif:dataResource", xmlAttrs)[2,]
	data.frame(names_, resourcekey)
}
