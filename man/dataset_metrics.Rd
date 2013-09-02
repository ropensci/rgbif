\name{dataset_metrics}
\alias{dataset_metrics}
\title{Geta details on a dataset.}
\usage{
  dataset_metrics(uuid, return = "all", callopts = list())
}
\arguments{
  \item{uuid}{A dataset UUID.}

  \item{return}{One of data, hier, meta, or all. If data, a
  data.frame with the data. hier returns the
  classifications in a list for each record. meta returns
  the metadata for the entire call. all gives all data back
  in a list.}

  \item{callopts}{Pass on options to GET}
}
\description{
  Geta details on a dataset.
}
\examples{
\dontrun{
dataset_metrics(uuid='3c0a-b833-41b1-9999-56c6b9bce')
dataset_metrics(uuid=c('3c0a-b833-41b1-9999-56c6b9bce',
   '3f8a1297-3259-4700-91fc-acc4170b27ce'), 'endpoints')
dataset_metrics(uuid=c('3c0a-b833-41b1-9999-56c6b9bce',
   '3f8a1297-3259-4700-91fc-acc4170b27ce'), 'contacts')
}
}

