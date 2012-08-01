#'Get data resources and their unique keys.
#'
#'Beware: It takes a while to retrieve the full list of resources - so
#'go get more coffee.
#'
#'@import RCurl XML
#'@param name data provider name search string, by default searches all
#' data resources by defining name = ''
#' @param  providerkey Filter records to those provided by the supplied
#'    numeric key for a data provider. See \link{providers}(). (character)
#' @param  basisofrecordcode  return only records with the specified basis of record.
#'    Supported values are: "specimen, observation, living, germplasm, fossil, unknown".
#'    (character)
#' @param modifiedsince return only records which have been indexed or modified
#'    on or after the supplied date (format YYYY-MM-DD, e.g. 2006-11-28)
#' @param  startindex  return the subset of the matching records that starts at 
#'    the supplied (zero-based index). 
#'@param maxresults max number of results to return
#'@param url the base GBIF API url for the function (should be left to default)
#'@param ... optional additional curl options (debugging tools mostly)
#'@param curl If using in a loop, call getCurlHandle() first and pass
#' the returned value in here (avoids unnecessary footprint)
#'@export
#'@examples \dontrun{
#'# Test the function for a few resources
#'resources(maxresults=10)
#'#'# All data providers
#'resources()
#'}
resources <- function(name = "", providerkey = NA, basisofrecordcode = NA, 
                      modifiedsince = NA,  startindex = NA, maxresults = NA,
                      url = "http://data.gbif.org/ws/rest/resource/list", ...,
                      curl = getCurlHandle()) {
  args <- list()
  if (!is.na(name))
    args$name <- name
  if (!is.na(providerkey))
    args$providerkey <- providerkey
  if (!is.na(basisofrecordcode))
    args$basisofrecordcode <- basisofrecordcode
  if (!is.na(modifiedsince))
    args$modifiedsince <- modifiedsince
  if (!is.na(startindex))
    args$startindex <- startindex
  if (!is.na(maxresults))
    args$maxresults <- maxresults
  out <- getForm(url, .params = args, ..., curl = curl)
  tt <- xmlParse(out)
  names_ <- xpathSApply(tt, "//gbif:dataResource/gbif:name",
                        xmlValue)
  resourcekey <- xpathSApply(tt, "//gbif:dataResource", xmlAttrs)[2,
                                                                  ]
  data.frame(names_, resourcekey)
}
