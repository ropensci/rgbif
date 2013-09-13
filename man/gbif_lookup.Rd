\name{gbif_lookup}
\alias{gbif_lookup}
\title{Lookup names in the GBIF backbone taxonomy.}
\usage{
  gbif_lookup(name, rank = NULL, kingdom = NULL,
    phylum = NULL, class = NULL, order = NULL,
    family = NULL, genus = NULL, strict = FALSE,
    verbose = FALSE, callopts = list())
}
\arguments{
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

  \item{callopts}{Further args passed on to GET.}
}
\value{
  A list.
}
\description{
  Lookup names in the GBIF backbone taxonomy.
}
\examples{
\dontrun{
gbif_lookup(name='Helianthus annuus', kingdom='plants')
gbif_lookup(name='Helianthus', rank='genus', kingdom='plants')
gbif_lookup(name='Helianthus annuus', kingdom='plants', verbose=TRUE)
}
}
\references{
  \url{http://dev.gbif.org/wiki/display/POR/Webservice+API}
}

