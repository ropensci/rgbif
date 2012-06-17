\name{providers}
\alias{providers}
\title{Get data providers and their unique keys.}
\usage{
  providers(name = "", maxresults = NA,
    url = "http://data.gbif.org/ws/rest/provider/list",
    ..., curl = getCurlHandle())
}
\arguments{
  \item{name}{data provider name search string, by default
  searches all data providers by defining name = ''}

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
  providers - so go get more coffee. #'
}
\examples{
\dontrun{
# Test the function for a few providers
providers(maxresults=10)
#'# All data providers
providers()
}
}

