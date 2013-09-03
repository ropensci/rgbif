\name{dataset_search}
\alias{dataset_search}
\title{Search datasets.}
\usage{
  dataset_search(query = NULL, type = NULL, keyword = NULL,
    owningOrg = NULL, networkOrigin = NULL,
    hostingOrg = NULL, decade = NULL, country = NULL,
    callopts = list())
}
\arguments{
  \item{query}{}

  \item{type}{}

  \item{keyword}{}

  \item{owningOrg}{}

  \item{networkOrigin}{}

  \item{hostingOrg}{}

  \item{decade}{}

  \item{country}{}

  \item{callopts}{Further args passed on to GET.}
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
}
}

