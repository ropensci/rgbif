\name{occurrencelist}
\alias{occurrencelist}
\title{occurrencelist description}
\usage{
  occurrencelist(sciname = NA, taxonconceptKey = NA,
    dataproviderkey = NA, dataresourcekey = NA,
    resourcenetworkkey = NA, basisofrecordcode = NA,
    minlatitude = NA, maxlatitude = NA, minlongitude = NA,
    maxlongitude = NA, minaltitude = NA, maxaltitude = NA,
    mindepth = NA, maxdepth = NA, cellid = NA,
    centicellid = NA, typesonly = NA,
    georeferencedonly = NA, coordinatestatus = NA,
    coordinateissues = NA, hostisocountrycode = NA,
    originisocountrycode = NA, originregioncode = NA,
    startdate = NA, enddate = NA, startyear = NA,
    endyear = NA, year = NA, month = NA, day = NA,
    modifiedsince = NA, startindex = NA, maxresults = 10,
    format = NA, icon = NA, mode = NA, stylesheet = NA,
    latlongdf = FALSE,
    url = "http://data.gbif.org/ws/rest/occurrence/list?",
    ..., curl = getCurlHandle())
}
\arguments{
  \item{sciname}{scientitic name of taxon (character, see
  example)}

  \item{taxonconceptKey}{unique key for taxon (numeric)}

  \item{dataproviderkey}{Filter records to those provided
  by the supplied numeric key for a data provider. See
  provider(). (character)}

  \item{dataresourcekey}{Filter records to those provided
  by the supplied numeric key for a data resource See
  resource(). (character)}

  \item{resourcenetworkkey}{<what param does>}

  \item{basisofrecordcode}{<what param does>}

  \item{minlatitude}{<what param does>}

  \item{maxlatitude}{<what param does>}

  \item{minlongitude}{<what param does>}

  \item{maxlongitude}{<what param does>}

  \item{minaltitude}{<what param does>}

  \item{maxaltitude}{<what param does>}

  \item{mindepth}{<what param does>}

  \item{maxdepth}{<what param does>}

  \item{cellid}{<what param does>}

  \item{centicellid}{<what param does>}

  \item{typesonly}{<what param does>}

  \item{georeferencedonly}{<what param does>}

  \item{coordinatestatus}{<what param does>}

  \item{coordinateissues}{<what param does>}

  \item{hostisocountrycode}{<what param does>}

  \item{originisocountrycode}{<what param does>}

  \item{originregioncode}{<what param does>}

  \item{startdate}{<what param does>}

  \item{enddate}{<what param does>}

  \item{startyear}{<what param does>}

  \item{endyear}{<what param does>}

  \item{year}{<what param does>}

  \item{month}{<what param does>}

  \item{day}{<what param does>}

  \item{modifiedsince}{<what param does>}

  \item{startindex}{<what param does>}

  \item{maxresults}{max number of results}

  \item{format}{specifies the format in which the records
  are to be returned,}

  \item{icon}{<what param does>}

  \item{mode}{specifies whether the response data should
  (as far as possible) be the raw values originally
  retrieved from the data resource or processed
  (normalised) values used within the data portal
  (character)latlongdf: return a data.frame of lat/long's
  for all occurrences (logical)}

  \item{stylesheet}{sets the URL of the stylesheet to be
  associated with the}

  \item{latlongdf}{<what param does>}

  \item{url}{the base GBIF API url for the function (should
  be left to default)}

  \item{...}{optional additional curl options (debugging
  tools mostly)}

  \item{curl}{If using in a loop, call getCurlHandle()
  first and pass the returned value in here (avoids
  unnecessary footprint)}
}
\description{
  occurrencelist description
}
\examples{
\dontrun{
occurrencelist(sciname = "Accipiter erythronemius", coordinatestatus = TRUE, maxresults = 100)
}
}

