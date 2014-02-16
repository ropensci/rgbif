\name{elevation}
\alias{elevation}
\title{Get elevation for lat/long points from a data.frame or list of points.}
\usage{
elevation(input = NULL, latitude = NULL, longitude = NULL,
  latlong = NULL, callopts = list())
}
\arguments{
  \item{input}{A data.frame of lat/long data.}

  \item{latitude}{A vector of latitude's. Must be the same
  length as the longitude vector.}

  \item{longitude}{A vector of longitude's. Must be the
  same length as the latitude vector.}

  \item{latlong}{A vector of lat/long pairs. See examples.}

  \item{callopts}{Options passed on to httr::GET, like curl
  options for debugging.}
}
\value{
A new column in the supplied data.frame or a vector with
elevation of each location in meters.
}
\description{
Get elevation for lat/long points from a data.frame or list
of points.
}
\examples{
\dontrun{
key <- name_backbone(name='Puma concolor', kingdom='plants')$speciesKey
dat <- occ_search(taxonKey=key, return='data', limit=300, georeferenced=TRUE)
elevation(dat)

# Pass in a vector of lat's and a vector of long's
elevation(latitude=dat$latitude, longitude=dat$longitude)

# Pass in lat/long pairs in a single vector
pairs <- list(c(31.8496,-110.576060), c(29.15503,-103.59828))
elevation(latlong=pairs)
}
}
\references{
Uses the Google Elevation API at the following link
\url{https://developers.google.com/maps/documentation/elevation/}
}

