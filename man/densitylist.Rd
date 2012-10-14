\name{densitylist}
\alias{densitylist}
\title{The density web service provides access to records showing the density
		of occurrence records from the GBIF Network by one-degree cell.}
\usage{
  densitylist(taxonconceptKey = NULL,
    dataproviderkey = NULL, dataresourcekey = NULL,
    resourcenetworkkey = NULL, originisocountrycode = NULL,
    format = NULL,
    url = "http://data.gbif.org/ws/rest/density/list")
}
\arguments{
  \item{taxonconceptKey}{Unique key for taxon (numeric).
  Count only records which are for the taxon identified by
  the supplied numeric key, including any records provided
  under synonyms of the taxon concerned, and any records
  for child taxa (e.g. all genera and species within a
  family).  May be repeted in single request.}

  \item{dataproviderkey}{Filter records to those provided
  by the supplied numeric key for a data provider. See
  provider(). (character)}

  \item{dataresourcekey}{Filter records to those provided
  by the supplied numeric key for a data resource See
  resource(). (character)}

  \item{resourcenetworkkey}{count only records which have
  been made available by resources identified as belonging
  to the network identified by the supplied numeric key.}

  \item{originisocountrycode}{Return density records for
  occurrences which occurred within the country identified
  by the supplied 2-letter ISO code.}

  \item{format}{Specifies the format in which the records
  are to be returned, one of: brief or kml (character)}

  \item{url}{the base GBIF API url for the function (should
  be left to default)}
}
\value{
  A data.frame with results.
}
\description{
  The density web service provides access to records
  showing the density of occurrence records from the GBIF
  Network by one-degree cell.
}
\examples{
\dontrun{
head( densitylist(originisocountrycode = "CA") )
}
}

