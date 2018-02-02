#' @param rank (character) Taxonomic rank. Filters by taxonomic rank as
#' one of: CLASS, CULTIVAR, CULTIVAR_GROUP, DOMAIN, FAMILY, FORM, GENUS,
#' INFORMAL, INFRAGENERIC_NAME, INFRAORDER, INFRASPECIFIC_NAME,
#' INFRASUBSPECIFIC_NAME, KINGDOM, ORDER, PHYLUM, SECTION, SERIES, SPECIES,
#' STRAIN, SUBCLASS, SUBFAMILY, SUBFORM, SUBGENUS, SUBKINGDOM, SUBORDER,
#' SUBPHYLUM, SUBSECTION, SUBSERIES, SUBSPECIES, SUBTRIBE, SUBVARIETY,
#' SUPERCLASS, SUPERFAMILY, SUPERORDER, SUPERPHYLUM, SUPRAGENERIC_NAME,
#' TRIBE, UNRANKED, VARIETY
#' @param datasetKey (character) Filters by the dataset's key (a uuid)
#' @param uuid (character) A uuid for a dataset. Should give exact same
#' results as datasetKey.
#' @param key (numeric or character) A GBIF key for a taxon
#' @param name (character) Filters by a case insensitive, canonical namestring,
#' e.g. 'Puma concolor'
#' @param data (character) Specify an option to select what data is returned.
#' See Description below.
#' @param language (character) Language, default is english
#' @param sourceId (numeric) Filters by the source identifier. Not used
#' right now.
#' @param shortname (character) A short name..need more info on this?
#'
#' @section Repeat parmeter inputs:
#' Some parameters can tak emany inputs, and treated as 'OR' (e.g., a or b or
#' c). The following take many inputs:
#' \itemize{
#'  \item \strong{rank}
#'  \item \strong{datasetKey}
#'  \item \strong{uuid}
#'  \item \strong{name}
#'  \item \strong{langugae}
#' }
#'
#' see also \code{\link{many-values}}

