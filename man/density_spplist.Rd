\name{density_spplist}
\alias{density_spplist}
\title{The density web service provides access to records showing the density
		of occurrence records from the GBIF Network by one-degree cell.}
\usage{
  density_spplist(taxonconceptKey = NULL,
    dataproviderkey = NULL, dataresourcekey = NULL,
    resourcenetworkkey = NULL, originisocountrycode = NULL,
    format = NULL,
    spplist = c("none", "random", "greatest", "all"),
    listcount = "list")
}
\arguments{
  \item{taxonconceptKey}{Unique key for taxon (numeric).
  Count only records which are for the taxon identified by
  the supplied numeric key, including any records provided
  under synonyms of the taxon concerned, and any records
  for child taxa (e.g. all genera and species within a
  family).  May be repeted in single request.}

  \item{dataproviderkey}{Filter records to those provided
  by the supplied numeric key for a data provider. See
  provider(). (character)}

  \item{dataresourcekey}{Filter records to those provided
  by the supplied numeric key for a data resource See
  resource(). (character)}

  \item{resourcenetworkkey}{count only records which have
  been made available by resources identified as belonging
  to the network identified by the supplied numeric key.}

  \item{originisocountrycode}{Return density records for
  occurrences which occurred within the country identified
  by the supplied 2-letter ISO code.}

  \item{format}{Specifies the format in which the records
  are to be returned, one of: brief or kml (character)}

  \item{spplist}{Get the species list for a 1 degree cell.
  One of "none", "random", "greatest", or "all". "none"
  returns the data.frame of count of specimens by 1 degree
  cells without species list. "random" returns a species
  list selected randomly from one of the cells. "greatest"
  returns a species list selected from the cell with the
  greatest number of specimens.  "all" returns species
  lists from all cells in a list. Be aware that calling
  "all" could take quite a while, so plan accordingly.}

  \item{listcount}{Return a species list ('splist') or a
  data.frame of the species and the count for each species
  ('counts').}
}
\value{
  A vector of scientific species names for one degree grid
  cells.
}
\description{
  This is similar to the densitylist function. You can get
  the same data.frame of results as densitylist with this
  function, but you can also get a species list or
  data.frame of species and their counts for any degree
  cell.
}
\examples{
\dontrun{
# Just return the data.frame of counts by cells.
density_spplist(originisocountrycode = "CO")

# Get a species list by cell, choosing one at random
density_spplist(originisocountrycode = "CO", spplist = "random")
density_spplist(originisocountrycode = "CO", spplist = "r") # can abbr. spplist

# Get a species list by cell, choosing the one with the greatest no. of records
density_spplist(originisocountrycode = "CO", spplist = "great")

# Instead of a list, get back a data.frame with species names and counts
density_spplist(originisocountrycode = "CO", spplist = "great", listcount='counts')
}
}

