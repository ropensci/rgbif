\name{dataset_search}
\alias{dataset_search}
\title{Search datasets in GBIF.}
\usage{
dataset_search(query = NULL, country = NULL, type = NULL,
  keyword = NULL, owning_org = NULL, hosting_org = NULL,
  publishing_country = NULL, decade = NULL, facet = NULL,
  facet_only = NULL, facet_mincount = NULL, facet_multiselect = NULL,
  limit = 20, start = NULL, callopts = list(), pretty = FALSE,
  return = "all")
}
\arguments{
  \item{callopts}{Pass on options to httr::GET for more
  refined control of http calls, and error handling}

  \item{limit}{Number of records to return}

  \item{start}{Record number to start at}

  \item{query}{Query term(s) for full text search.  The
  value for this parameter can be a simple word or a
  phrase. Wildcards can be added to the simple word
  parameters only, e.g. q=*puma*}

  \item{country}{NOT YET IMPLEMENTED. Filters by country as
  given in isocodes$gbif_name, e.g. country=CANADA.}

  \item{type}{Type of dataset, options include OCCURRENCE,
  etc.}

  \item{keyword}{Keyword to search by. Datasets can be
  tagged by keywords, which you can search on. The search
  is done on the merged collection of tags, the dataset
  keywordCollections and temporalCoverages.}

  \item{owning_org}{Owning organization. A uuid string. See
  \code{\link{organizations}}}

  \item{hosting_org}{Hosting organization. A uuid string.
  See \code{\link{organizations}}}

  \item{publishing_country}{Publishing country. See options
  at isocodes$gbif_name}

  \item{decade}{Decade, e.g., 1980. Filters datasets by
  their temporal coverage broken down to decades. Decades
  are given as a full year, e.g. 1880, 1960, 2000, etc, and
  will return datasets wholly contained in the decade as
  well as those that cover the entire decade or more. Facet
  by decade to get the break down, e.g.
  /search?facet=DECADE&facet_only=true (see example below)}

  \item{pretty}{Print informative metadata using
  \code{\link{cat}}. Not easy to manipulate output though.}

  \item{facet}{A list of facet names used to retrieve the
  100 most frequent values for a field. Allowed facets are:
  dataset_key, highertaxon_key, rank, status, extinct,
  habitat, and name_type. Additionally threat and
  nomenclatural_status are legal values but not yet
  implemented, so data will not yet be returned for them.}

  \item{facet_only}{Used in combination with the facet
  parameter. Set facet_only=true to exclude search
  results.}

  \item{facet_mincount}{Used in combination with the facet
  parameter. Set facet_mincount={#} to exclude facets with
  a count less than {#}, e.g.  http://bit.ly/1bMdByP only
  shows the type value 'ACCEPTED' because the other
  statuses have counts less than 7,000,000}

  \item{facet_multiselect}{Used in combination with the
  facet parameter. Set facet_multiselect=true to still
  return counts for values that are not currently filtered,
  e.g. http://bit.ly/19YLXPO still shows all status values
  even though status is being filtered by status=ACCEPTED}

  \item{return}{What to return. One of meta, descriptions,
  data, facets, or all (Default).}
}
\value{
A data.frame, list, or message printed to console (using
pretty=TRUE).
}
\description{
This function does not search occurrence data, only
metadata on the datasets that contain occurrence data.
}
\examples{
\dontrun{
# Gets all datasets of type "OCCURRENCE".
dataset_search(type="OCCURRENCE")

# Gets all datasets tagged with keyword "france".
dataset_search(keyword="france")

# Fulltext search for all datasets having the word "amsterdam" somewhere in
# its metadata (title, description, etc).
dataset_search(query="amsterdam")

# Limited search
dataset_search(type="OCCURRENCE", limit=2)
dataset_search(type="OCCURRENCE", limit=2, start=10)

# Return just descriptions
dataset_search(type="OCCURRENCE", return="descriptions")

# Return metadata in a more human readable way (hard to manipulate though)
dataset_search(type="OCCURRENCE", pretty=TRUE)

# Search by country code. Lookup isocodes first, and use US for United States
isocodes[agrep("UNITED", isocodes$gbif_name),]
dataset_search(country="UNITED_STATES")

# Search by decade
dataset_search(decade=1980)

# Faceting
## just facets
dataset_search(facet="decade", facet_only=TRUE, facet_mincount="10")

## data and facets
dataset_search(facet="decade", facet_mincount="10")
}
}
\references{
\url{http://www.gbif.org/developer/summary}
}

