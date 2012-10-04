\name{taxoncount}
\alias{taxoncount}
\title{Search by taxon to retrieve number of records in GBIF.}
\usage{
  taxoncount(sciname = NULL, rank = NULL,
    dataresourcekey = NULL,
    url = "http://data.gbif.org/ws/rest/taxon/count?", ...,
    curl = getCurlHandle())
}
\arguments{
  \item{sciname}{scientitic name of taxon (character, see
  example)}

  \item{rank}{rank of taxon, see taxrank() (character)}

  \item{dataresourcekey}{Filter records to those provided
  by the supplied numeric key for a data resource. See
  resources(). (character)}

  \item{url}{the base GBIF API url for the function (should
  be left to default)}

  \item{...}{optional additional curl options (debugging
  tools mostly)}

  \item{curl}{If using in a loop, call getCurlHandle()
  first and pass the returned value in here (avoids
  unnecessary footprint)}
}
\description{
  Search by taxon to retrieve number of records in GBIF.
}
\examples{
\dontrun{
taxoncount('Puma concolor')
taxoncount('Helianthus annuus')
taxoncount(rank = 'family')
}
}

