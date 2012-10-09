\name{taxonget}
\alias{taxonget}
\title{Get taxonomic information on a specific taxon or taxa in GBIF by their taxon
		concept keys.}
\usage{
  taxonget(key = NULL,
    url = "http://data.gbif.org/ws/rest/taxon/get")
}
\arguments{
  \item{key}{A single key, or many keys in a vector, for a
  taxon.}

  \item{url}{the base GBIF API url for the function (leave
  to default).}
}
\value{
  A single data.frame of taxonomic information if single
  data.frame is supplied, or a list of data.frame's if a
  list of keys is supplied.
}
\description{
  Get taxonomic information on a specific taxon or taxa in
  GBIF by their taxon concept keys.
}
\examples{
\dontrun{
keys <- taxonsearch(scientificname = 'Puma concolor')
taxonget(keys)

# Just for one key
taxonget(51780668) # taxonconceptkey for Puma concolor
}
}

