\name{occ_search}
\alias{occ_search}
\title{Lookup names in all taxonomies.}
\usage{
  occ_search(taxonKey = NULL, boundingBox = NULL,
    collectorName = NULL, basisOfRecord = NULL,
    datasetKey = NULL, date = NULL, catalogNumber = NULL,
    callopts = list(), limit = 20, start = NULL,
    minimal = TRUE, return = "all")
}
\arguments{
  \item{taxonKey}{Scientific name}

  \item{boundingBox}{Location}

  \item{collectorName}{Collector}

  \item{basisOfRecord}{Basis of record}

  \item{datasetKey}{Dataset}

  \item{date}{Collection date}

  \item{catalogNumber}{Catalog number}

  \item{callopts}{Pass on options to GET}

  \item{limit}{Number of records to return}

  \item{start}{Record number to start at}

  \item{minimal}{Return just taxon name, latitude, and
  longitute if TRUE, otherwise all data. Default is TRUE.}

  \item{return}{One of data, hier, meta, or all. If data, a
  data.frame with the data. hier returns the
  classifications in a list for each record. meta returns
  the metadata for the entire call. all gives all data back
  in a list.}
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
occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a', return='coord')

key <- gbif_lookup(name='Helianthus annuus', kingdom='plants')$speciesKey
occ_search(taxonKey=key, limit=2)
occ_search(taxonKey=key, limit=20)
occ_search(taxonKey=key, limit=20, return='meta')
occ_search(taxonKey=key, limit=20, return='hier')

occ_search(catalogNumber='PlantAndMushroom.6845144', minimal=FALSE)
}
}

