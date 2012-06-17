\name{taxonsearch}
\alias{taxonsearch}
\title{Search for taxa in GBIF}
\usage{
  taxonsearch(sciname = NA, rank = NA, maxresults = 10,
    url = "http://data.gbif.org/ws/rest/taxon/list?", ...,
    curl = getCurlHandle())
}
\arguments{
  \item{sciname}{scientitic name of taxon (character, see
  example)}

  \item{rank}{rank of taxon, see taxrank() (character)}

  \item{maxresults}{return at most the specified number of
  records. The default (and maximum supported) is 1000
  records.}

  \item{url}{the base GBIF API url for the function (should
  be left to default)}

  \item{...}{optional additional curl options (debugging
  tools mostly)}

  \item{curl}{If using in a loop, call getCurlHandle()
  first and pass the returned value in here (avoids
  unnecessary footprint)}
}
\description{
  Search for a taxon using scientific name. Optionally,
  include taxonomic rank in the search.
}
\examples{
\dontrun{
taxonsearch(sciname = 'Puma concolor')
}
}

