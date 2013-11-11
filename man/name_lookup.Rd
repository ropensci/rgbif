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

  \item{rank}{Taxonomic rank. Filters by taxonomic rank as
  one of: CLASS, CULTIVAR, CULTIVAR_GROUP, DOMAIN, FAMILY,
  FORM, GENUS, INFORMAL, INFRAGENERIC_NAME, INFRAORDER,
  INFRASPECIFIC_NAME, INFRASUBSPECIFIC_NAME, KINGDOM,
  ORDER, PHYLUM, SECTION, SERIES, SPECIES, STRAIN,
  SUBCLASS, SUBFAMILY, SUBFORM, SUBGENUS, SUBKINGDOM,
  SUBORDER, SUBPHYLUM, SUBSECTION, SUBSERIES, SUBSPECIES,
  SUBTRIBE, SUBVARIETY, SUPERCLASS, SUPERFAMILY,
  SUPERORDER, SUPERPHYLUM, SUPRAGENERIC_NAME, TRIBE,
  UNRANKED, VARIETY}

  \item{highertaxon_key}{Filters by any of the higher
  Linnean rank keys. Note this is within the respective
  checklist and not searching nub keys across all
  checklists.}

  \item{status}{Filters by the taxonomic status as one of:
  \itemize{ \item ACCEPTED \item DETERMINATION_SYNONYM Used
  for unknown child taxa referred to via spec, ssp, ...
  \item DOUBTFUL Treated as accepted, but doubtful whether
  this is correct.  \item HETEROTYPIC_SYNONYM More specific
  subclass of SYNONYM.  \item HOMOTYPIC_SYNONYM More
  specific subclass of SYNONYM.  \item
  INTERMEDIATE_RANK_SYNONYM Used in nub only.  \item
  MISAPPLIED More specific subclass of SYNONYM.  \item
  PROPARTE_SYNONYM More specific subclass of SYNONYM.
  \item SYNONYM A general synonym, the exact type is
  unknown. }}

  \item{extinct}{Filters by extinction status (a boolean,
  e.g. extinct=true)}

  \item{habitat}{Filters by the habitat, though currently
  only as boolean marine or not-marine (i.e. habitat=true
  means marine, false means not-marine)}

  \item{threat}{Not yet implemented, but will eventually
  allow for filtering by a threat status enum}

  \item{name_type}{Filters by the name type as one of:
  \itemize{ \item BLACKLISTED surely not a scientific name.
  \item CANDIDATUS Candidatus is a component of the
  taxonomic name for a bacterium that cannot be maintained
  in a Bacteriology Culture Collection.  \item CULTIVAR a
  cultivated plant name.  \item DOUBTFUL doubtful whether
  this is a scientific name at all.  \item HYBRID a hybrid
  formula (not a hybrid name).  \item INFORMAL a scientific
  name with some informal addition like "cf." or
  indetermined like Abies spec.  \item SCINAME a scientific
  name which is not well formed.  \item VIRUS a virus name.
  \item WELLFORMED a well formed scientific name according
  to present nomenclatural rules. }}

  \item{dataset_key}{Filters by the dataset's key (a uuid)}

  \item{nomenclatural_status}{Not yet implemented, but will
  eventually allow for filtering by a nomenclatural status
  enum}

  \item{hl}{Set hl=true to highlight terms matching the
  query when in fulltext search fields. The highlight will
  be an emphasis tag of class 'gbifH1' e.g.
  http://api.gbif.org/species/search?q=plant&hl=true.}

  \item{facet}{A list of facet names used to retrieve the
  100 most frequent values for a field. Allowed facets are:
  dataset_key, highertaxon_key, rank, status, extinct,
  habitat, and name_type. Additionally threat and
  nomenclatural_status are legal values but not yet
  implemented, so data will not yet be returned for them.}

  \item{facet_only}{Used in combination with the facet
  parameter. Set facet_only=true to exclude search
  results.}

  \item{facet_mincount}{Used in combination with the facet
  parameter. Set facet_mincount={#} to exclude facets with
  a count less than {#}, e.g.  http://bit.ly/1bMdByP only
  shows the type value 'ACCEPTED' because the other
  statuses have counts less than 7,000,000}

  \item{facet_multiselect}{Used in combination with the
  facet parameter. Set facet_multiselect=true to still
  return counts for values that are not currently filtered,
  e.g. http://bit.ly/19YLXPO still shows all status values
  even though status is being filtered by status=ACCEPTED}

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

  \item{limit}{Number of records to return}

  \item{callopts}{Further arguments passed on to the
  \code{\link{GET}} request.}

  \item{verbose}{If TRUE, all data is returned as a list
  for each element. If FALSE (default) a subset of the data
  that is thought to be most essential is organized into a
  data.frame.}

  \item{return}{One of data, meta, facets, or all. If data,
  a data.frame with the data. hier returns the
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
library(plyr)
llply(out$data, function(x) x[!names(x) \%in\% c("descriptions","descriptionsSerialized")])

# Search for a genus, returning just data
name_lookup(query='Cnaemidophorus', rank="genus", return="data")

# Just metadata
name_lookup(query='Cnaemidophorus', rank="genus", return="meta")

# Fuzzy searching
name_lookup(query='Cnaemidophor', rank="genus")

# Get more data from the API call
library(httr)
name_lookup(query='Cnaemidophorus', rank="genus", callopts=verbose())

# Limit records to certain number
name_lookup('Helianthus annuus', rank="species", limit=2)
}
}
\references{
  \url{http://dev.gbif.org/wiki/display/POR/Webservice+API}
}

