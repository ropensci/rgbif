\name{taxoncount}
\alias{taxoncount}
\title{Search by taxon to retrieve number of records in GBIF.}
\usage{
taxoncount(scientificname = NULL, rank = NULL, dataresourcekey = NULL)
}
\arguments{
  \item{scientificname}{Scientitic name of taxon
  (character, see example)}

  \item{rank}{Rank of taxon, see taxrank() (character)}

  \item{dataresourcekey}{Filter records to those provided
  by the supplied numeric key for a data resource. See
  resources(). (character)}
}
\description{
This function is deprecated.
}
\examples{
\dontrun{
taxoncount(scientificname = 'Puma concolor')
taxoncount(scientificname = 'Helianthus annuus')
}
\donttest{
taxoncount(rank = 'family')
}
}
\seealso{
occ_count
}

