\name{taxonget}
\alias{taxonget}
\title{Get taxonomic information on a specific taxon or taxa in GBIF by their taxon
		concept keys.}
\usage{
  taxonget(key = NULL,
    url = "http://data.gbif.org/ws/rest/taxon/get")
}
\arguments{
  \item{key}{Key for a taxon.}
}
\value{
  Data.frame of taxonomic information.
}
\description{
  Get taxonomic information on a specific taxon or taxa in
  GBIF by their taxon concept keys.
}
\examples{
\dontrun{
keys <- taxonsearch(scientificname = 'Puma concolor')
taxonget(key = keys[[1]])
}
}

