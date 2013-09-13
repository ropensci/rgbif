\name{name_usage}
\alias{name_usage}
\title{Lookup details for specific names in all taxonomies in GBIF.}
\usage{
  name_usage(key = NULL, data = "all", language = NULL,
    datasetKey = NULL, sourceId = NULL, rank = NULL,
    uuid = NULL, shortname = NULL, callopts = list())
}
\arguments{
  \item{key}{A key for a taxon}

  \item{data}{Specify an option to select what data is
  returned. See Description below.}

  \item{language}{Language, default is english}

  \item{datasetKey}{Dataset key}

  \item{sourceId}{Source id}

  \item{rank}{Taxonomic rank}

  \item{uuid}{A uuid for a dataset.}

  \item{shortname}{A short name..need more info on this...}

  \item{callopts}{Options passed on to GET}
}
\value{
  A list of length two. The first element is metadata. The
  second is either a data.frame (verbose=FALSE, default) or
  a list (verbose=TRUE)
}
\description{
  This service uses fuzzy lookup so that you can put in
  partial names and you should get back those things that
  match. See examples below.

  This function is different from \code{name_lookup} in
  that that function searches for names, while this
  function requires that you already have a key.

  Note that verbatim hasn't been working for me.

  Options for the data parameter are: 'all', 'verbatim',
  'name', 'parents', 'children', 'descendants', 'related',
  'synonyms', 'descriptions','distributions', 'images',
  'references', 'species_profiles', 'vernacular_names',
  'type_specimens', 'root'
}
\examples{
\dontrun{
# All name usages
name_usage()

# A single name usage
name_usage(key=1)

# References for a name usage
name_usage(key=3119195, data='references')

# Vernacular names for a name usage
name_usage(key=3119195, data='vernacular_names')

# Select many options
name_usage(key=3119195, data=c('images','synonyms'))
}
}
\references{
  \url{http://dev.gbif.org/wiki/display/POR/Webservice+API}
}

