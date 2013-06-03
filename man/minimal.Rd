\name{minimal}
\alias{minimal}
\title{Prints the minimal results of the call.}
\usage{
  minimal(x)
}
\arguments{
  \item{x}{input}
}
\description{
  Prints the minimal results of the call.
}
\examples{
out <- occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE, maxresults = 4000)
minimal(out)
}

