\name{occ_search}
\alias{occ_search}
\title{Lookup names in all taxonomies.}
\usage{
  occ_search(taxonKey = NULL, georeferenced = NULL,
    boundingBox = NULL, collectorName = NULL,
    basisOfRecord = NULL, datasetKey = NULL, date = NULL,
    catalogNumber = NULL, callopts = list(), limit = 20,
    start = NULL, minimal = TRUE, return = "all")
}
\arguments{
  \item{taxonKey}{Scientific name}

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
  See details for information about the sources. Paging is
  supported
}
\examples{
\dontrun{
# Search by species name, using \\code{gbif_lookup} first to get key
key <- gbif_lookup(name='Helianthus annuus', kingdom='plants')$speciesKey
occ_search(taxonKey=key, limit=2)
occ_search(taxonKey=key, limit=20)
occ_search(taxonKey=key, return='meta')

# Search by dataset key
occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a', return='data')

# Search by catalog number
occ_search(catalogNumber="49366")

# Occurrence data: lat/long data, and associated metadata with occurrences
## If return='data' the output is a data.frame of all data together
## for easy manipulation
occ_search(taxonKey=key, return='data')

# Taxonomic hierarchy data
## If return='meta' the output is a list of the hierarch for each record
occ_search(taxonKey=key, limit=20, return='hier')

# Pass in curl options for extra fun
occ_search(taxonKey=key, limit=20, return='hier', callopts=verbose())
}
}
\references{
  \url{http://dev.gbif.org/wiki/display/POR/Webservice+API}
}

