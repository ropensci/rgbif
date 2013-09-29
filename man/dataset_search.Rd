\name{dataset_search}
\alias{dataset_search}
\title{Search datasets in GBIF.}
\usage{
  dataset_search(query = NULL, type = NULL, keyword = NULL,
    owningOrg = NULL, networkOrigin = NULL,
    hostingOrg = NULL, decade = NULL, country = NULL,
    limit = 20, start = NULL, callopts = list(),
    pretty = FALSE, description = FALSE)
}
\arguments{
  \item{callopts}{Pass on options to httr::GET for more
  refined control of http calls, and error handling}

  \item{limit}{Number of records to return}

  \item{start}{Record number to start at}

  \item{query}{Query term(s) for full text search.}

  \item{type}{Type of dataset, options include OCCURRENCE,
  etc.}

  \item{keyword}{Keyword to search by. Datasets can be
  tagged by keywords, which you can search on.}

  \item{owningOrg}{Hosting organization. A uuid string. See
  \code{\link{organizations}}}

  \item{networkOrigin}{Hosting organization. A uuid string.
  See \code{\link{organizations}}}

  \item{hostingOrg}{Hosting organization. A uuid string.
  See \code{\link{organizations}}}

  \item{decade}{Decade, e.g., 1980}

  \item{country}{Limit search to a country using isocodes.
  See example.}

  \item{pretty}{Print informative metadata using
  \code{\link{cat}}. Not easy to manipulate output though.}

  \item{description}{Return descriptions only (TRUE) or all
  data (FALSE, default)}
}
\value{
  A data.frame, list, or message printed to console (using
  pretty=TRUE).
}
\description{
  This function does not search occurrence data, only
  metadata on the datasets that contain occurrence data.
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

# Search by country code. Lookup isocodes first, and use US for United States
isocodes[agrep("united", isocodes$name),]
dataset_search(country="US")

# Search by decade
dataset_search(decade=1980)
}
}
\references{
  \url{http://dev.gbif.org/wiki/display/POR/Webservice+API}
}

