#' @param query Query term(s) for full text search.  The value for this parameter
#'    can be a simple word or a phrase. Wildcards can be added to the simple word
#'    parameters only, e.g. q=*puma*
#' @param country NOT YET IMPLEMENTED. Filters by country as given in isocodes$gbif_name,
#'    e.g. country=CANADA.
#' @param type Type of dataset, options include OCCURRENCE, etc.
#' @param keyword Keyword to search by. Datasets can be tagged by keywords, which
#'    you can search on. The search is done on the merged collection of tags, the
#'    dataset keywordCollections and temporalCoverages. SEEMS TO NOT BE WORKING
#'    ANYMORE AS OF 2016-09-02.
#' @param owningOrg Owning organization. A uuid string. See \code{\link{organizations}}
#' @param publishingOrg Publishing organization. A uuid string. See \code{\link{organizations}}
#' @param hostingOrg Hosting organization. A uuid string. See \code{\link{organizations}}
#' @param publishingCountry Publishing country. See options at isocodes$gbif_name
#' @param decade Decade, e.g., 1980. Filters datasets by their temporal coverage
#'    broken down to decades. Decades are given as a full year, e.g. 1880, 1960, 2000,
#'    etc, and will return datasets wholly contained in the decade as well as those
#'    that cover the entire decade or more. Facet by decade to get the break down,
#'    e.g. /search?facet=DECADE&facet_only=true (see example below)
#' @param pretty Print informative metadata using \code{\link{cat}}. Not easy to
#'    manipulate output though.
#' @return A data.frame, list, or message printed to console (using pretty=TRUE).
