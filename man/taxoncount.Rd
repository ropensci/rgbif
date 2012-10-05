\name{taxoncount}
\alias{taxoncount}
\title{Search by taxon to retrieve number of records in GBIF.}
\usage{
  taxoncount(scientificname = NULL, rank = NULL,
    dataresourcekey = NULL,
    url = "http://data.gbif.org/ws/rest/taxon/count")
}
\arguments{
  \item{scientificname}{Scientitic name of taxon
  (character, see example)}

  \item{rank}{Rank of taxon, see taxrank() (character)}

  \item{dataresourcekey}{Filter records to those provided
  by the supplied numeric key for a data resource. See
  resources(). (character)}

  \item{url}{The base GBIF API url for the function (should
  be left to default).}
}
\description{
  Search by taxon to retrieve number of records in GBIF.
}
\examples{
\dontrun{
taxoncount(scientificname = 'Puma concolor')
taxoncount(scientificname = 'Helianthus annuus')
taxoncount(rank = 'family')
}
}

