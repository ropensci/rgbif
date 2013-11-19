\name{datasets}
\alias{datasets}
\title{Search for datasets and dataset metadata.}
\usage{
  datasets(data = "all", type = NULL, uuid = NULL,
    query = NULL, id = NULL, callopts = list())
}
\arguments{
  \item{data}{The type of data to get. Default is all
  data.}

  \item{type}{Type of dataset, options include OCCURRENCE,
  etc.}

  \item{uuid}{UUID of the data node provider. This must be
  specified if data is anything other than 'all'.}

  \item{query}{Query term(s). Only used when data='all'}

  \item{id}{A metadata document id.}

  \item{callopts}{Further args passed on to GET.}
}
\value{
  A list.
}
\description{
  Search for datasets and dataset metadata.
}
\examples{
\dontrun{
datasets()
datasets(type="OCCURRENCE")
datasets(uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
datasets(data='contact', uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
datasets(data='metadata', uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
datasets(data='metadata', uuid="a6998220-7e3a-485d-9cd6-73076bd85657", id=598)
datasets(data=c('deleted','duplicate'))
}
}
\references{
  \url{http://www.gbif.org/developer/summary}
}

