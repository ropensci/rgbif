#' Suggest up to 20 name usages.
#'
#' A quick and simple autocomplete service that returns up to 20 name
#' usages by doing prefix matching against the scientific name. Results
#' are ordered by relevance.
#'
#' @template otherlimstart
#' @template occ
#' @export
#' @references <https://www.gbif.org/developer/species#searching>
#'
#' @param q (character, required) Simple search parameter. The value for
#' this parameter can be a simple word or a phrase. Wildcards can be added to
#' the simple word parameters only, e.g. q=*puma*
#' @param datasetKey (character) Filters by the checklist dataset key (a uuid,
#' see examples)
#' @param rank (character) A taxonomic rank. One of class, cultivar,
#' cultivar_group, domain, family, form, genus, informal, infrageneric_name,
#' infraorder, infraspecific_name, infrasubspecific_name, kingdom, order,
#' phylum, section, series, species, strain, subclass, subfamily, subform,
#' subgenus, subkingdom, suborder, subphylum, subsection, subseries,
#' subspecies, subtribe, subvariety, superclass, superfamily, superorder,
#' superphylum, suprageneric_name, tribe, unranked, or variety.
#' @param fields (character) Fields to return in output data.frame (simply
#' prunes columns off)
#'
#' @section Repeat parmeter inputs:
#' Some parameters can take many inputs, and treated as 'OR' (e.g., a or b or
#' c). The following take many inputs:
#' 
#' - **rank**
#' - **datasetKey**
#'
#' see also [many-values]
#'
#' @return A list, with two elements `data` (tibble) and `hierarchy` (list of
#' data.frame's). If 'higherClassificationMap' is one of the `fields` requested,
#' then `hierarchy` is a list of data.frame's; if not included, `hierarchy`
#' is an empty list.
#'
#' @examples \dontrun{
#' name_suggest(q='Puma concolor')
#' name_suggest(q='Puma')
#' name_suggest(q='Puma', rank="genus")
#' name_suggest(q='Puma', rank="subspecies")
#' name_suggest(q='Puma', rank="species")
#' name_suggest(q='Puma', rank="infraspecific_name")
#'
#' name_suggest(q='Puma', limit=2)
#' name_suggest(q='Puma', fields=c('key','canonicalName'))
#' name_suggest(q='Puma', fields=c('key','canonicalName',
#'   'higherClassificationMap'))
#'
#' # Some parameters accept many inputs, treated as OR
#' name_suggest(rank = c("family", "genus"))
#' name_suggest(datasetKey = c("73605f3a-af85-4ade-bbc5-522bfb90d847",
#'   "d7c60346-44b6-400d-ba27-8d3fbeffc8a5"))
#'
#' # If 'higherClassificationMap' in fields, a list is returned
#' name_suggest(q='Puma', fields=c('key','higherClassificationMap'))
#'
#' # Pass on curl options
#' name_suggest(q='Puma', limit=200, curlopts = list(verbose=TRUE))
#' }
name_suggest <- function(q=NULL, datasetKey=NULL, rank=NULL, fields=NULL,
                         start=NULL, limit=100, curlopts = list()) {

  url <- paste0(gbif_base(), '/species/suggest')
  rank <- as_many_args(rank)
  datasetKey <- as_many_args(datasetKey)
  args <- rgbif_compact(list(q = q, offset = start, limit = limit))
  args <- c(args, rank, datasetKey)
  tt <- gbif_GET(url, args, FALSE, curlopts)

  if (is.null(fields)) {
    toget <- c("key","canonicalName","rank")
  } else {
    toget <- fields
  }
  matched <- sapply(toget, function(x) x %in% suggestfields())
  if (!all(matched)) {
    stop(sprintf("the fields %s are not valid",
                 paste0(names(matched[matched == FALSE]), collapse = ",")))
  }
  if (any(toget %in% "higherClassificationMap")) {
    for (i in seq_along(tt)) {
      temp <- tt[[i]]
      temp <- temp$higherClassificationMap
      tt[[i]][['higherClassificationMap']] <-
        data.frame(id = names(temp),
                   name = do.call(c, unname(temp)), stringsAsFactors = FALSE)
    }
    out <- lapply(tt, function(x) x[names(x) %in% toget])
    df <- setdfrbind(lapply(out, function(x) {
      data.frame(x[ !names(x) %in% "higherClassificationMap" ],
                 stringsAsFactors = FALSE)
    }))
    hier <- sapply(tt, function(x) x[ names(x) %in% "higherClassificationMap" ])
    hier <- unname(hier)
    names(hier) <- vapply(tt, "[[", numeric(1), "key")
    df <- tibble::as_tibble(df)
  } else {
    out <- lapply(tt, function(x) x[names(x) %in% toget])
    out <- data.table::setDF(data.table::rbindlist(out,
                                                 use.names = TRUE, fill = TRUE))
    df <- tibble::as_tibble(out)
    hier <- list()
  }

  result <- list(data = tibble::as_tibble(df), hierarchy = hier)
  args <- c(args, fields = toget)
  structure(result, class = "gbif", type = "single", args = args)
}

#' Fields available in gbif_suggest function
#' @export
#' @keywords internal
suggestfields <- function(){
  c("key","datasetTitle","datasetKey","nubKey","parentKey","parent",
    "kingdom","phylum","class","order","family","genus","species",
    "kingdomKey","phylumKey","classKey","orderKey","familyKey","genusKey",
    "speciesKey","species","canonicalName","authorship",
    "accordingTo","nameType","taxonomicStatus","rank","numDescendants",
    "numOccurrences","sourceId","nomenclaturalStatus","threatStatuses",
    "synonym","higherClassificationMap")
}
