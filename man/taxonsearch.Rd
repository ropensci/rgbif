\name{taxonsearch}
\alias{taxonsearch}
\title{Search for taxa in GBIF.}
\usage{
  taxonsearch(scientificname = NULL, rank = NULL,
    maxresults = 10, dataproviderkey = NULL,
    dataresourcekey = NULL, resourcenetworkkey = NULL,
    hostisocountrycode = NULL, startindex = NULL,
    url = "http://data.gbif.org/ws/rest/taxon/list")
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

  \item{url}{the base GBIF API url for the function (should
  be left to default)}
}
\value{
  List of TaxonConcept key values.
}
\description{
  Search for a taxon using scientific name. Optionally,
  include taxonomic rank in the search. Returns list of
  TaxonConcept key values.
}
\examples{
\dontrun{
taxonsearch(scientificname = 'Puma concolor')
}
}

