#' Occurrencelist searches for taxon concept records matching a range of filters.
#'
#' @import RCurl XML plyr httr
#' @param  scientificname scientitic name of taxon (character, see example)
#' @param  taxonconceptKey unique key for taxon (numeric)
#' @param  dataproviderkey Filter records to those provided by the supplied
#'    numeric key for a data provider. See \link{providers}. (character)
#' @param  dataresourcekey Filter records to those provided by the supplied
#'    numeric key for a data resource See \link{resources}. (character)
#' @param  institutioncode Return only records from a given institution code.
#' @param  collectioncode Return only records from a given collection code.
#' @param  catalognumber Return only records from a given catalog number.                 
#' @param  resourcenetworkkey  count only records which have been made available by 
#'    resources identified as belonging to the network identified by the supplied numeric key.
#' @param  basisofrecordcode  return only records with the specified basis of record.
#'    Supported values are: "specimen, observation, living, germplasm, fossil, unknown".
#'    (character)
#' @param  minlatitude  return only records from locations with latitudes greater 
#'    than the supplied value (southern hemisphere with negative latitudes). (numeric)
#' @param  maxlatitude  return only records from locations with latitudes lower than 
#'    the supplied value (southern hemisphere with negative latitudes). (numeric)
#' @param  minlongitude  return only records from locations with longitudes greater 
#'    than the supplied value (western hemisphere with negative longitudes). (numeric)
#' @param  maxlongitude  return only records from locations with longitudes lower 
#'    than the supplied value (western hemisphere with negative longitudes). (numeric)
#' @param  minaltitude  return only records from altitudes greater than or equal to 
#'    the supplied value. (integer)
#' @param  maxaltitude  return only records from altitudes less than or equals to 
#'    the supplied value. (integer)
#' @param  mindepth  return only records from depth greater than or equal to the supplied 
#'    value. (numeric 2 decimal places)
#' @param  maxdepth  return only records from depth less than or equals to the supplied 
#'    value. (numeric 2 decimal places)
#' @param  cellid  identifier for a one degree cell (O - 64,799)
#' @param  centicellid  identifier for a 0.1 degree cell within a one degree cell 
#' @param  typesonly  if set to "true", return only records with a type status specified.
#' @param  georeferencedonly  This option is deprecated.
#' @param  coordinatestatus  if set to "true", return only records with coordinates. 
#'    If set to "false", return only records without coordinates.
#' @param  coordinateissues  if set to "true", return only records for which the portal 
#'    has detected possible issues in georeferencing. If set to "false", return only 
#'    records for which the portal has not detected any such issues.
#' @param  hostisocountrycode  return only records served by providers from the country 
#'    identified by the supplied 2-letter ISO code.
#' @param  originisocountrycode return only records of occurrences which occurred 
#'    within the country identified by the supplied 2-letter ISO code. 
#' @param  originregioncode  return only records of occurrences which occurred 
#'    within the region identified by the supplied 3-letter code.
#' @param  startdate  return only records occurring on or after the supplied date 
#'    (format YYYY-MM-DD, e.g. 2006-11-28).
#' @param  enddate  return only records occurring on or before the supplied date 
#'    (format YYYY-MM-DD, e.g. 2006-11-28).
#' @param  startyear  return only records from during or after the supplied year.
#' @param  endyear  return only records from during or before the supplied year.
#' @param  year  return only records from during the supplied year.
#' @param  month  return only records from during the supplied month (expressed as 
#'    an integer in the range 1 to 12).
#' @param  day  return only records from during the supplied day of month 
#'    (expressed as an integer in the range 1 to 31).
#' @param modifiedsince  return only records which have been indexed or modified 
#'    in the GBIF data portal index on or after the supplied date 
#'    (format YYYY-MM-DD, e.g. 2006-11-28). 
#' @param  startindex  return the subset of the matching records that starts at 
#'    the supplied (zero-based index). 
#' @param  maxresults  max number of results (integer) (1-10000)
#' @param  format  specifies the format in which the records are to be returned,
#     one of: brief or darwin (character) default is brief.
#' @param  icon  (only when format is set to kml) specified the URL for an icon
#'    to be used for the KML Placemarks.
#' @param mode Specifies whether the response data should (as far as possible)  
#'    be the raw values originally retrieved from the data resource or processed 
#'    (normalised) values used within the data portal (character)
#' @param stylesheet Sets the URL of the stylesheet to be associated with the
#     response document.
#' @param latlongdf Return a data.frame of lat/long's for all occurrences (logical)
#' @param removeZeros remove records with both Lat Long zero values (logical) 
#' @param writecsv If path to a file is given, a text file is written out and 
#' 		a success message is returned to the console (logical)
#' @param url the base GBIF API url for the function (should be left to default)
#' @param ... optional additional curl options (debugging tools mostly)
#' @param curl If using in a loop, call getCurlHandle() first and pass
#' the returned value in here (avoids unnecessary footprint)
#' @examples \dontrun{
#' occurrencelist(scientificname = 'Accipiter erythronemius', coordinatestatus = TRUE, maxresults = 100, latlongdf = T)
#' occurrencelist(scientificname = 'Accipiter erythronemius', coordinatestatus = TRUE, maxresults = 100, latlongdf=F)
#' occurrencelist(scientificname = 'Accipiter erythronemius', coordinatestatus = TRUE, maxresults = 100, latlongdf=T, writecsv="~/myyyy.csv")
#' }
#' @export
occurrencelist <- function(scientificname = NULL, taxonconceptKey = NULL,
		dataproviderkey = NULL, dataresourcekey = NULL, institutioncode = NULL,
		collectioncode = NULL, catalognumber = NULL, resourcenetworkkey = NULL,
		basisofrecordcode = NULL, minlatitude = NULL, maxlatitude = NULL,
		minlongitude = NULL, maxlongitude = NULL, minaltitude = NULL, maxaltitude = NULL,
		mindepth = NULL, maxdepth = NULL, cellid = NULL, centicellid = NULL,
		typesonly = NULL, georeferencedonly = NULL, coordinatestatus = NULL,
		coordinateissues = NULL, hostisocountrycode = NULL, originisocountrycode = NULL,
		originregioncode = NULL, startdate = NULL, enddate = NULL, startyear = NULL,
		endyear = NULL, year = NULL, month = NULL, day = NULL, modifiedsince = NULL,
		startindex = NULL, maxresults = 10, format = NA, icon = NULL,
		mode = NULL, stylesheet = NULL, latlongdf = FALSE, removeZeros = FALSE, writecsv = NULL,
		url = "http://data.gbif.org/ws/rest/occurrence/list", ..., curl = getCurlHandle()) 
{
	# Code based on the `gbifxmlToDataFrame` function from dismo package 
	# (http://cran.r-project.org/web/packages/dismo/index.html),
	# by Robert Hijmans, 2012-05-31, License: GPL v3
	gbifxmlToDataFrame <- function(doc, format) {
		nodes <- getNodeSet(doc, "//to:TaxonOccurrence")
		if (length(nodes) == 0) 
			return(data.frame())
		if(!is.na(format) & format=="darwin"){
			varNames <- c("country", "stateProvince", 
										"county", "locality", "decimalLatitude", "decimalLongitude", 
										"coordinateUncertaintyInMeters", "maximumElevationInMeters", 
										"minimumElevationInMeters", "maximumDepthInMeters", 
										"minimumDepthInMeters", "institutionCode", "collectionCode", 
										"catalogNumber", "basisOfRecordString", "collector", 
										"earliestDateCollected", "latestDateCollected", "gbifNotes")
		}else{
			varNames <- c("country", "decimalLatitude", "decimalLongitude", 
										"catalogNumber", "earliestDateCollected", "latestDateCollected" )
		}
		dims <- c(length(nodes), length(varNames))
		ans <- as.data.frame(replicate(dims[2], rep(as.character(NA), 
										dims[1]), simplify = FALSE), stringsAsFactors = FALSE)
		names(ans) <- varNames
		for (i in seq(length = dims[1])) {
			ans[i, ] <- xmlSApply(nodes[[i]], xmlValue)[varNames]
		}
		nodes <- getNodeSet(doc, "//to:Identification")
		varNames <- c("taxonName")
		dims = c(length(nodes), length(varNames))
		tax = as.data.frame(replicate(dims[2], rep(as.character(NA), 
										dims[1]), simplify = FALSE), stringsAsFactors = FALSE)
		names(tax) = varNames
		for (i in seq(length = dims[1])) {
			tax[i, ] = xmlSApply(nodes[[i]], xmlValue)[varNames]
		}
		cbind(tax, ans)
	}
	#End gbifxmlToDataFrame -----
	
	args <- compact(
		list(
			scientificname=scientificname, dataproviderkey=dataproviderkey,
			dataresourcekey=dataresourcekey, institutioncode=institutioncode,
			collectioncode=collectioncode, catalognumber=catalognumber,
			resourcenetworkkey=resourcenetworkkey, taxonconceptKey=taxonconceptKey,
			basisofrecordcode=basisofrecordcode, coordinatestatus=coordinatestatus, 
			minlatitude=minlatitude, maxlatitude=maxlatitude, minlongitude=minlongitude, 
			maxlongitude=maxlongitude, minaltitude=minaltitude, maxaltitude=maxaltitude, 
			mindepth=mindepth, maxdepth=maxdepth, cellid=cellid, centicellid=centicellid,
			typesonly=typesonly, coordinateissues=coordinateissues,
			hostisocountrycode=hostisocountrycode, originisocountrycode=originisocountrycode,
			originregioncode=originregioncode, startdate=startdate, enddate=enddate,
			startyear=startyear, endyear=endyear, year=year, month=month, day=day,
			modifiedsince=modifiedsince, startindex=startindex, format=format,
			icon=icon, mode=mode, stylesheet=stylesheet, maxresults=maxresults
		))
	tt <- getForm(url, .params = args, curl = curl)
	out <- xmlParse(tt)
	if (latlongdf == TRUE) {
		df <- gbifxmlToDataFrame(out, format)
		df[, "decimalLongitude"] <- as.numeric(df[, "decimalLongitude"])
		df[, "decimalLatitude"] <- as.numeric(df[, "decimalLatitude"])
		i <- df[, "decimalLongitude"] == 0 & df[, "decimalLatitude"] == 0
		if (removeZeros) {
			df <- df[!i, ]
		} else 
			{
				df[i, "decimalLatitude"] <- NA
				df[i, "decimalLongitude"] <- NA 
			}
		if(!is.null(writecsv)){
			write.csv(df, file=writecsv)
			message("Success! CSV file written")
		}
		df
	} else { out }
}