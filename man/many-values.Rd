% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/many-values.R
\name{many-values}
\alias{many-values}
\title{Many value inputs to some parameters}
\description{
Many value inputs to some parameters
}
\details{
There are some differences in how functions across \pkg{rgbif} behave
with respect to many values given to a single parameter (let's call it
\code{foo}).

The following functions originally only iterated over many
values passed to \code{foo} as a vector (e.g., \code{foo = c(1, 2)}) with completely
separate HTTP requests. But now these functions also support passing in many
values to the same HTTP request (e.g., \code{foo = "1;2"}). This is a bit
awkward, but means that we don't break existing code. See
"Multiple values passed to a parameter" in \code{occ_search}/\code{occ_data} for more
information.

\itemize{
\item \code{\link[=occ_search]{occ_search()}}
\item \code{\link[=occ_data]{occ_data()}}
}

The following functions, unlike those above, only support passing in many
values to the same HTTP request, which is done like \code{foo = c("1", "2")}.

\itemize{
\item \code{\link[=dataset_search]{dataset_search()}}
\item \code{\link[=dataset_suggest]{dataset_suggest()}}
\item \code{\link[=name_lookup]{name_lookup()}}
\item \code{\link[=name_suggest]{name_suggest()}}
\item \code{\link[=name_usage]{name_usage()}}
}

Last, some parameters in the functions above don't accept more than one,
and some functions don't have any parameters that accept more than one
value (i.e., none of those listed above).

Each function that has at least some parameters that accept many values
also has documentation on this issue.
}
