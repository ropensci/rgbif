\name{dataset_search}
\alias{dataset_search}
\title{Search datasets.}
\usage{
  dataset_search(query = NULL, type = NULL, keyword = NULL,
    owningOrg = NULL, networkOrigin = NULL,
    hostingOrg = NULL, decade = NULL, country = NULL,
    limit = 20, start = NULL, callopts = list(),
    pretty = FALSE, description = FALSE)
}
\arguments{
  \item{taxonKey}{Scientific name}

  \item{boundingBox}{Location}

  \item{collectorName}{Collector}

  \item{basisOfRecord}{Basis of record}

  \item{datasetKey}{Dataset}

  \item{date}{Collection date}

  \item{catalogNumber}{Catalog number}

  \item{callopts}{Pass on options to GET}

  \item{limit}{Number of records to return}

  \item{start}{Record number to start at}

  \item{minimal}{Return just taxon name, latitude, and
  longitute if TRUE, otherwise all data. Default is TRUE.}

  \item{return}{One of data, hier, meta, or all. If data, a
  data.frame with the data. hier returns the
  classifications in a list for each record. meta returns
  the metadata for the entire call. all gives all data back
  in a list.}

  \item{type}{}

  \item{keyword}{}

  \item{owningOrg}{}

  \item{networkOrigin}{}

  \item{hostingOrg}{}

  \item{decade}{}

  \item{country}{}
}
\value{
  A data.frame or list
}
\description{
  This function does not search occurrence data, only the
  datasets that may contain occurrence data
}
\examples{
\dontrun{
# Gets all datasets of type "OCCURRENCE".
dataset_search(type="OCCURRENCE")

# Gets all datasets tagged with keyword "france".
dataset_search(keyword="france")

# Gets all datasets owned by the organization with key
# "07f617d0-c688-11d8-bf62-b8a03c50a862" (UK NBN).
dataset_search(owningOrg="07f617d0-c688-11d8-bf62-b8a03c50a862")

# Fulltext search for all datasets having the word "amsterdam" somewhere in
# its metadata (title, description, etc).
dataset_search(query="amsterdam")

# Limited search
dataset_search(type="OCCURRENCE", limit=2)
dataset_search(type="OCCURRENCE", limit=2, start=10)

# Return just descriptions
dataset_search(type="OCCURRENCE", description=TRUE)

# Return metadata in a more human readable way (hard to manipulate though)
dataset_search(type="OCCURRENCE", pretty=TRUE)
}
}

