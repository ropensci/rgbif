% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/occ_download.R
\name{occ_download}
\alias{occ_download}
\alias{occ_download_prep}
\title{Spin up a download request for GBIF occurrence data.}
\usage{
occ_download(
  ...,
  body = NULL,
  type = "and",
  format = "DWCA",
  user = NULL,
  pwd = NULL,
  email = NULL,
  curlopts = list()
)

occ_download_prep(
  ...,
  body = NULL,
  type = "and",
  format = "DWCA",
  user = NULL,
  pwd = NULL,
  email = NULL,
  curlopts = list()
)
}
\arguments{
\item{...}{For \code{occ_download()} and \code{occ_download_prep()}, one or more
objects of class \code{occ_predicate} or \code{occ_predicate_list}, created by
\verb{pred*} functions (see \link{download_predicate_dsl}). If you use this, don't
use \code{body} parameter.}

\item{body}{if you prefer to pass in the payload yourself, use this
parameter. If you use this, don't pass anything to the dots. Accepts
either an R list, or JSON. JSON is likely easier, since the JSON
library \pkg{jsonlite} requires that you unbox strings that shouldn't
be auto-converted to arrays, which is a bit tedious for large queries.
optional}

\item{type}{(character) One of equals (=), and (&), or (|), lessThan (<),
lessThanOrEquals (<=), greaterThan (>), greaterThanOrEquals (>=), in,
within, not (!), like, isNotNull}

\item{format}{(character) The download format. One of 'DWCA' (default),
'SIMPLE_CSV', or 'SPECIES_LIST'}

\item{user}{(character) User name within GBIF's website. Required. See
"Authentication" below}

\item{pwd}{(character) User password within GBIF's website. Required. See
"Authentication" below}

\item{email}{(character) Email address to receive download notice done
email. Required. See "Authentication" below}

\item{curlopts}{list of named curl options passed on to
\code{\link[crul]{HttpClient}}. see \code{curl::curl_options}
for curl options}
}
\description{
Spin up a download request for GBIF occurrence data.
}
\note{
see \link{downloads} for an overview of GBIF downloads methods
}
\section{geometry}{

When using the geometry parameter, make sure that your well known text
(WKT) is formatted as GBIF expects it. They expect WKT to have a
counter-clockwise winding order. For example, the following is clockwise
\verb{POLYGON((-19.5 34.1, -25.3 68.1, 35.9 68.1, 27.8 34.1, -19.5 34.1))},
whereas they expect the other order:
\verb{POLYGON((-19.5 34.1, 27.8 34.1, 35.9 68.1, -25.3 68.1, -19.5 34.1))}

note that coordinate pairs are \verb{longitude latitude}, longitude first, then
latitude

you should not get any results if you supply WKT that has clockwise
winding order.

also note that \code{\link[=occ_search]{occ_search()}}/\code{\link[=occ_data]{occ_data()}} behave differently with
respect to WKT in that you can supply clockwise WKT to those
functions but they treat it as an exclusion, so get all data not
inside the WKT area.
}

\section{Methods}{

\itemize{
\item \code{occ_download_prep}: prepares a download request, but DOES NOT execute it.
meant for use with \code{\link[=occ_download_queue]{occ_download_queue()}}
\item \code{occ_download}: prepares a download request and DOES execute it
}
}

\section{Authentication}{

For \code{user}, \code{pwd}, and \code{email} parameters, you can set them in one of
three ways:
\itemize{
\item Set them in your \code{.Rprofile} file with the names \code{gbif_user},
\code{gbif_pwd}, and \code{gbif_email}
\item Set them in your \code{.Renviron}/\code{.bash_profile} (or similar) file with the
names \code{GBIF_USER}, \code{GBIF_PWD}, and \code{GBIF_EMAIL}
\item Simply pass strings to each of the parameters in the function
call
}

We strongly recommend the second option - storing your details as
environment variables as it's the most widely used way to store secrets.

See \code{?Startup} for help.
}

\section{Query length}{

GBIF has a limit of 12,000 characters for a download query. This means
that you can have a pretty long query, but at some point it may lead to an
error on GBIF's side and you'll have to split your query into a few.
}

\examples{
\dontrun{
# occ_download(pred("basisOfRecord", "LITERATURE"))
# occ_download(pred("taxonKey", 3119195), pred_gt("elevation", 5000))
# occ_download(pred_gt("decimalLatitude", 50))
# occ_download(pred_gte("elevation", 9000))
# occ_download(pred_gte('decimalLatitude", 65))
# occ_download(pred("country", "US"))
# occ_download(pred("institutionCode", "TLMF"))
# occ_download(pred("catalogNumber", 217880))
# occ_download(pred("gbifId", 142317604)) 

# download format
# z <- occ_download(pred_gte("decimalLatitude", 75),
#  format = "SPECIES_LIST")

# res <- occ_download(pred("taxonKey", 7264332), pred("hasCoordinate", TRUE))

# pass output directly, or later, to occ_download_meta for more information
# occ_download(pred_gt('decimalLatitude', 75)) \%>\% occ_download_meta

# Multiple queries
# occ_download(pred_gte("decimalLatitude", 65),
#  pred_lte("decimalLatitude", -65), type="or")
# gg <- occ_download(pred("depth", 80), pred("taxonKey", 2343454),
#  type="or")
# x <- occ_download(pred_and(pred_within("POLYGON((-14 42, 9 38, -7 26, -14 42))"),
#  pred_gte("elevation", 5000)))

# complex example with many predicates
# shows example of how to do date ranges for both year and month
# res <- occ_download(
#  pred_gt("elevation", 5000),
#  pred_in("basisOfRecord", c('HUMAN_OBSERVATION','OBSERVATION','MACHINE_OBSERVATION')),
#  pred("country", "US"),
#  pred("hasCoordinate", TRUE),
#  pred("hasGeospatialIssue", FALSE),
#  pred_gte("year", 1999),
#  pred_lte("year", 2011),
#  pred_gte("month", 3),
#  pred_lte("month", 8)
# )

# Using body parameter - pass in your own complete query
## as JSON
query1 <- '{"creator":"sckott",
  "notification_address":["stuff1@gmail.com"],
  "predicate":{"type":"and","predicates":[
    {"type":"equals","key":"TAXON_KEY","value":"7264332"},
    {"type":"equals","key":"HAS_COORDINATE","value":"TRUE"}]}
 }'
# res <- occ_download(body = query1, curlopts=list(verbose=TRUE))

## as a list
library(jsonlite)
query <- list(
  creator = unbox("sckott"),
  notification_address = "stuff1@gmail.com",
  predicate = list(
    type = unbox("and"),
    predicates = list(
      list(type = unbox("equals"), key = unbox("TAXON_KEY"),
        value = unbox("7264332")),
      list(type = unbox("equals"), key = unbox("HAS_COORDINATE"),
        value = unbox("TRUE"))
    )
  )
)
# res <- occ_download(body = query, curlopts = list(verbose = TRUE))

# Prepared query
occ_download_prep(pred("basisOfRecord", "LITERATURE"))
occ_download_prep(pred("basisOfRecord", "LITERATURE"), format = "SIMPLE_CSV")
occ_download_prep(pred("basisOfRecord", "LITERATURE"), format = "SPECIES_LIST")
occ_download_prep(pred_in("taxonKey", c(2977832, 2977901, 2977966, 2977835)))
occ_download_prep(pred_within("POLYGON((-14 42, 9 38, -7 26, -14 42))"))

## a complicated example
occ_download_prep(
  pred_in("basisOfRecord", c("MACHINE_OBSERVATION", "HUMAN_OBSERVATION")),
  pred_in("taxonKey", c(2498343, 2481776, 2481890)),
  pred_in("country", c("GB", "IE")),
  pred_or(pred_lte("year", 1989), pred("year", 2000))
)

# x = occ_download(
#   pred_in("basisOfRecord", c("MACHINE_OBSERVATION", "HUMAN_OBSERVATION")),
#   pred_in("taxonKey", c(9206251, 3112648)),
#   pred_in("country", c("US", "MX")),
#   pred_and(pred_gte("year", 1989), pred_lte("year", 1991))
# )
# occ_download_meta(x)
# z <- occ_download_get(x)
# df <- occ_download_import(z)
# str(df)
# library(dplyr)
# unique(df$basisOfRecord)
# unique(df$taxonKey)
# unique(df$countryCode)
# sort(unique(df$year))
}
}
\references{
See the API docs
\url{https://www.gbif.org/developer/occurrence#download} for more info,
and the predicates docs
\url{https://www.gbif.org/developer/occurrence#predicates}
}
\seealso{
Other downloads: 
\code{\link{download_predicate_dsl}},
\code{\link{occ_download_cached}()},
\code{\link{occ_download_cancel}()},
\code{\link{occ_download_dataset_activity}()},
\code{\link{occ_download_datasets}()},
\code{\link{occ_download_get}()},
\code{\link{occ_download_import}()},
\code{\link{occ_download_list}()},
\code{\link{occ_download_meta}()},
\code{\link{occ_download_queue}()},
\code{\link{occ_download_wait}()}
}
\concept{downloads}
