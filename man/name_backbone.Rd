\name{name_backbone}
\alias{name_backbone}
\title{Lookup names in the GBIF backbone taxonomy.}
\usage{
  name_backbone(name, rank = NULL, kingdom = NULL,
    phylum = NULL, class = NULL, order = NULL,
    family = NULL, genus = NULL, strict = FALSE,
    verbose = FALSE, start = NULL, limit = 20,
    callopts = list())
}
\arguments{
  \item{callopts}{Pass on options to httr::GET for more
  refined control of http calls, and error handling}

  \item{limit}{Number of records to return}

  \item{start}{Record number to start at}

  \item{name}{Full scientific name potentially with
  authorship}

  \item{rank}{The rank given as our rank enum.}

  \item{kingdom}{If provided default matching will also try
  to match against this if no direct match is found for the
  name alone.}

  \item{phylum}{If provided default matching will also try
  to match against this if no direct match is found for the
  name alone.}

  \item{class}{If provided default matching will also try
  to match against this if no direct match is found for the
  name alone.}

  \item{order}{If provided default matching will also try
  to match against this if no direct match is found for the
  name alone.}

  \item{family}{If provided default matching will also try
  to match against this if no direct match is found for the
  name alone.}

  \item{genus}{If provided default matching will also try
  to match against this if no direct match is found for the
  name alone.}

  \item{strict}{If TRUE it (fuzzy) matches only the given
  name, but never a taxon in the upper classification}

  \item{verbose}{If TRUE show alternative matches
  considered which had been rejected.}
}
\value{
  A list.
}
\description{
  Lookup names in the GBIF backbone taxonomy.
}
\examples{
\dontrun{
name_backbone(name='Helianthus annuus', kingdom='plants')
name_backbone(name='Helianthus', rank='genus', kingdom='plants')
name_backbone(name='Helianthus annuus', kingdom='plants', verbose=TRUE)
}
}
\references{
  \url{http://www.gbif.org/developer/summary}
}

