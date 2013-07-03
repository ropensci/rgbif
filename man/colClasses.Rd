\name{colClasses}
\alias{colClasses}
\title{Coerces data.frame columns to the specified classes}
\usage{
  colClasses(d, colClasses)
}
\arguments{
  \item{d}{A data.frame.}

  \item{colClasses}{A vector of column attributes, one of:
  numeric, factor, character, etc.}
}
\description{
  Coerces data.frame columns to the specified classes
}
\examples{
dat <- data.frame(xvar = seq(1:10), yvar = rep(c("a","b"),5)) # make a data.frame
str(dat)
str(colClasses(dat, c("factor","factor")))
}
\keyword{internal}

