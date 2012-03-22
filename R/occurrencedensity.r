#'returns summary counts of occurrence records by one-degree cell for a single
#' taxon, country, dataset, data publisher or data network
#'@import RCurl XML
#'@param taxonconceptkey numeric key uniquely identifying the taxon
#'@param dataproviderkey numeric key uniquely identifying the data provider
#'@param dataresourcekey numeric key uniquely identifying the data resource
#'@param resourcenetworkkey numeric key uniquely identifying the data network
#'@param originisocountrycode numeric key uniquely identifying the country
#'@param format specifies the format in which the records are to be returned,
#' one of: brief, darwin or kml (character)
#'@param url the base GBIF API url for the function (should be left to default)
#'@param ... optional additional curl options (debugging tools mostly)
#'@param curl If using in a loop, call getCurlHandle() first and pass
#' the returned value in here (avoids unnecessary footprint)
#'@export
#'@examples \dontrun{
#'occurrencedensity(originisocountrycode='CA')
#'occurrencedensity(taxonconceptkey=45)
#'}
occurrencedensity <- function(taxonconceptkey = NA,
    dataproviderkey = NA, dataresourcekey = NA, resourcenetworkkey = NA,
    originisocountrycode = NA, format = NA, url = "http://data.gbif.org/ws/rest/density/list",
    ..., curl = getCurlHandle()) {
    args <- list()
    if (!is.na(taxonconceptkey))
        args$taxonconceptkey <- taxonconceptkey
    if (!is.na(dataproviderkey))
        args$dataproviderkey <- dataproviderkey
    if (!is.na(dataresourcekey))
        args$dataresourcekey <- dataresourcekey
    if (!is.na(resourcenetworkkey))
        args$resourcenetworkkey <- resourcenetworkkey
    if (!is.na(originisocountrycode))
        args$originisocountrycode <- originisocountrycode
    if (!is.na(format))
        args$format <- format
    out <- getForm(url, .params = args, ..., curl = curl)
    tt <- xmlParse(out)
    data.frame(cellid = xpathSApply(tt, "//gbif:densityRecord",
        xmlAttrs), minlat = xpathSApply(tt, "//gbif:densityRecord/gbif:minLatitude",
        xmlValue), maxlat = xpathSApply(tt, "//gbif:densityRecord/gbif:maxLatitude",
        xmlValue), minlong = xpathSApply(tt, "//gbif:densityRecord/gbif:minLongitude",
        xmlValue), maxlong = xpathSApply(tt, "//gbif:densityRecord/gbif:maxLongitude",
        xmlValue), count = xpathSApply(tt, "//gbif:densityRecord/gbif:count",
        xmlValue))
}
