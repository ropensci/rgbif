\name{networks}
\alias{networks}
\title{Get data networks and their unique keys.}
\usage{
  networks(name = "", maxresults = NA,
    url = "http://data.gbif.org/ws/rest/network/list", ...,
    curl = getCurlHandle())
}
\arguments{
  \item{name}{data network name search string, by default
  searches all data networks by defining name = ''}

  \item{maxresults}{max number of results to return}

  \item{url}{the base GBIF API url for the function (should
  be left to default)}

  \item{...}{optional additional curl options (debugging
  tools mostly)}

  \item{curl}{If using in a loop, call getCurlHandle()
  first and pass the returned value in here (avoids
  unnecessary footprint)}
}
\description{
  Beware: It takes a while to retrieve the full list of
  providers - so go get more coffee.
}
\examples{
\dontrun{
# Test the function for a few networks
networks(maxresults=10)
#'# All data providers
networks()
}
}

