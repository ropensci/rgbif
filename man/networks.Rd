\name{networks}
\alias{networks}
\title{Networks metadata.}
\usage{
  networks(data = "all", uuid = NULL, callopts = list())
}
\arguments{
  \item{data}{The type of data to get. Default is all
  data.}

  \item{uuid}{UUID of the data network provider. This must
  be specified if data is anything other than 'all'.}

  \item{callopts}{Further args passed on to GET.}
}
\description{
  Networks metadata.
}
\examples{
\dontrun{
networks()
networks(uuid='16ab5405-6c94-4189-ac71-16ca3b753df7')
networks(data='endpoint', uuid='16ab5405-6c94-4189-ac71-16ca3b753df7')
}
}

