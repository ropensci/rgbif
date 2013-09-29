\name{density_spplist}
\alias{density_spplist}
\alias{densitylist}
\alias{gbifdata.gbifdens}
\alias{gbifdata.gbiflist}
\alias{gbifmap_dens}
\alias{gbifmap_list}
\alias{is.gbifdens}
\alias{is.gbiflist}
\alias{occurrencecount}
\alias{occurrencedensity}
\alias{occurrenceget}
\alias{occurrencelist}
\alias{occurrencelist_all}
\alias{occurrencelist_many}
\alias{print.gbifdens}
\alias{print.gbiflist}
\alias{providers}
\alias{resources}
\alias{taxoncount}
\alias{taxonget}
\alias{taxonsearch}
\title{The density web service provides access to records showing the density
   of occurrence records from the GBIF Network by one-degree cell.}
\usage{
  density_spplist(taxonconceptKey = NULL,
    dataproviderkey = NULL, dataresourcekey = NULL,
    resourcenetworkkey = NULL, originisocountrycode = NULL,
    format = NULL,
    spplist = c("none", "random", "greatest", "all"),
    listcount = "list")

  densitylist(taxonconceptKey = NULL,
    dataproviderkey = NULL, dataresourcekey = NULL,
    resourcenetworkkey = NULL, originisocountrycode = NULL,
    format = NULL)

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
    modifiedsince = NULL)

  occurrencedensity()

  occurrenceget(key = NULL, format = NULL, mode = NULL)

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

  occurrencelist_all(scientificname, ...)

  occurrencelist_many(scientificname = NULL,
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
    fixnames = "none", parallel = FALSE, cores = 4)

  providers(name = "", isocountrycode = NULL,
    modifiedsince = NULL, startindex = NULL,
    maxresults = NULL)

  resources(name = "", providerkey = NULL,
    basisofrecordcode = NULL, modifiedsince = NULL,
    startindex = NULL, maxresults = NULL)

  taxoncount(scientificname = NULL, rank = NULL,
    dataresourcekey = NULL)

  taxonget(key = NULL)

  taxonsearch(scientificname = NULL, rank = NULL,
    maxresults = 10, dataproviderkey = 1,
    dataresourcekey = NULL, resourcenetworkkey = NULL,
    hostisocountrycode = NULL, startindex = NULL,
    accepted_status = FALSE)

  gbifmap_dens(input = NULL, mapdatabase = "world",
    region = ".", geom = geom_point, jitter = NULL,
    customize = NULL)

  gbifmap_list(input = NULL, mapdatabase = "world",
    region = ".", geom = geom_point, jitter = NULL,
    customize = NULL)

  \method{gbifdata}{gbiflist} (input,
    coordinatestatus = FALSE, minimal = TRUE, ...)

  \method{gbifdata}{gbifdens} (input, ...)

  \method{print}{gbifdens} (x, ...)

  \method{print}{gbiflist} (x, ...)

  is.gbiflist(x)

  is.gbifdens(x)
}
\arguments{
  \item{taxonconceptKey}{Unique key for taxon (numeric).
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

  \item{resourcenetworkkey}{count only records which have
  been made available by resources identified as belonging
  to the network identified by the supplied numeric key.}

  \item{originisocountrycode}{Return density records for
  occurrences which occurred within the country identified
  by the supplied 2-letter ISO code.}

  \item{format}{Specifies the format in which the records
  are to be returned, one of: brief or kml (character)}

  \item{spplist}{Get the species list for a 1 degree cell.
  One of "none", "random", "greatest", or "all". "none"
  returns the data.frame of count of specimens by 1 degree
  cells without species list. "random" returns a species
  list selected randomly from one of the cells. "greatest"
  returns a species list selected from the cell with the
  greatest number of specimens.  "all" returns species
  lists from all cells in a list. Be aware that calling
  "all" could take quite a while, so plan accordingly.}

  \item{listcount}{Return a species list ('splist') or a
  data.frame of the species and the count for each species
  ('counts').}

  \item{taxonconceptKey}{Unique key for taxon (numeric).
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

  \item{resourcenetworkkey}{count only records which have
  been made available by resources identified as belonging
  to the network identified by the supplied numeric key.}

  \item{originisocountrycode}{Return density records for
  occurrences which occurred within the country identified
  by the supplied 2-letter ISO code.}

  \item{format}{Specifies the format in which the records
  are to be returned, one of: brief or kml (character)}

  \item{scientificname}{count only records where the
  scientific name matches that supplied, use an asterisk *
  for any name starting with preseding string (character).
  does not make use of extra knowledge of possible synonyms
  or of child taxa.  For these functions, use
  taxonconceptkey. May be repeted in single request.}

  \item{taxonconceptKey}{unique key for taxon (numeric).
  Count only records which are for the taxon identified by
  the supplied numeric key, including any records provided
  under synonyms of the taxon concerned, and any records
  for child taxa (e.g. all genera and species within a
  family).  May be repeted in single request.}

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

  \item{key}{numeric key uniquely identifying the
  occurrence record within the GBIF}

  \item{format}{specifies the format in which the records
  are to be returned, one of: brief, darwin or kml
  (character)}

  \item{mode}{specifies whether the response data should
  (as far as possible) be the raw values originally
  retrieved from the data resource or processed
  (normalised) values used within the data portal
  (character)}

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

  \item{scientificname}{A scientific name. (character)}

  \item{...}{Further arguments passed on to
  occurrencelist_many}

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

  \item{parallel}{Do calls in parallel or not. (default is
  FALSE)}

  \item{cores}{Number of cores to use in parallel call
  option (only used if parallel=TRUE)}

  \item{name}{data provider name search string, by default
  searches all data providers by defining name = ''}

  \item{isocountrycode}{return only providers from the
  country identified by the supplied 2-letter ISO code.}

  \item{modifiedsince}{return only records which have been
  indexed or modified on or after the supplied date (format
  YYYY-MM-DD, e.g. 2006-11-28)}

  \item{startindex}{return the subset of the matching
  records that starts at the supplied (zero-based index).}

  \item{maxresults}{max number of results to return}

  \item{name}{data provider name search string, by default
  searches all data resources by defining name = ''}

  \item{providerkey}{Filter records to those provided by
  the supplied numeric key for a data provider. See
  \link{providers}(). (character)}

  \item{basisofrecordcode}{return only records with the
  specified basis of record.  Supported values are:
  "specimen, observation, living, germplasm, fossil,
  unknown".  (character)}

  \item{modifiedsince}{return only records which have been
  indexed or modified on or after the supplied date (format
  YYYY-MM-DD, e.g. 2006-11-28)}

  \item{startindex}{return the subset of the matching
  records that starts at the supplied (zero-based index).}

  \item{maxresults}{max number of results to return}

  \item{scientificname}{Scientitic name of taxon
  (character, see example)}

  \item{rank}{Rank of taxon, see taxrank() (character)}

  \item{dataresourcekey}{Filter records to those provided
  by the supplied numeric key for a data resource. See
  resources(). (character)}

  \item{key}{A single key, or many keys in a vector, for a
  taxon.}

  \item{scientificname}{scientific name of taxon
  (character, see example)}

  \item{rank}{rank of taxon, see taxrank() (character)}

  \item{maxresults}{return at most the specified number of
  records. The default (and maximum supported) is 1000
  records.}

  \item{dataproviderkey}{Filter records to those provided
  by the supplied numeric key for a data provider. See
  provider(). (character)}

  \item{dataresourcekey}{Filter records to those provided
  by the supplied numeric key for a data resource See
  resource(). (character)}

  \item{resourcenetworkkey}{count only records which have
  been made available by resources identified as belonging
  to the network identified by the supplied numeric key.}

  \item{hostisocountrycode}{return only records served by
  providers from the country identified by the supplied
  2-letter ISO code.}

  \item{startindex}{return the subset of the matching
  records that starts at the supplied (zero-based index).}

  \item{accepted_status}{Status in the GIBF portal}

  \item{input}{Either a single data.frame or a list of
  data.frame's (e.g., from different speies). The
  data.frame has to have, in addition to any other columns,
  columns named exactly "decimalLatitude" and
  "decimalLongitude".}

  \item{mapdatabase}{The map database to use in mapping.
  What you choose here determines what you can choose in
  the region parameter. One of: county, state, usa, world,
  world2, france, italy, or nz.}

  \item{region}{The region of the world to map. From the
  maps package, run
  \code{sort(unique(map_data("world")$region))} to see
  region names for the world database layer, or e.g.,
  \code{sort(unique(map_data("state")$region))} for the
  state layer.}

  \item{geom}{The geom to use, one of geom_point or
  geom_jitter. Don't quote them.}

  \item{jitter}{If you use jitterposition, the amount by
  which to jitter points in width, height, or both.}

  \item{customize}{Further arguments passed on to ggplot.}

  \item{input}{Either a single data.frame or a list of
  data.frame's (e.g., from different speies). The
  data.frame has to have, in addition to any other columns,
  columns named exactly "decimalLatitude" and
  "decimalLongitude".}

  \item{mapdatabase}{The map database to use in mapping.
  What you choose here determines what you can choose in
  the region parameter. One of: county, state, usa, world,
  world2, france, italy, or nz.}

  \item{region}{The region of the world to map. From the
  maps package, run
  \code{sort(unique(map_data("world")$region))} to see
  region names for the world database layer, or e.g.,
  \code{sort(unique(map_data("state")$region))} for the
  state layer.}

  \item{geom}{The geom to use, one of geom_point or
  geom_jitter. Don't quote them.}

  \item{jitter}{If you use jitterposition, the amount by
  which to jitter points in width, height, or both.}

  \item{customize}{Further arguments passed on to ggplot.}

  \item{input}{Input object from a call to occurrencelist,
  occurrencelist_many, or densitylist.}

  \item{minimal}{Only applies to occurrencelist data. If
  TRUE, returns only name, lat, long fields; defaults to
  TRUE.}

  \item{coordinatestatus}{Return only rows of data.frame
  that have lat and long data.}

  \item{...}{further arguments}

  \item{input}{Input object from a call to occurrencelist,
  occurrencelist_many, or densitylist.}

  \item{...}{further arguments}

  \item{x}{an object of class gbifdens}

  \item{...}{further arguments passed to or from other
  methods.}

  \item{x}{an object of class gbiflist}

  \item{...}{further arguments passed to or from other
  methods.}

  \item{x}{input}

  \item{x}{input}
}
\value{
  A vector of scientific species names for one degree grid
  cells.

  A data.frame with the columns \itemize{
  \item{"minLatitude"}{Minimum latitude of the cell}
  \item{"maxLatitude"}{Maximum latitude of the cell}
  \item{"minLongitude"}{Minimum longitude of the cell}
  \item{"maxLongitude"}{Maximum longitude of the cell}
  \item{"count"}{Number of occurrences found} }

  A single numeric value - the number of records found in
  GBIF matching the query.

  A single data.frame of taxonomic information if single
  data.frame is supplied, or a list of data.frame's if a
  list of keys is supplied.

  A data.frame.

  Map (using ggplot2 package) of points on a map or tiles
  on a map.

  Map (using ggplot2 package) of points on a map or tiles
  on a map.
}
\description{
  This function is deprecated.

  This function is deprecated.

  This function is deprecated.

  This function is deprecated.

  Get individual records for a given occurrence record.

  This function is deprecated.

  This function is deprecated.

  This function is deprecated.

  This function is deprecated.

  This function is deprecated.

  This function is deprecated.

  This function is deprecated.

  When searching for taxa, keep in mind that unless you
  want taxon identifiers for a specific data source, leave
  dataproviderkey as the default of 1, which is the GBIF
  backbone taxonomy. Also, always specify the taxonomic
  rank you are searching for - GBIF says the search is more
  efficient if rank is given.

  This function is deprecated.

  This function is deprecated.

  Gbiflist method

  Gbifdens method

  Print summary of gbifdens class

  Print summary of gbiflist class

  Check if object is of class gbiflist

  Check if object is of class gbifdens
}
\details{
  This is similar to the densitylist function. You can get
  the same data.frame of results as densitylist with this
  function, but you can also get a species list or
  data.frame of species and their counts for any degree
  cell.

  Currently, the function returns the record as a list,
  hopefully in future will return a data.frame.

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

  Beware: It takes a while to retrieve the full list of
  providers - so go get more coffee.

  Beware: It takes a while to retrieve the full list of
  resources - so go get more coffee.

  This function is deprecated.

  Search for a taxon using scientific name. Optionally,
  include taxonomic rank in the search. Returns list of
  TaxonConcept key values.

  gbifmap takes care of cleaning up the data.frame
  (removing NA's, etc.)  returned from rgbif functions, and
  creating the map. This function gives a simple map of
  your data.  You can look at the code behing the function
  itself if you want to build on it to make a map according
  to your specfications.

  Note that this function removes values that are
  impossible on the globe, and those rows that have both
  lat and long as NA or zeros.

  gbifmap takes care of cleaning up the data.frame
  (removing NA's, etc.)  returned from rgbif functions, and
  creating the map. This function gives a simple map of
  your data.  You can look at the code behing the function
  itself if you want to build on it to make a map according
  to your specfications.

  Note that this function removes values that are
  impossible on the globe, and those rows that have both
  lat and long as NA or zeros.
}
\examples{
\dontrun{
# Just return the data.frame of counts by cells.
density_spplist(originisocountrycode = "CO")

# Get a species list by cell, choosing one at random
density_spplist(originisocountrycode = "CO", spplist = "random")
density_spplist(originisocountrycode = "CO", spplist = "r") # can abbr. spplist

# Get a species list by cell, choosing the one with the greatest no. of records
density_spplist(originisocountrycode = "CO", spplist = "great")

# Instead of a list, get back a data.frame with species names and counts
density_spplist(originisocountrycode = "CO", spplist = "great", listcount='counts')
}
\dontrun{
head( out <- densitylist(originisocountrycode = "CA") )
}
\dontrun{
occurrencecount(scientificname = 'Accipiter erythronemius', coordinatestatus = TRUE)
occurrencecount(scientificname = 'Helianthus annuus', coordinatestatus = TRUE,
   year=2009)
occurrencecount(scientificname = 'Helianthus annuus', coordinatestatus = TRUE,
   year=2005, maxlatitude=20)
}
\dontrun{
occurrenceget(key = 13749100)
}
\dontrun{
# Query for a single species
occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE,
   maxresults = 40)
occurrencelist(scientificname = 'Accipiter erythronemius', coordinatestatus = TRUE,
   maxresults = 5)

# Query for many species, in this case using parallel fuctionality with plyr::llply
# Also, see \\code{\\link{occurrencelist_many}} as an alternative way to search for
# many species, which is better for going straight to a map with the output data.
library(doMC)
registerDoMC(cores=4)
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
out <- llply(splist, function(x) occurrencelist(x, coordinatestatus = TRUE, maxresults = 100), .parallel=T)
lapply(out, function(x) head(gbifdata(x)))

# Write the output to csv file
occurrencelist(scientificname = 'Erebia gorge*',
   coordinatestatus = TRUE, maxresults = 200, writecsv="~/adsdf.csv")
}
\dontrun{
# Query for a single species
# compare the names returned by occurrencelist to occurrencelist_all
occurrencelist(scientificname = 'Aristolochia serpentaria', coordinatestatus = TRUE,
maxresults = 40)
occurrencelist_all(scientificname = 'Aristolochia serpentaria', coordinatestatus = TRUE,
maxresults = 40)

}
\dontrun{
# Query for a many species
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
out <- occurrencelist_many(splist, coordinatestatus = TRUE, maxresults = 100)
gbifdata(out)
gbifmap_list(out)
}
\dontrun{
# Test the function for a few providers
providers(maxresults=10)

# By data provider name
providers('University of Texas-Austin')
}
\dontrun{
# Test the function for a few resources
resources(maxresults=30)

# By name
resources('Flora')
}
\dontrun{
taxoncount(scientificname = 'Puma concolor')
taxoncount(scientificname = 'Helianthus annuus')
}
\donttest{
taxoncount(rank = 'family')
}
\dontrun{
keys <- taxonsearch(scientificname = 'Puma concolor')
taxonget(keys$gbifkey)

# Just for one key
taxonget(51780668) # taxonconceptkey for Puma concolor
}
\dontrun{
# Do specify the taxonomic rank the you are searching for, rank of species here
taxonsearch(scientificname = 'Puma concolor', rank="species")

# Fabaceae (rank of genus)
taxonsearch(scientificname = 'Abies', rank="genus")

# Fabaceae (rank of family)
taxonsearch(scientificname = 'Fabaceae', rank="family")
}
\dontrun{
# Tile map, using output from densitylist, Canada
out2 <- densitylist(originisocountrycode = "CA") # data for Canada
gbifmap_dens(out2) # on world map
gbifmap_dens(out2, region="Canada") # on Canada map

# Tile map, using gbifdensity, a specific data provider key
# 191 for 'University of Texas at El Paso'
out2 <- densitylist(dataproviderkey = 191) # data for the US
gbifmap_dens(out2) # on world map

# Modify the plotting region
out <- densitylist(originisocountrycode="US")
gbifmap_dens(out, mapdatabase="usa")
}
\dontrun{
# Point map, using output from occurrencelist, example 1
out <- occurrencelist(scientificname = 'Accipiter erythronemius',
   coordinatestatus = TRUE, maxresults = 100)
gbifmap_list(input = out) # make a map using vertmap

# Point map, using output from occurrencelist, example 2, a species with more data
out <- occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE,
   maxresults = 100)
gbifmap_list(input = out) # make a map
gbifmap_list(input = out, region = 'USA') # make a map, just using the US map

# Point map, using output from occurrencelist, many species
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
out <- occurrencelist_many(splist, coordinatestatus = TRUE, maxresults = 20)
gbifmap_list(out)

# Point map, using output from occurrencelist, many species
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa', 'Ceyx fallax',
   'Picoides lignarius', 'Campephilus leucopogon')
out <- occurrencelist_many(splist, coordinatestatus = TRUE, maxresults = 100)
gbifmap_list(out)

# Get occurrences or density by area, using min/max lat/long coordinates
# Setting scientificname="*" so we just get any species
out <- occurrencelist(scientificname="*", minlatitude=30, maxlatitude=35,
   minlongitude=-100, maxlongitude=-95, coordinatestatus = TRUE, maxresults = 500)

# Using `geom_point`
gbifmap_list(out, "state", "texas", geom_point)

# Using geom_jitter to move the points apart from one another
gbifmap_list(out, "state", "texas", geom_jitter, position_jitter(width = 0.3,
   height = 0.3))

# And move points a lot
gbifmap_list(out, "state", "texas", geom_jitter, position_jitter(width = 1, height = 1))

# Customize the plot by passing options to `ggplot()`
mycustom <- function(){
   list(geom_point(size=9)
       )}
out <- occurrencelist(scientificname = 'Accipiter erythronemius',
   coordinatestatus = TRUE, maxresults = 100)
gbifmap_list(out, customize = mycustom())
}
}
\seealso{
  occ_count

  densitylist

  occ_get

  occ_search

  occ_search

  occ_search

  networks organizations datasets

  networks organizations datasets

  occ_count

  name_usage

  occ_search

  gbifmap

  gbifmap
}

