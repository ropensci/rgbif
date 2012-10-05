\name{gbifmap}
\alias{gbifmap}
\title{Make a simple map to visualize GBIF data.}
\usage{
  gbifmap(input = NULL)
}
\arguments{
  \item{input}{A data.frame, e.g. from calling
  occurrencelist for example. The data.frame has to have,
  in addition to any other columns, columns named exactly
  "decimalLatitude" and "decimalLongitude".}
}
\value{
  Map (using ggplot2 package) of points on a world map.
}
\description{
  Basic function to plot your lat/long data on a map.
}
\details{
  gbifmap takes care of cleaning up the data.frame
  (removing NA's, etc.)  returned from rgbif functions, and
  creating the map. This function gives a simple map of
  your data.  You can look at the code behing the function
  itself if you want to build on it to make a map according
  to your specfications.
}
\examples{
\dontrun{
# example 1
##  get some data on golden
out <- occurrencelist(scientificname = 'Accipiter erythronemius',
		coordinatestatus = TRUE, maxresults = 100, latlongdf = T)
gbifmap(input = out) # make a map using vertmap

# example 2
##  A species with more data
out <- occurrencelist(scientificname = 'Puma concolor',
		coordinatestatus = TRUE, maxresults = 100, latlongdf = T)
gbifmap(input = out) # make a map using vertmap
}
}

