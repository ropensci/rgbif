\name{taxonsearch}
\alias{taxonsearch}
\title{Search for taxa in GBIF.}
\usage{
  taxonsearch(scientificname = NULL, rank = NULL,
    maxresults = 10, dataproviderkey = 1,
    dataresourcekey = NULL, resourcenetworkkey = NULL,
    hostisocountrycode = NULL, startindex = NULL,
    accepted_status = FALSE)
}
\arguments{
  \item{scientificname}{scientific name of taxon
  (character, see example)}

  \item{rank}{rank of taxon, see taxrank() (character)}

  \item{maxresults}{return at most the specified number of
  records. The default (and maximum supported) is 1000
  records.}

  \item{dataproviderkey}{Filter records to those provided
  by the supplied numeric key for a data provider. See
  provider(). (character)}

  \item{dataresourcekey}{Filter records to those provided
  by the supplied numeric key for a data resource See
  resource(). (character)}

  \item{resourcenetworkkey}{count only records which have
  been made available by resources identified as belonging
  to the network identified by the supplied numeric key.}

  \item{hostisocountrycode}{return only records served by
  providers from the country identified by the supplied
  2-letter ISO code.}

  \item{startindex}{return the subset of the matching
  records that starts at the supplied (zero-based index).}

  \item{accepted_status}{Status in the GIBF portal}
}
\value{
  A data.frame.
}
\description{
  When searching for taxa, keep in mind that unless you
  want taxon identifiers for a specific data source, leave
  dataproviderkey as the default of 1, which is the GBIF
  backbone taxonomy. Also, always specify the taxonomic
  rank you are searching for - GBIF says the search is more
  efficient if rank is given.
}
\details{
  This function is deprecated.

  Search for a taxon using scientific name. Optionally,
  include taxonomic rank in the search. Returns list of
  TaxonConcept key values.
}
\examples{
\dontrun{
# Do specify the taxonomic rank the you are searching for, rank of species here
taxonsearch(scientificname = 'Puma concolor', rank="species")

# Fabaceae (rank of genus)
taxonsearch(scientificname = 'Abies', rank="genus")

# Fabaceae (rank of family)
taxonsearch(scientificname = 'Fabaceae', rank="family")
}
}
\seealso{
  occ_search
}

