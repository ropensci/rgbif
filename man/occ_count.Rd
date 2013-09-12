\name{occ_count}
\alias{occ_count}
\title{Get number of occurrence records.}
\usage{
  occ_count(nubKey = NULL, georeferenced = NULL,
    basisOfRecord = NULL, datasetKey = NULL, date = NULL,
    catalogNumber = NULL, country = NULL,
    hostCountry = NULL, year = NULL, callopts = list())
}
\arguments{
  \item{nubKey}{Species key}

  \item{georeferenced}{Return only occurence records with
  lat/long data (TRUE) or all records (FALSE, default).}

  \item{basisOfRecord}{Basis of record}

  \item{datasetKey}{Dataset key}

  \item{date}{Collection date}

  \item{year}{Year data were collected in}

  \item{catalogNumber}{Catalog number}

  \item{country}{Country data was collected in}

  \item{hostCountry}{Country that hosted the data}

  \item{callopts}{Pass on options to httr::GET for more
  refined control of http calls, and error handling}
}
\value{
  A single numeric value
}
\description{
  Get number of occurrence records.
}
\examples{
\dontrun{
occ_count(basisOfRecord='OBSERVATION')
occ_count(georeferenced=TRUE)
occ_count(country='DENMARK')
occ_count(hostCountry='FRANCE')
occ_count(datasetKey='9e7ea106-0bf8-4087-bb61-dfe4f29e0f17')
occ_count(year=2012)
occ_count(nubKey=2435099)
occ_count(nubKey=2435099, georeferenced=TRUE)
occ_count(datasetKey='8626bd3a-f762-11e1-a439-00145eb45e9a', basisOfRecord='PRESERVED_SPECIMEN')
occ_count(datasetKey='8626bd3a-f762-11e1-a439-00145eb45e9a', nubKey=2435099, basisOfRecord='PRESERVED_SPECIMEN')
}
}
\references{
  \url{http://dev.gbif.org/wiki/display/POR/Webservice+API}
}

