\name{networks}
\alias{networks}
\title{Networks metadata.}
\usage{
  networks(data = "all", uuid = NULL, callopts = list(),
    name = NULL, code = NULL, modifiedsince = NULL,
    startindex = NULL, maxresults = NULL)
}
\arguments{
  \item{data}{The type of data to get. Default is all
  data.}

  \item{uuid}{UUID of the data network provider. This must
  be specified if data is anything other than 'all'.}

  \item{callopts}{Further args passed on to GET.}

  \item{name}{THIS IS A DEPRECATED ARGUMENT. data network
  name search string, by default searches all data networks
  by defining name = ''}

  \item{code}{THIS IS A DEPRECATED ARGUMENT. return
  networks identified by the supplied short identifier
  code.}

  \item{modifiedsince}{THIS IS A DEPRECATED ARGUMENT.
  return only records which have been indexed or modified
  on or after the supplied date (format YYYY-MM-DD, e.g.
  2006-11-28)}

  \item{startindex}{THIS IS A DEPRECATED ARGUMENT. return
  the subset of the matching records that starts at the
  supplied (zero-based index).}

  \item{maxresults}{THIS IS A DEPRECATED ARGUMENT. max
  number of results to return}
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
\references{
  \url{http://www.gbif.org/developer/summary}
}

