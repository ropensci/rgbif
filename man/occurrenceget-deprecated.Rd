\name{occurrenceget}
\alias{occurrenceget}
\title{Get individual records for a given occurrence record.}
\usage{
  occurrenceget(key = NULL, format = NULL, mode = NULL)
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
}
\description{
  Get individual records for a given occurrence record.
}
\details{
  Currently, the function returns the record as a list,
  hopefully in future will return a data.frame.
}
\examples{
\dontrun{
occurrenceget(key = 13749100)
}
}
\seealso{
  occ_get
}

