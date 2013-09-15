\name{gist}
\alias{gist}
\title{Post a file as a Github gist}
\usage{
  gist(gist, ...)
}
\arguments{
  \item{gist}{An object}

  \item{...}{}
}
\description{
  You will be asked ot enter you Github credentials
  (username, password) during each session, but only once
  for each session.
}
\examples{
\dontrun{
library(plyr)
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
keys <- sapply(splist, function(x) gbif_lookup(name=x, kingdom='plants')$speciesKey, USE.NAMES=FALSE)
out <- occ_search(keys, georeferenced=TRUE, limit=50, return="data")
dat <- ldply(out)
datgeojson <- stylegeojson(input=dat, var="name", color=c("#976AAE","#6B944D","#BD5945"), size=c("small","medium","large"))
write.csv(datgeojson, "~/my.csv")
togeojson(input="~/my.csv", method="web", outfilename="my")
gist("~/my.geojson", description = "Occurrences of three bird species mapped")
}
}

