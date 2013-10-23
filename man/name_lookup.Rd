\name{name_lookup}
\alias{name_lookup}
\title{Lookup names in all taxonomies in GBIF.}
\usage{
  name_lookup(query = NULL, canonical_name = NULL,
    class = NULL, description = NULL, family = NULL,
    genus = NULL, kingdom = NULL, order = NULL,
    phylum = NULL, scientificName = NULL, species = NULL,
    rank = NULL, subgenus = NULL, vernacularName = NULL,
    limit = 20, callopts = list(), verbose = FALSE,
    return = "all")
}
\arguments{
  \item{query}{Query term(s) for full text search.}

  \item{canonical_name}{Canonical name}

  \item{class}{Taxonomic class}

  \item{description}{Description}

  \item{family}{Taxonomic family}

  \item{genus}{Taxonomic genus}

  \item{kingdom}{Taxonomic kingdom}

  \item{order}{Taxonomic order}

  \item{phylum}{Taxonomic phylum}

  \item{scientificName}{Scientific name}

  \item{species}{Species name}

  \item{subgenus}{Taxonomic subgenus}

  \item{rank}{Taxonomic rank}

  \item{vernacularName}{Vernacular (common) name}

  \item{limit}{Number of records to return}

  \item{callopts}{Further arguments passed on to the
  \code{\link{GET}} request.}

  \item{verbose}{If TRUE, all data is returned as a list
  for each element. If FALSE (default) a subset of the data
  that is thought to be most essential is organized into a
  data.frame.}

  \item{return}{One of data, hier, meta, or all. If data, a
  data.frame with the data. hier returns the
  classifications in a list for each record. meta returns
  the metadata for the entire call. all gives all data back
  in a list.}
}
\value{
  A list of length two. The first element is metadata. The
  second is either a data.frame (verbose=FALSE, default) or
  a list (verbose=TRUE)
}
\description{
  This service uses fuzzy lookup so that you can put in
  partial names and you should get back those things that
  match. See examples below.
}
\examples{
\dontrun{
# Look up names like mammalia
name_lookup(class='mammalia')

# Look up sunflowers
out <- name_lookup('Helianthus annuus', rank="species")

# Get all data and parse it, removing descriptions which can be quite long
out <- name_lookup('Helianthus annuus', rank="species", verbose=TRUE)
llply(out$data, function(x) x[!names(x) \%in\% c("descriptions","descriptionsSerialized")])

# Search for a genus, returning just data
name_lookup(query='Cnaemidophorus', rank="genus", return="data")

# Just metadata
name_lookup(query='Cnaemidophorus', rank="genus", return="meta")

# Fuzzy searching
name_lookup(query='Cnaemidophor', rank="genus")

# Get more data from the API call
name_lookup(query='Cnaemidophorus', rank="genus", callopts=verbose())

# Limit records to certain number
name_lookup('Helianthus annuus', rank="species", limit=2)
}
}
\references{
  \url{http://dev.gbif.org/wiki/display/POR/Webservice+API}
}

