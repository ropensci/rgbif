\name{datasets}
\alias{datasets}
\title{Dataset metadata.}
\usage{
  datasets(data = "all", uuid = NULL, query = NULL,
    id = NULL, callopts = list())
}
\arguments{
  \item{data}{The type of data to get. Default is all
  data.}

  \item{uuid}{UUID of the data node provider. This must be
  specified if data is anything other than 'all'.}

  \item{query}{Query nodes. Only used when data='all'}

  \item{isocode}{A 2 letter country code. Only used if
  data='country'.}

  \item{callopts}{Further args passed on to GET.}
}
\description{
  Dataset metadata.
}
\examples{
\dontrun{
datasets()
datasets(uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
datasets(data='contact', uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
datasets(data='metadata', uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
datasets(data='metadata', uuid="a6998220-7e3a-485d-9cd6-73076bd85657", id=598)
datasets(data=c('deleted','duplicate'))
}
}

