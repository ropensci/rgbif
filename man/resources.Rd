\name{resources}
\alias{resources}
\title{Get data resources and their unique keys.}
\usage{
  resources(name = "", maxresults = NA,
    url = "http://data.gbif.org/ws/rest/resource/list",
    ..., curl = getCurlHandle())
}
\arguments{
  \item{name}{data provider name search string, by default
  searches all data resources by defining name = ""}

  \item{maxresults}{max number of results to return}
}
\description{
  Beware: It takes a while to retrieve the full list of
  providers - so go get more coffee.
}
\examples{
\dontrun{
# Test the function for a few resources
resources(maxresults=10)

# All data providers
resources()
}
}

