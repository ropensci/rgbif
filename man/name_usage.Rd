\name{name_usage}
\alias{name_usage}
\title{Lookup details for specific names in all taxonomies in GBIF.}
\usage{
  name_usage(key = NULL, name = NULL, data = "all",
    language = NULL, datasetKey = NULL, sourceId = NULL,
    rank = NULL, uuid = NULL, shortname = NULL,
    start = NULL, limit = 20, callopts = list())
}
\arguments{
  \item{callopts}{Pass on options to httr::GET for more
  refined control of http calls, and error handling}

  \item{limit}{Number of records to return}

  \item{start}{Record number to start at}

  \item{rank}{Taxonomic rank. Filters by taxonomic rank as
  one of: CLASS, CULTIVAR, CULTIVAR_GROUP, DOMAIN, FAMILY,
  FORM, GENUS, INFORMAL, INFRAGENERIC_NAME, INFRAORDER,
  INFRASPECIFIC_NAME, INFRASUBSPECIFIC_NAME, KINGDOM,
  ORDER, PHYLUM, SECTION, SERIES, SPECIES, STRAIN,
  SUBCLASS, SUBFAMILY, SUBFORM, SUBGENUS, SUBKINGDOM,
  SUBORDER, SUBPHYLUM, SUBSECTION, SUBSERIES, SUBSPECIES,
  SUBTRIBE, SUBVARIETY, SUPERCLASS, SUPERFAMILY,
  SUPERORDER, SUPERPHYLUM, SUPRAGENERIC_NAME, TRIBE,
  UNRANKED, VARIETY}

  \item{datasetKey}{Filters by the dataset's key (a uuid)}

  \item{key}{A GBIF key for a taxon}

  \item{name}{Filters by a case insensitive, canonical
  namestring, e.g. 'Puma concolor'}

  \item{data}{Specify an option to select what data is
  returned. See Description below.}

  \item{language}{Language, default is english}

  \item{sourceId}{Filters by the source identifier}

  \item{uuid}{A uuid for a dataset.}

  \item{shortname}{A short name..need more info on this?}
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

# Name usage for a taxonomic name
name_usage(name='Puma concolor')

# References for a name usage
name_usage(key=3119195, data='references')

# Vernacular names for a name usage
name_usage(key=3119195, data='vernacular_names')

# Select many options
name_usage(key=3119195, data=c('images','synonyms'))
}
}
\references{
  \url{http://www.gbif.org/developer/summary}
}

