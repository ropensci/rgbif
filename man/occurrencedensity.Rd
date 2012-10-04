\name{occurrencedensity}
\alias{occurrencedensity}
\title{Returns summary counts of occurrence records by one-degree cell for a single
		taxon, country, dataset, data publisher or data network.}
\usage{
  occurrencedensity(taxonconceptkey = NA,
    dataproviderkey = NA, dataresourcekey = NA,
    resourcenetworkkey = NA, originisocountrycode = NA,
    format = NA,
    url = "http://data.gbif.org/ws/rest/density/list", ...,
    curl = getCurlHandle())
}
\arguments{
  \item{taxonconceptkey}{numeric key uniquely identifying
  the taxon}

  \item{dataproviderkey}{numeric key uniquely identifying
  the data provider}

  \item{dataresourcekey}{numeric key uniquely identifying
  the data resource}

  \item{resourcenetworkkey}{numeric key uniquely
  identifying the data network}

  \item{originisocountrycode}{numeric key uniquely
  identifying the country}

  \item{format}{specifies the format in which the records
  are to be returned, one of: brief, darwin or kml
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
  Returns summary counts of occurrence records by
  one-degree cell for a single taxon, country, dataset,
  data publisher or data network.
}
\examples{
\dontrun{
occurrencedensity(originisocountrycode='CA')
occurrencedensity(taxonconceptkey=45)
}
}

