\name{installations}
\alias{installations}
\title{Installations metadata.}
\usage{
installations(data = "all", uuid = NULL, query = NULL,
  identifier = NULL, identifierType = NULL, callopts = list())
}
\arguments{
  \item{data}{The type of data to get. Default is all
  data.}

  \item{uuid}{UUID of the data node provider. This must be
  specified if data is anything other than 'all'.}

  \item{query}{Query nodes. Only used when data='all'}

  \item{identifier}{The value for this parameter can be a
  simple string or integer, e.g. identifier=120. This
  parameter doesn't seem to be useful right now.}

  \item{identifierType}{Used in combination with the
  identifier parameter to filter identifiers by identifier
  type. See details. This parameter doesn't seem to be
  useful right now.}

  \item{callopts}{Further args passed on to GET.}
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
installations(uuid="4b4b2111-ee51-45f5-bf5e-f535f4a1c9dc")
installations(data='contact', uuid="4b4b2111-ee51-45f5-bf5e-f535f4a1c9dc")
installations(data='pending')
}
}
\references{
\url{http://www.gbif.org/developer/summary}
}

