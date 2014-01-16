\name{occ_search}
\alias{occ_search}
\title{Search for GBIF occurrences.}
\usage{
occ_search(taxonKey = NULL, country = NULL, publishingCountry = NULL,
  georeferenced = NULL, geometry = NULL, collectorName = NULL,
  basisOfRecord = NULL, datasetKey = NULL, date = NULL,
  catalogNumber = NULL, year = NULL, month = NULL, latitude = NULL,
  longitude = NULL, altitude = NULL, depth = NULL,
  institutionCode = NULL, collectionCode = NULL, spatialIssues = NULL,
  search = NULL, callopts = list(), limit = 20, start = NULL,
  fields = "minimal", return = "all")
}
\arguments{
  \item{taxonKey}{A taxon key from the GBIF backbone. All
  included and synonym taxa are included in the search, so
  a search for aves with taxononKey=212 (i.e.
  /occurrence/search?taxonKey=212) will match all birds, no
  matter which species. You can pass many keys by passing
  occ_search in a call to an lapply-family function (see
  last example below).}

  \item{datasetKey}{The occurrence dataset key (a uuid)}

  \item{catalogNumber}{An identifier of any form assigned
  by the source within a physical collection or digital
  dataset for the record which may not unique, but should
  be fairly unique in combination with the institution and
  collection code.}

  \item{collectorName}{The person who recorded the
  occurrence.}

  \item{collectionCode}{An identifier of any form assigned
  by the source to identify the physical collection or
  digital dataset uniquely within the text of an
  institution.}

  \item{institutionCode}{An identifier of any form assigned
  by the source to identify the institution the record
  belongs to. Not guaranteed to be que.}

  \item{country}{The 2-letter country code (as per
  ISO-3166-1) of the country in which the occurrence was
  recorded. See here
  \url{http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2}}

  \item{basisOfRecord}{Basis of record, as defined in our
  BasisOfRecord enum here \url{http://bit.ly/19kBGhG}.
  Acceptable values are: \itemize{ \item FOSSIL_SPECIMEN An
  occurrence record describing a fossilized specimen.
  \item HUMAN_OBSERVATION An occurrence record describing
  an observation made by one or more people.  \item
  LITERATURE An occurrence record based on literature
  alone.  \item LIVING_SPECIMEN An occurrence record
  describing a living specimen, e.g.  \item
  MACHINE_OBSERVATION An occurrence record describing an
  observation made by a machine.  \item OBSERVATION An
  occurrence record describing an observation.  \item
  PRESERVED_SPECIMEN An occurrence record describing a
  preserved specimen.  \item UNKNOWN Unknown basis for the
  record.  }}

  \item{date}{Occurrence date in ISO 8601 format: yyyy,
  yyyy-MM, yyyy-MM-dd, or MM-dd.}

  \item{year}{The 4 digit year. A year of 98 will be
  interpreted as AD 98.}

  \item{month}{The month of the year, starting with 1 for
  January.}

  \item{search}{Query terms. The value for this parameter
  can be a simple word or a phrase.}

  \item{latitude}{Latitude in decimals between -90 and 90
  based on WGS 84.}

  \item{longitude}{Longitude in decimals between -180 and
  180 based on WGS 84.}

  \item{publishingCountry}{The 2-letter country code (as
  per ISO-3166-1) of the country in which the occurrence
  was recorded.}

  \item{altitude}{Altitude/elevation in meters above sea
  level.}

  \item{depth}{Depth in meters relative to altitude. For
  example 10 meters below a lake surface with given
  altitude.}

  \item{geometry}{Searches for occurrences inside a polygon
  described in Well Known Text (WKT) format. A WKT shape
  written as POLYGON ((30.1 10.1, 20, 20 40, 40 40, 30.1
  10.1)) would be queried as is, i.e.
  \url{http://bit.ly/HwUSif}.}

  \item{spatialIssues}{Includes/excludes occurrence records
  which contain spatial issues (as determined in our record
  interpretation), i.e. spatialIssues=TRUE returns only
  those records with spatial issues while
  spatialIssues=FALSE includes only records without spatial
  issues. The absence of this parameter returns any record
  with or without spatial issues.}

  \item{georeferenced}{Return only occurence records with
  lat/long data (TRUE) or all records (FALSE, default).}

  \item{fields}{(character) Default ('minimal') will return
  just taxon name, key, latitude, and longitute. 'all'
  returns all fields. Or specify each field you want
  returned by name, e.g.  fields =
  c('name','latitude','altitude').}

  \item{return}{One of data, hier, meta, or all. If data, a
  data.frame with the data. hier returns the
  classifications in a list for each record. meta returns
  the metadata for the entire call. all gives all data back
  in a list.}

  \item{callopts}{Pass on options to httr::GET for more
  refined control of http calls, and error handling}

  \item{limit}{Number of records to return}

  \item{start}{Record number to start at}
}
\value{
A data.frame or list
}
\description{
Note that you can pass in a vector to one of taxonkey,
datasetKey, and catalogNumber parameters in a function
call, but not a vector >1 of the three parameters at the
same time

Hierarchies: hierarchies are returned wih each occurrence
object. There is no option no to return them from the API.
However, within the \code{occ_search} function you can
select whether to return just hierarchies, just data, all
of data and hiearchies and metadata, or just metadata. If
all hierarchies are the same we just return one for you.

Data: By default only three data fields are returned: name
(the species name), latitude, and longitude. Set parameter
minimal=FALSE if you want more data.

Nerds: You can pass parameters not defined in this function
into the call to the GBIF API to control things about the
call itself using the \code{callopts} function. See an
example below that passes in the \code{verbose} function to
get details on the http call.

Why can't I search by species name? In the previous GBIF
API and the version of rgbif that wrapped that API, you
could search the equivalent of this function with a species
name, which was convenient. However, names are messy right.
So it sorta makes sense to sort out the species key numbers
you want exactly, and then get your occurrence data with
this function. UPDATE - GBIF folks say that they are
planning to allow using actual scientific names in this API
endpoint, so eventually it will happen.
}
\examples{
\dontrun{
# Search by species name, using \\code{\\link{name_backbone}} first to get key
key <- name_backbone(name='Helianthus annuus', kingdom='plants')$speciesKey
occ_search(taxonKey=key, limit=2)

# Return 20 results, this is the default by the way
occ_search(taxonKey=key, limit=20)

# Return just metadata for the search
occ_search(taxonKey=key, return='meta')

# Search by dataset key
occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a', return='data')

# Search by catalog number
occ_search(catalogNumber="49366")
occ_search(catalogNumber=c("49366","Bird.27847588"))

# Get all data, not just lat/long and name
occ_search(taxonKey=key, fields='all')

# Or get specific fields. Note that this isn't done on GBIF's side of things. This
# is done in R, but before you get the return object, so other fields are garbage
# collected
occ_search(taxonKey=key, fields=c('name','basisOfRecord','protocol'))

# Use paging parameters (limit and start) to page. Note the different results
# for the two queries below.
occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a',start=10,limit=5,
   return="data")
occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a',start=20,limit=5,
   return="data")

# Many dataset keys
occ_search(datasetKey=c("50c9509d-22c7-4a22-a47d-8c48425ef4a7",
   "7b5d6a48-f762-11e1-a439-00145eb45e9a"))

# Occurrence data: lat/long data, and associated metadata with occurrences
## If return='data' the output is a data.frame of all data together
## for easy manipulation
occ_search(taxonKey=key, return='data')

# Taxonomic hierarchy data
## If return='meta' the output is a list of the hierarch for each record
occ_search(taxonKey=key, return='hier')

# Search by collector name
occ_search(collectorName="smith")

# Many collector names
occ_search(collectorName=c("smith","BJ Stacey"))

# Pass in curl options for extra fun
library(httr)
occ_search(taxonKey=key, limit=20, return='hier', callopts=verbose())

# Search for many species
splist <- c('Cyanocitta stelleri', 'Junco hyemalis', 'Aix sponsa')
keys <- sapply(splist, function(x) name_backbone(name=x, kingdom='plants')$speciesKey,
   USE.NAMES=FALSE)
occ_search(taxonKey=keys, limit=5, return='data')

# Search on latitidue and longitude
occ_search(taxonKey=key, latitude=40, longitude=-120)

# Search on a bounding box (in well known text format)
occ_search(geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))')
key <- name_backbone(name='Aesculus hippocastanum', kingdom='plants')$speciesKey
occ_search(taxonKey=key, geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))')

# Search on country
occ_search(country='US')

# Get only occurrences with lat/long data (i.e. georeferenced)
occ_search(taxonKey=key, georeferenced=TRUE)

# Get only occurrences that were recorded as living specimens
occ_search(taxonKey=key, basisOfRecord="LIVING_SPECIMEN", georeferenced=TRUE)

# Get occurrences for a particular date
occ_search(taxonKey=key, date="2013")
occ_search(taxonKey=key, year="2013")
occ_search(taxonKey=key, month="6")

# Get occurrences based on depth
key <- name_backbone(name='Salmo salar', kingdom='animals')$speciesKey
occ_search(taxonKey=key, depth="5")

# Get occurrences based on altitude
key <- name_backbone(name='Puma concolor', kingdom='animals')$speciesKey
occ_search(taxonKey=key, altitude=2000, georeferenced=TRUE)

# Get occurrences based on institutionCode
occ_search(institutionCode="TLMF")
occ_search(institutionCode=c("TLMF","ArtDatabanken"))

# Get occurrences based on collectionCode
occ_search(collectionCode="Floristic Databases MV - Higher Plants")
occ_search(collectionCode=c("Floristic Databases MV - Higher Plants","Artport"))

# Get only those occurrences with spatial issues
occ_search(taxonKey=key, spatialIssues=TRUE)

# Search using a query string
occ_search(search="kingfisher")
}
\donttest{
# If you try multiple values for two different parameters you are wacked on the hand
occ_search(taxonKey=c(2482598,2492010), collectorName=c("smith","BJ Stacey"))

# Get a lot of data, here 1500 records for Helianthus annuus
out <- occ_search(taxonKey=key, limit=1500, return="data")
nrow(out)
}
}
\references{
\url{http://www.gbif.org/developer/summary}
}

