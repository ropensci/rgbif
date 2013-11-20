\name{occurrencelist}
\alias{occurrencelist}
\title{Occurrencelist searches for taxon concept records matching a range of filters.}
\usage{
  occurrencelist(scientificname = NULL,
    taxonconceptkey = NULL, dataproviderkey = NULL,
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
    modifiedsince = NULL, startindex = NULL,
    maxresults = 10, format = "brief", icon = NULL,
    mode = NULL, stylesheet = NULL, removeZeros = FALSE,
    writecsv = NULL, curl = getCurlHandle(),
    fixnames = "none")
}
\arguments{
  \item{scientificname}{scientitic name of taxon. See
  details. (character)}

  \item{taxonconceptkey}{unique key for taxon. See details
  (numeric)}

  \item{dataproviderkey}{Filter records to those provided
  by the supplied numeric key for a data provider. See
  \link{providers}. (character)}

  \item{dataresourcekey}{Filter records to those provided
  by the supplied numeric key for a data resource See
  \link{resources}. (character)}

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
  64,799)}

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

  \item{startindex}{return the subset of the matching
  records that starts at the supplied (zero-based index).}

  \item{maxresults}{max number of results (integer)
  (1-10000); defaults to 10}

  \item{format}{specifies the format in which the records
  are to be returned,}

  \item{icon}{(only when format is set to kml) specified
  the URL for an icon to be used for the KML Placemarks.}

  \item{mode}{One of processed or raw. Specifies whether
  the response data should (as far as possible) be the raw
  values originally retrieved from the data resource or
  processed (normalised) values used within the data portal
  (character)}

  \item{stylesheet}{Sets the URL of the stylesheet to be
  associated with the}

  \item{removeZeros}{remove records with both Lat Long zero
  values (logical)}

  \item{writecsv}{If path to a file is given, a text file
  is written out and a success message is returned to the
  console (logical)}

  \item{curl}{If using in a loop, call getCurlHandle()
  first and pass the returned value in here (avoids
  unnecessary footprint)}

  \item{fixnames}{One of "match","change","none", just keep
  those records that match original search term, change all
  names to the original search term (beware using this
  option), or do nothing, respectively. Default is "none".}
}
\description{
  This function is deprecated.
}
\details{
  Including many possible values for a particular
  parameter: The following parameters may have many values
  passed to them (e.g., like parameter=c('a','b')):
  scientificname, taxonconceptkey, dataproviderkey,
  dataresourcekey, resourcenetworkkey, basisofrecordcode,
  cellid, centicellid, hostisocountrycode,
  originisocountrycode, originregioncode, year, month, and
  day.

  More on scientificname: Returns only records where the
  scientific name matches that supplied - this is based on
  the scientific name found in the original record from the
  data provider and does not make use of extra knowledge of
  possible synonyms or of child taxa.  For these functions,
  use taxonconceptkey. Including an asterisk '*' in the
  search string causes the service to return records for
  any name starting with the string preceding the asterisk.
  There must be at least three characters preceding the
  asterisk. The scientificname parameter may be repeated
  within a single request - the results will include
  records matching any of the supplied scientific names.

  More on taxonconceptkey: Returns only records which are
  for the taxon identified by the supplied numeric key,
  including any records provided under synonyms of the
  taxon concerned, and any records for child taxa (e.g. all
  genera and species within a family).  Values for
  taxonconceptkey can be found through the taxon web
  service (see http://data.gbif.org/ws/rest/taxon).  Note
  that the service will always search using the
  corresponding concept in the synthetic generated "PORTAL"
  taxonomy (even if the taxonconceptkey is for a concept
  from a specific resource.  Use dataresourcekey to limit
  the search to a single data resource.  The most efficient
  and thorough way to search will be to limit searches to
  taxa belonging to the following ranks: kingdom, phylum,
  class, order, family, genus, species, any infraspecific
  rank. Each record returned from this action (and from the
  get action) also includes a taxonKey attribute which can
  be used in the taxonconceptkey parameter on subsequent
  invocations of the list and count actions. The
  taxonconceptkey parameter may be repeated within a single
  request - the results will include records for any of the
  specified taxa.

  See the GBIF API docs for more details on each parameter:
  http://data.gbif.org/ws/rest/occurrence
}
\examples{
\dontrun{
# Query for a single species
occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE)
occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE,
   maxresults = 40)
occurrencelist(scientificname = 'Accipiter erythronemius', coordinatestatus = TRUE,
   maxresults = 5)

# Query for many species, in this case using parallel fuctionality with plyr::llply
# Also, see \\code{\\link{occurrencelist_many}} as an alternative way to search for
# many species, which is better for going straight to a map with the output data.
library(doMC); library(plyr)
registerDoMC(cores=4)
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
out <- llply(splist, function(x) occurrencelist(x, coordinatestatus = TRUE,
             maxresults = 100), .parallel=T)
lapply(out, function(x) head(gbifdata(x)))

# Write the output to csv file
occurrencelist(scientificname = 'Erebia gorge*',
   coordinatestatus = TRUE, maxresults = 200, writecsv="~/adsdf.csv")
}
}
\seealso{
  occ_search
}

