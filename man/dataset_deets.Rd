\name{dataset_deets}
\alias{dataset_deets}
\title{Geta details on a dataset.}
\usage{
  dataset_deets(uuid, return = "all", callopts = list())
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
dataset_deets(uuid='28573c0a-b833-41b1-9999-56c6b9bce519')
dataset_deets(uuid=c('28573c0a-b833-41b1-9999-56c6b9bce519',
   '3f8a1297-3259-4700-91fc-acc4170b27ce'), 'endpoints')
dataset_deets(uuid=c('28573c0a-b833-41b1-9999-56c6b9bce519',
   '3f8a1297-3259-4700-91fc-acc4170b27ce'), 'contacts')
}
}

