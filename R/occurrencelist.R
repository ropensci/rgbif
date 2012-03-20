#' occurrencelist description
#' @import RCurl XML plyr
#' @param  sciname scientitic name of taxon (character, see example)
#' @param  taxonconceptKey unique key for taxon (numeric)
#' @param  dataproviderkey Filter records to those provided by the supplied 
#'     numeric key for a data provider. See provider(). (character)
#' @param  dataresourcekey Filter records to those provided by the supplied 
#'     numeric key for a data resource See resource(). (character)
#' @param  resourcenetworkkey  <what param does>
#' @param  basisofrecordcode  <what param does>
#' @param  minlatitude  <what param does>
#' @param  maxlatitude  <what param does>
#' @param  minlongitude  <what param does>
#' @param  maxlongitude  <what param does>
#' @param  minaltitude  <what param does>
#' @param  maxaltitude  <what param does>
#' @param  mindepth  <what param does>
#' @param  maxdepth  <what param does>
#' @param  cellid  <what param does>
#' @param  centicellid  <what param does>
#' @param  typesonly  <what param does>
#' @param  georeferencedonly  <what param does>
#' @param  coordinatestatus  <what param does>
#' @param  coordinateissues  <what param does>
#' @param  hostisocountrycode  <what param does>
#' @param  originisocountrycode  <what param does>
#' @param  originregioncode  <what param does>
#' @param  startdate  <what param does>
#' @param  enddate  <what param does>
#' @param  startyear  <what param does>
#' @param  endyear  <what param does>
#' @param  year  <what param does>
#' @param  month  <what param does>
#' @param  day  <what param does>
#' @param modifiedsince  <what param does>
#' @param  startindex  <what param does>
#' @param  maxresults  max number of results
#' @param  format  specifies the format in which the records are to be returned,
#     one of: brief, darwin or kml (character)
#' @param  icon  <what param does>
#' @param mode  specifies whether the response data should (as far as possible)  be the raw values originally retrieved from the data resource or processed (normalised) values used within the data portal (character)latlongdf: return a data.frame of lat/long's for all occurrences (logical)
#' @param  stylesheet sets the URL of the stylesheet to be associated with the
#     response document.
#' @param  latlongdf  <what param does>
#' @param url the base GBIF API url for the function (should be left to default)
#' @param ... optional additional curl options (debugging tools mostly)
#' @param curl If using in a loop, call getCurlHandle() first and pass 
#'  the returned value in here (avoids unnecessary footprint)
#' @export
#' @examples \dontrun{
#' occurrencelist(sciname = "Accipiter erythronemius", coordinatestatus = TRUE, maxresults = 100)
#' }
occurrencelist <- function(sciname = NA, taxonconceptKey = NA, dataproviderkey = NA,
  dataresourcekey = NA, resourcenetworkkey = NA, basisofrecordcode = NA,
  minlatitude = NA, maxlatitude = NA, minlongitude = NA, maxlongitude = NA,
  minaltitude = NA, maxaltitude = NA, mindepth = NA, maxdepth = NA,
  cellid = NA, centicellid = NA, typesonly = NA, georeferencedonly = NA,
  coordinatestatus = NA, coordinateissues = NA, hostisocountrycode = NA,
  originisocountrycode = NA, originregioncode = NA, startdate = NA, enddate = NA,
  startyear = NA, endyear = NA, year = NA, month = NA, day = NA,
  modifiedsince = NA, startindex = NA, maxresults = 10, format = NA, icon = NA,
  mode = NA, stylesheet = NA, latlongdf = FALSE,
  url = 'http://data.gbif.org/ws/rest/occurrence/list?',
  ...,
  curl = getCurlHandle())
{
  if(!is.na(sciname)) {sciname2 <- paste('scientificname=', gsub(" ", "+", sciname), sep='')} else
    {sciname2 <- NULL}
  if(!is.na(coordinatestatus)) {coordinatestatus2 <- paste('&coordinatestatus=', coordinatestatus, sep='')} else
    {coordinatestatus2 <- NULL}
  if(!is.na(maxresults)) {maxresults2 <- paste('&maxresults=', maxresults, sep='')} else
    {maxresults2 <- NULL}
  args <- paste(sciname2, maxresults2, coordinatestatus2, sep='')
  query <- paste(url, args, sep='')
  tt <- getURL(query,
    ...,
    curl = curl)
  out <- xmlTreeParse(tt)$doc$children$gbifResponse
  if(latlongdf == TRUE) {
    latlist <- xpathApply(out, "//to:decimalLatitude")
    longlist <- xpathApply(out, "//to:decimalLongitude")
    df <- data.frame(rep(sciname, length(latlist)),
      laply(latlist, function(x) as.numeric(xmlValue(x))),
      laply(longlist, function(x) as.numeric(xmlValue(x))))
    names(df) <- c("sciname", "latitude", "longitude")
    df
  } else {out}
}

# out <- occurrencelist(sciname = "Aratinga holochlora rubritorquis", coordinatestatus = TRUE,
#     maxresults = 10, latlongdf = TRUE)
# out