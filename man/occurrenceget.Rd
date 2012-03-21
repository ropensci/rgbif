\name{occurrenceget}
\alias{occurrenceget}
\title{occurrenceget - description}
\usage{
  occurrenceget(key = NA, format = NA, mode = NA,
    url = "http://data.gbif.org/ws/rest/occurrence/get?",
    ..., curl = getCurlHandle())
}
\arguments{
  \item{key}{numeric key uniquely identifying the
  occurrence record within the GBIF}

  \item{format}{specifies the format in which the records
  are to be returned, one of: brief, darwin or kml
  (character)}

  \item{mode}{specifies whether the response data should
  (as far as possible) be the raw values originally
  retrieved from the data resource or processed
  (normalised) values used within the data portal
  (character)}

  \item{url}{the base GBIF API url for the function (should
  be left to default)}

  \item{...}{optional additional curl options (debugging
  tools mostly)}

  \item{curl}{If using in a loop, call getCurlHandle()
  first and pass the returned value in here (avoids
  unnecessary footprint)}
}
\description{
  occurrenceget - description
}
\examples{
\dontrun{
occurrenceget(key = 13749100)
}
}

