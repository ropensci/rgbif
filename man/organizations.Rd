\name{organizations}
\alias{organizations}
\title{Organizations metadata.}
\usage{
organizations(data = "all", uuid = NULL, query = NULL, limit = 20,
  start = NULL, callopts = list())
}
\arguments{
  \item{callopts}{Pass on options to httr::GET for more
  refined control of http calls, and error handling}

  \item{limit}{Number of records to return}

  \item{start}{Record number to start at}

  \item{data}{The type of data to get. Default is all
  data.}

  \item{uuid}{UUID of the data node provider. This must be
  specified if data is anything other than 'all'.}

  \item{query}{Query nodes. Only used when data='all'}
}
\value{
A list.
}
\description{
Organizations metadata.
}
\examples{
\dontrun{
organizations()
organizations(query="france")
organizations(uuid="4b4b2111-ee51-45f5-bf5e-f535f4a1c9dc")
organizations(data='contact', uuid="4b4b2111-ee51-45f5-bf5e-f535f4a1c9dc")
organizations(data='pending')
}
}
\references{
\url{http://www.gbif.org/developer/summary}
}

