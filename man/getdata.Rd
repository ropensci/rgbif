\name{getdata}
\alias{getdata}
\title{Get data.frame from occurrencelist, occurrencelist_many, or densitylist.}
\usage{
  getdata(input, minimal = TRUE)
}
\arguments{
  \item{input}{Input object from a call to occurrencelist,
  occurrencelist_many, or densitylist.}

  \item{minimal}{Only applies to occurrencelist data. If
  TRUE, returns only name, lat, long fields; defaults to
  TRUE.}
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
out <- occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE, maxresults = 40)
getdata(out)
getdata(out, minimal=FALSE)

occurrencelist_many
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
out <- occurrencelist_many(splist, coordinatestatus = TRUE, maxresults = 20)
getdata(out)
getdata(out, minimal=FALSE)

# densitylist (the minimal parameter doesn't apply with densitylist data)
out <- densitylist(originisocountrycode="US")
getdata(out)
}
}

