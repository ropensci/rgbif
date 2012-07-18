\name{occurrencecount}
\alias{occurrencecount}
\title{Counts taxon concept records matching a range of filters.}
\usage{
  occurrencecount(scientificname = NULL,
    taxonconceptKey = NULL, dataproviderkey = NULL,
    dataresourcekey = NULL, institutioncode = NULL,
    collectioncode = NULL, catalognumber = NULL,
    resourcenetworkkey = NULL, basisofrecordcode = NULL,
    minlatitude = NULL, maxlatitude = NULL,
    minlongitude = NULL, maxlongitude = NULL,
    minaltitude = NULL, maxaltitude = NULL,
    mindepth = NULL, maxdepth = NULL, cellid = NULL,
    centicellid = NULL, typesonly = NULL,
    coordinatestatus = NULL, coordinateissues = NULL,
    hostisocountrycode = NULL, originisocountrycode = NULL,
    originregioncode = NULL, startdate = NULL,
    enddate = NULL, startyear = NULL, endyear = NULL,
    year = NULL, month = NULL, day = NULL,
    modifiedsince = NULL,
    url = "http://data.gbif.org/ws/rest/occurrence/count",
    ..., curl = getCurlHandle())
}
\arguments{
  \item{sciname}{count only records where the scientific
  name matches that supplied, use an asterisk * for any
  name starting with preseding string (character). does not
  make use of extra knowledge of possible synonyms or of
  child taxa.  For these functions, use taxonconceptkey.
  May be repeted in single request.}

  \item{taxonconceptKey}{unique key for taxon (numeric).
  Count only records which are for the taxon identified by
  the supplied numeric key, including any records provided
  under synonyms of the taxon concerned, and any records
  for child taxa (e.g. all genera and species within a
  family).  May be repeted in single request.}

  \item{dataproviderkey}{Filter records to those provided
  by the supplied numeric key for a data provider. See
  provider(). (character)}

  \item{dataresourcekey}{Filter records to those provided
  by the supplied numeric key for a data resource See
  resource(). (character)}

  \item{institutioncode}{Return only records from a given
  institution code.}

  \item{collectioncode}{Return only records from a given
  collection code.}

  \item{catalognumber}{Return only records from a given
  catalog number.}

  \item{resourcenetworkkey}{count only records which have
  been made available by resources identified as belonging
  to the network identified by the supplied numeric key.}

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
  64,799).  Using a cellid is more efficient than using a
  bounding box for the same cell.}

  \item{centicellid}{identifier for a 0.1 degree cell
  within a one degree cell}

  \item{typesonly}{if set to "true", return only records
  with a type status specified.}

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

  \item{url}{the base GBIF API url for the function (should
  be left to default)}

  \item{...}{optional additional curl options (debugging
  tools mostly)}

  \item{curl}{If using in a loop, call getCurlHandle()
  first and pass the returned value in here (avoids
  unnecessary footprint)}
}
\description{
  Counts taxon concept records matching a range of filters.
}
\examples{
\dontrun{
occurrencecount(scientificname = 'Accipiter erythronemius', coordinatestatus = TRUE)
occurrencecount(scientificname = 'Helianthus annuus', coordinatestatus = TRUE, year=2009)
occurrencecount(scientificname = 'Helianthus annuus', coordinatestatus = TRUE, year=2005, maxlatitude=20)
}
}

