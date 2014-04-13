\name{occ_metadata}
\alias{occ_metadata}
\title{Search for catalog numbers, collection codes, collector names, and institution
codes.}
\usage{
occ_metadata(type = "catalog_number", q = NULL, limit = 5,
  callopts = list(), pretty = TRUE)
}
\arguments{
  \item{type}{Type of data, one of catalog_number,
  collection_code, collector_name, institution_code. Unique
  partial strings work too, like 'cat' for catalog_number}

  \item{q}{Search term}

  \item{limit}{Number of results, default=5}

  \item{callopts}{Args passed on to \code{httr::GET}}

  \item{pretty}{Pretty as true (Default) uses cat to print
  data, FALSE gives character strings.}
}
\description{
Search for catalog numbers, collection codes, collector
names, and institution codes.
}
\examples{
\dontrun{
# catalog number
occ_metadata(type = "catalog_number", q=122)

# collection code
occ_metadata(type = "collection_code", q=12)

# collector name
occ_metadata(type = "collector_name", q='juan')

# institution code
occ_metadata(type = "institution_code", q='GB')

# data as character strings
occ_metadata(type = "catalog_number", q=122, pretty=FALSE)

# Change number of results returned
occ_metadata(type = "catalog_number", q=122, limit=10)

# Partial unique type strings work too
occ_metadata(type = "cat", q=122)
}
}
\references{
\url{http://www.gbif.org/developer/summary}
}

