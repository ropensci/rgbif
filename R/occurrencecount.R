#' Counts taxon concept records matching a range of filters.
#' 
#' @import XML httr
#' @param  scientificname count only records where the scientific name matches 
#'  	that supplied, use an asterisk * for any name starting with preseding 
#'		string (character). does not make use of extra knowledge of possible synonyms 
#'		or of child taxa.  For these functions, use taxonconceptkey. May be repeted in single request.
#' @param  taxonconceptKey unique key for taxon (numeric). Count only records which are 
#'		for the taxon identified by the supplied numeric key, including any records provided 
#'		under synonyms of the taxon concerned, and any records for child taxa 
#'		(e.g. all genera and species within a family).  May be repeted in single request.
#' @param  dataproviderkey Filter records to those provided by the supplied
#'    numeric key for a data provider. See provider(). (character)
#' @param  dataresourcekey Filter records to those provided by the supplied
#'    numeric key for a data resource See resource(). (character)
#' @param  institutioncode Return only records from a given institution code.
#' @param  collectioncode Return only records from a given collection code.
#' @param  catalognumber Return only records from a given catalog number.                 
#' @param  resourcenetworkkey  count only records which have been made available by 
#'		resources identified as belonging to the network identified by the supplied numeric key.
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
#' @param  cellid  identifier for a one degree cell (O - 64,799). 
#'		Using a cellid is more efficient than using a bounding box for the same cell.
#' @param  centicellid  identifier for a 0.1 degree cell within a one degree cell 
#' @param  typesonly  if set to "true", return only records with a type status specified.
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
#' @param url the base GBIF API url for the function (should be left to default)
#' @param ... optional additional curl options (debugging tools mostly)
#' @param curl If using in a loop, call getCurlHandle() first and pass
#'		the returned value in here (avoids unnecessary footprint)
#' @export
#' @examples \dontrun{
#' occurrencecount(scientificname = 'Accipiter erythronemius', coordinatestatus = TRUE)
#' occurrencecount(scientificname = 'Helianthus annuus', coordinatestatus = TRUE, year=2009)
#' occurrencecount(scientificname = 'Helianthus annuus', coordinatestatus = TRUE, year=2005, maxlatitude=20)
#' }
occurrencecount <- function(scientificname = NULL, taxonconceptKey = NULL,
	dataproviderkey = NULL, dataresourcekey = NULL, institutioncode = NULL ,
	collectioncode = NULL, catalognumber = NULL, resourcenetworkkey = NULL,
	basisofrecordcode = NULL, minlatitude = NULL, maxlatitude = NULL,
	minlongitude = NULL, maxlongitude = NULL, minaltitude = NULL, maxaltitude = NULL,
	mindepth = NULL, maxdepth = NULL, cellid = NULL, centicellid = NULL,
	typesonly = NULL, coordinatestatus = NULL,
	coordinateissues = NULL, hostisocountrycode = NULL, originisocountrycode = NULL,
	originregioncode = NULL, startdate = NULL, enddate = NULL, startyear = NULL,
	endyear = NULL, year = NULL, month = NULL, day = NULL, modifiedsince = NULL,
	url = "http://data.gbif.org/ws/rest/occurrence/count", ..., 
	curl = getCurlHandle()) 
{  
	querystr <- compact(list(scientificname = scientificname, taxonconceptKey = taxonconceptKey,
		dataproviderkey = dataproviderkey, dataresourcekey = dataresourcekey, 
		institutioncode = institutioncode,	 collectioncode = collectioncode, catalognumber = catalognumber, 
		resourcenetworkkey = resourcenetworkkey,	basisofrecordcode = basisofrecordcode, 
		minlatitude = minlatitude, maxlatitude = maxlatitude, minlongitude = minlongitude, 
		maxlongitude = maxlongitude, minaltitude = minaltitude, maxaltitude = maxaltitude,
		mindepth = mindepth, maxdepth = maxdepth, cellid = cellid, centicellid = centicellid,
		typesonly = typesonly, coordinatestatus = coordinatestatus, coordinateissues = coordinateissues, 
		hostisocountrycode = hostisocountrycode, originisocountrycode = originisocountrycode,
		originregioncode = originregioncode, startdate = startdate, enddate = enddate, startyear = startyear,
		endyear = endyear, year = year, month = month, day = day, modifiedsince = modifiedsince))
	
	temp <- GET(url, query = querystr)
	out <- content(temp)$doc$children$gbifResponse
	as.numeric(xmlGetAttr(getNodeSet(out, "//gbif:summary")[[1]], "totalMatched"))
}