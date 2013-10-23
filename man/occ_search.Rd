\name{occ_search}
\alias{occ_search}
\title{Search for GBIF occurrences.}
\usage{
  occ_search(taxonKey = NULL, country = NULL,
    georeferenced = NULL, boundingBox = NULL,
    collectorName = NULL, basisOfRecord = NULL,
    datasetKey = NULL, date = NULL, catalogNumber = NULL,
    callopts = list(), limit = 20, start = NULL,
    minimal = TRUE, return = "all", ...)
}
\arguments{
  \item{taxonKey}{Taxonomic key. This is the GBIF backbone
  taxonomic key for a single taxon. You can pass many keys
  by passing occ_search in a call to an lapply-family
  function (see last example below).}

  \item{country}{Country, a two letter ISO country code.
  See here
  \url{http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2}}

  \item{boundingBox}{Location}

  \item{collectorName}{Collector}

  \item{basisOfRecord}{Basis of record}

  \item{datasetKey}{Dataset}

  \item{date}{Collection date}

  \item{catalogNumber}{Catalog number}

  \item{minimal}{Return just taxon name, latitude, and
  longitute if TRUE, otherwise all data. Default is TRUE.}

  \item{return}{One of data, hier, meta, or all. If data, a
  data.frame with the data. hier returns the
  classifications in a list for each record. meta returns
  the metadata for the entire call. all gives all data back
  in a list.}

  \item{callopts}{Pass on options to httr::GET for more
  refined control of http calls, and error handling}

  \item{limit}{Number of records to return}

  \item{start}{Record number to start at}

  \item{georeferenced}{Return only occurence records with
  lat/long data (TRUE) or all records (FALSE, default).}
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
  object. There is no option no to return them from the
  API. However, within the \code{occ_search} function you
  can select whether to return just hierarchies, just data,
  all of data and hiearchies and metadata, or just
  metadata. If all hierarchies are the same we just return
  one for you.

  Data: By default only three data fields are returned:
  name (the species name), latitude, and longitude. Set
  parameter minimal=FALSE if you want more data.

  Nerds: You can pass parameters not defined in this
  function into the call to the GBIF API to control things
  about the call itself using the \code{callopts} function.
  See an example below that passes in the \code{verbose}
  function to get details on the http call.

  Why can't I search by species name? In the previous GBIF
  API and the version of rgbif that wrapped that API, you
  could search the equivalent of this function with a
  species name, which was convenient. However, names are
  messy right. So it sorta makes sense to sort out the
  species key numbers you want exactly, and then get your
  occurrence data with this function. UPDATE - GBIF folks
  say that they are planning to allow using actual
  scientific names in this API endpoint, so eventually it
  will happen.
}
\examples{
\dontrun{
# Search by species name, using \\code{gbif_lookup} first to get key
key <- gbif_lookup(name='Helianthus annuus', kingdom='plants')$speciesKey
occ_search(taxonKey=key, limit=2)

# Return 20 results, this is the default by the way
occ_search(taxonKey=key, limit=20)

# Return just metadata for the search
occ_search(taxonKey=key, return='meta')

# Search by dataset key
occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a', return='data')

# Search by catalog number
occ_search(catalogNumber="49366")

# Get all data, not just lat/long and name
occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a', minimal=FALSE)

# Use paging parameters (limit and start) to page. Note the different results
# for the two queries below.
occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a',start=10,limit=5,return="data")
occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a',start=20,limit=5,return="data")

# Many dataset keys
occ_search(datasetKey=c("50c9509d-22c7-4a22-a47d-8c48425ef4a7","7b5d6a48-f762-11e1-a439-00145eb45e9a"))

# Occurrence data: lat/long data, and associated metadata with occurrences
## If return='data' the output is a data.frame of all data together
## for easy manipulation
occ_search(taxonKey=key, return='data')

# Taxonomic hierarchy data
## If return='meta' the output is a list of the hierarch for each record
occ_search(taxonKey=key, limit=20, return='hier')

# Search by collector name
occ_search(collectorName="smith")

# Many collector names
occ_search(collectorName=c("smith","BJ Stacey"))

# Pass in curl options for extra fun
occ_search(taxonKey=key, limit=20, return='hier', callopts=verbose())

# Search for many species
splist <- c('Cyanocitta stelleri', 'Junco hyemalis', 'Aix sponsa')
keys <- sapply(splist, function(x) gbif_lookup(name=x, kingdom='plants')$speciesKey, USE.NAMES=FALSE)
occ_search(taxonKey=keys, limit=5, return='data')
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
  \url{http://dev.gbif.org/wiki/display/POR/Webservice+API}
}

