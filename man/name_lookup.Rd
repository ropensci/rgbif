\name{name_lookup}
\alias{name_lookup}
\title{Lookup names in all taxonomies.}
\usage{
  name_lookup(canonical_name = NULL, class = NULL,
    description = NULL, family = NULL, genus = NULL,
    kingdom = NULL, order = NULL, phylum = NULL,
    scientificName = NULL, species = NULL, subgenus = NULL,
    vernacularName = NULL, callopts = list())
}
\arguments{
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

  \item{vernacularName}{Vernacular (common) name}

  \item{callopts}{Further arguments passed on to the
  \code{\link{GET}} request.}
}
\description{
  See details for information about the sources.
}
\examples{
\dontrun{
name_lookup(class='mammalia')
}
}

