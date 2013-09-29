\name{gbifdata}
\alias{gbifdata}
\title{Get data.frame from occurrencelist, occurrencelist_many, or densitylist.}
\usage{
  gbifdata(input, ...)
}
\arguments{
  \item{input}{Input object from a call to occurrencelist,
  occurrencelist_many, or densitylist.}

  \item{...}{further arguments}
}
\description{
  Get data.frame from occurrencelist, occurrencelist_many,
  or densitylist.
}
\details{
  A convienence function to get the raw data in a
  data.frame format from occurrencelist,
  occurrencelist_many, and densitylist functions.
}
\examples{
\dontrun{
# occurrencelist
out <- occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE,
   maxresults = 40)
gbifdata(out)
gbifdata(out, minimal=FALSE)

occurrencelist_many
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
out <- occurrencelist_many(splist, coordinatestatus = TRUE, maxresults = 20)
gbifdata(out)
gbifdata(out, minimal=FALSE)

# densitylist (the minimal parameter doesn't apply with densitylist data)
out <- densitylist(originisocountrycode="US")
gbifdata(out)
}
}

