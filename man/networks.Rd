\name{networks}
\alias{networks}
\title{Get data networks and their unique keys.}
\usage{
  networks(name = "", code = NA, modifiedsince = NA,
    startindex = NA, maxresults = NA,
    url = "http://data.gbif.org/ws/rest/network/list", ...,
    curl = getCurlHandle())
}
\arguments{
  \item{name}{data network name search string, by default
  searches all data networks by defining name = ''}

  \item{code}{return networks identified by the supplied
  short identifier code.}

  \item{modifiedsince}{return only records which have been
  indexed or modified on or after the supplied date (format
  YYYY-MM-DD, e.g. 2006-11-28)}

  \item{startindex}{return the subset of the matching
  records that starts at the supplied (zero-based index).}

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
  networks - so go get more coffee.
}
\examples{
\dontrun{
# Test the function for a few networks
networks(maxresults=10)
# All data providers
networks()
}
}

