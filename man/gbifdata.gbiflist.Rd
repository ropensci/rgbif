\name{gbifdata.gbiflist}
\alias{gbifdata.gbiflist}
\title{Gbiflist method}
\usage{
  \method{gbifdata}{gbiflist} (input,
    coordinatestatus = TRUE, minimal = TRUE, ...)
}
\arguments{
  \item{input}{Input object from a call to occurrencelist,
  occurrencelist_many, or densitylist.}

  \item{minimal}{Only applies to occurrencelist data. If
  TRUE, returns only name, lat, long fields; defaults to
  TRUE.}

  \item{coordinatestatus}{Return only rows of data.frame
  that have lat and long data.}

  \item{...}{further arguments}
}
\description{
  Gbiflist method
}

