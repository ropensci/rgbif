\name{installations}
\alias{installations}
\title{Installations metadata.}
\usage{
installations(data = "all", uuid = NULL, query = NULL,
  identifier = NULL, identifierType = NULL, limit = 20, start = NULL,
  callopts = list())
}
\arguments{
  \item{callopts}{Pass on options to httr::GET for more
  refined control of http calls, and error handling}

  \item{limit}{Number of records to return}

  \item{start}{Record number to start at}

  \item{data}{The type of data to get. Default is all data.
  If not 'all', then one or more of 'contact', 'endpoint',
  'dataset', 'comment', 'deleted', 'nonPublishing'.}

  \item{uuid}{UUID of the data node provider. This must be
  specified if data is anything other than 'all'.}

  \item{query}{Query nodes. Only used when data='all'.
  Ignored otherwise.}

  \item{identifier}{The value for this parameter can be a
  simple string or integer, e.g. identifier=120. This
  parameter doesn't seem to be useful right now.}

  \item{identifierType}{Used in combination with the
  identifier parameter to filter identifiers by identifier
  type. See details. This parameter doesn't seem to be
  useful right now.}
}
\value{
A list.
}
\description{
Installations metadata.
}
\details{
identifierType options:

\itemize{ \item {DOI} \item {FTP} \item {GBIF_NODE} \item
{GBIF_PARTICIPANT} \item {GBIF_PORTAL} \item {HANDLER}
\item {LSID} \item {SOURCE_ID} \item {UNKNOWN} \item {URI}
\item {URL} \item {UUID} }
}
\examples{
\dontrun{
installations()
installations(query="france")
installations(uuid="b77901f9-d9b0-47fa-94e0-dd96450aa2b4")
installations(data='contact', uuid="b77901f9-d9b0-47fa-94e0-dd96450aa2b4")
installations(data='contact', uuid="2e029a0c-87af-42e6-87d7-f38a50b78201")
installations(data='endpoint', uuid="b77901f9-d9b0-47fa-94e0-dd96450aa2b4")
installations(data='dataset', uuid="b77901f9-d9b0-47fa-94e0-dd96450aa2b4")
installations(data='comment', uuid="b77901f9-d9b0-47fa-94e0-dd96450aa2b4")
installations(data='deleted')
installations(data='deleted', limit=2)
installations(data=c('deleted','nonPublishing'), limit=2)
installations(identifierType='DOI', limit=2)
}
}
\references{
\url{http://www.gbif.org/developer/summary}
}

