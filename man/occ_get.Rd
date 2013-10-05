\name{occ_get}
\alias{occ_get}
\title{Get data for a GBIF occurrence.}
\usage{
  occ_get(key = NULL, return = "all", verbatim = FALSE,
    minimal = TRUE, callopts = list())
}
\arguments{
  \item{key}{Occurrence key}

  \item{return}{One of data, hier, meta, or all. If data, a
  data.frame with the data. hier returns the
  classifications in a list for each record. meta returns
  the metadata for the entire call. all gives all data back
  in a list.}

  \item{verbatim}{Return verbatim object (TRUE) or cleaned
  up object (FALSE, default).}

  \item{minimal}{Return just taxon name, latitude, and
  longitute if TRUE, otherwise all data. Default is TRUE.}

  \item{callopts}{Further arguments passed on to the
  \code{\link{GET}} request.}
}
\value{
  A data.frame or list.
}
\description{
  Get data for a GBIF occurrence.
}
\examples{
\dontrun{
occ_get(key=773433533, return='data')
occ_get(key=773433533, 'hier')
occ_get(key=773433533, 'all')

# many occurrences
occ_get(key=c(773433533,101010,240713150,855998194,49819470), return='data')

# Verbatim data
occ_get(key=c(773433533,767047552,756083505,754201727), verbatim=TRUE)
}
}
\references{
  \url{http://dev.gbif.org/wiki/display/POR/Webservice+API}
}

