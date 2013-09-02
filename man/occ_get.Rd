\name{occ_get}
\alias{occ_get}
\title{Get data for a GBIF occurrence.}
\usage{
  occ_get(key = NULL, return = "all", minimal = TRUE,
    callopts = list())
}
\arguments{
  \item{key}{Occurrence key}

  \item{return}{One of data, hier, meta, or all. If data, a
  data.frame with the data. hier returns the
  classifications in a list for each record. meta returns
  the metadata for the entire call. all gives all data back
  in a list.}

  \item{minimal}{Return just taxon name, latitude, and
  longitute if TRUE, otherwise all data. Default is TRUE.}

  \item{callopts}{Pass on options to GET}
}
\description{
  Get data for a GBIF occurrence.
}
\examples{
\dontrun{
occ_get(key=773433533, 'data')
occ_get(key=773433533, 'hier')
occ_get(key=773433533, 'all')

# many occurrences
occ_get(key=c(773433533,767047552,756083505,754201727,686550585), 'data')
}
}

