\name{occurrencelist_all}
\alias{occurrencelist_all}
\title{Occurrencelist_all carries out an occurrencelist query for a single name and all its name variants according to GBIF's name matching.}
\usage{
  occurrencelist_all(scientificname, ...)
}
\arguments{
  \item{scientificname}{A scientific name. (character)}

  \item{...}{Further arguments passed on to
  occurrencelist_many}
}
\description{
  Occurrencelist_all carries out an occurrencelist query
  for a single name and all its name variants according to
  GBIF's name matching.
}
\examples{
\dontrun{
# Query for a single species
# compare the names returned by occurrencelist to occurrencelist_all
occurrencelist(scientificname = 'Aristolochia serpentaria', coordinatestatus = TRUE,
   maxresults = 40)
occurrencelist_all(scientificname = 'Aristolochia serpentaria', coordinatestatus = TRUE,
   maxresults = 40)

}
}

