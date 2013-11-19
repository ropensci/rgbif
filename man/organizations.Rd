\name{organizations}
\alias{organizations}
\title{Organizations metadata.}
\usage{
  organizations(data = "all", uuid = NULL, query = NULL,
    callopts = list())
}
\arguments{
  \item{data}{The type of data to get. Default is all
  data.}

  \item{uuid}{UUID of the data node provider. This must be
  specified if data is anything other than 'all'.}

  \item{query}{Query nodes. Only used when data='all'}

  \item{callopts}{Further args passed on to GET.}
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

