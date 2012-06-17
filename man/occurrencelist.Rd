\name{occurrencelist}
\alias{occurrencelist}
\title{occurrencelist description}
\usage{
  occurrencelist(sciname = NA, taxonconceptKey = NA,
    dataproviderkey = NA, dataresourcekey = NA,
    resourcenetworkkey = NA, basisofrecordcode = NA,
    minlatitude = NA, maxlatitude = NA, minlongitude = NA,
    maxlongitude = NA, minaltitude = NA, maxaltitude = NA,
    mindepth = NA, maxdepth = NA, cellid = NA,
    centicellid = NA, typesonly = NA,
    georeferencedonly = NA, coordinatestatus = NA,
    coordinateissues = NA, hostisocountrycode = NA,
    originisocountrycode = NA, originregioncode = NA,
    startdate = NA, enddate = NA, startyear = NA,
    endyear = NA, year = NA, month = NA, day = NA,
    modifiedsince = NA, startindex = NA, maxresults = 10,
    format = NA, icon = NA, mode = NA, stylesheet = NA,
    latlongdf = FALSE, removeZeros = FALSE,
    url = "http://data.gbif.org/ws/rest/occurrence/list?",
    ..., curl = getCurlHandle())
}
\arguments{
  \item{sciname}{scientitic name of taxon (character, see
  example)}

  \item{taxonconceptKey}{unique key for taxon (numeric)}

  \item{dataproviderkey}{Filter records to those provided
  by the supplied numeric key for a data provider. See
  provider(). (character)}

  \item{dataresourcekey}{Filter records to those provided
  by the supplied numeric key for a data resource See
  resource(). (character)}

  \item{resourcenetworkkey}{<what param does>}

  \item{basisofrecordcode}{return only records with the
  specified basis of record.  Supported values are:
  "specimen, observation, living, germplasm, fossil,
  unknown".  (character)}

  \item{minlatitude}{return only records from locations
  with latitudes greater than the supplied value (southern
  hemisphere with negative latitudes). (numeric)}

  \item{maxlatitude}{return only records from locations
  with latitudes lower than the supplied value (southern
  hemisphere with negative latitudes). (numeric)}

  \item{minlongitude}{return only records from locations
  with longitudes greater than the supplied value (western
  hemisphere with negative longitudes). (numeric)}

  \item{maxlongitude}{return only records from locations
  with longitudes lower than the supplied value (western
  hemisphere with negative longitudes). (numeric)}

  \item{minaltitude}{return only records from altitudes
  greater than or equal to the supplied value. (integer)}

  \item{maxaltitude}{return only records from altitudes
  less than or equals to the supplied value. (integer)}

  \item{mindepth}{return only records from depth greater
  than or equal to the supplied value. (numeric 2 decimal
  places)}

  \item{maxdepth}{return only records from depth less than
  or equals to the supplied value. (numeric 2 decimal
  places)}

  \item{cellid}{identifier for a one degree cell (O -
  64,799)}

  \item{centicellid}{identifier for a 0.1 degree cell
  within a one degree cell}

  \item{typesonly}{if set to "true", return only records
  with a type status specified.}

  \item{georeferencedonly}{This option is deprecated.}

  \item{coordinatestatus}{if set to "true", return only
  records with coordinates.  If set to "false", return only
  records without coordinates.}

  \item{coordinateissues}{if set to "true", return only
  records for which the portal has detected possible issues
  in georeferencing. If set to "false", return only records
  for which the portal has not detected any such issues.}

  \item{hostisocountrycode}{return only records served by
  providers from the country identified by the supplied
  2-letter ISO code.}

  \item{originisocountrycode}{return only records of
  occurrences which occurred within the country identified
  by the supplied 2-letter ISO code.}

  \item{originregioncode}{return only records of
  occurrences which occurred within the region identified
  by the supplied 3-letter code.}

  \item{startdate}{return only records occurring on or
  after the supplied date (format YYYY-MM-DD, e.g.
  2006-11-28).}

  \item{enddate}{return only records occurring on or before
  the supplied date (format YYYY-MM-DD, e.g. 2006-11-28).}

  \item{startyear}{return only records from during or after
  the supplied year.}

  \item{endyear}{return only records from during or before
  the supplied year.}

  \item{year}{return only records from during the supplied
  year.}

  \item{month}{return only records from during the supplied
  month (expressed as an integer in the range 1 to 12).}

  \item{day}{return only records from during the supplied
  day of month (expressed as an integer in the range 1 to
  31).}

  \item{modifiedsince}{return only records which have been
  indexed or modified in the GBIF data portal index on or
  after the supplied date (format YYYY-MM-DD, e.g.
  2006-11-28).}

  \item{startindex}{return the subset of the matching
  records that starts at the supplied (zero-based index).}

  \item{maxresults}{max number of results (integer)
  (1-10000)}

  \item{format}{specifies the format in which the records
  are to be returned,}

  \item{icon}{<what param does>}

  \item{mode}{specifies whether the response data should
  (as far as possible) be the raw values originally
  retrieved from the data resource or processed
  (normalised) values used within the data portal
  (character)}

  \item{stylesheet}{sets the URL of the stylesheet to be
  associated with the}

  \item{latlongdf}{return a data.frame of lat/long's for
  all occurrences (logical)}

  \item{removeZeros}{remove records with both Lat Long zero
  values (logical)}

  \item{url}{the base GBIF API url for the function (should
  be left to default)}

  \item{...}{optional additional curl options (debugging
  tools mostly)}

  \item{curl}{If using in a loop, call getCurlHandle()
  first and pass the returned value in here (avoids
  unnecessary footprint)}
}
\description{
  occurrencelist description
}
\examples{
\dontrun{
occurrencelist(sciname = 'Accipiter erythronemius', coordinatestatus = TRUE, maxresults = 100)
}
}

