#' @param rank (character) Taxonomic rank. Filters by taxonomic rank as
#' one of: CLASS, CULTIVAR, CULTIVAR_GROUP, DOMAIN, FAMILY, FORM, GENUS,
#' INFORMAL, INFRAGENERIC_NAME, INFRAORDER, INFRASPECIFIC_NAME,
#' INFRASUBSPECIFIC_NAME, KINGDOM, ORDER, PHYLUM, SECTION, SERIES, SPECIES,
#' STRAIN, SUBCLASS, SUBFAMILY, SUBFORM, SUBGENUS, SUBKINGDOM, SUBORDER,
#' SUBPHYLUM, SUBSECTION, SUBSERIES, SUBSPECIES, SUBTRIBE, SUBVARIETY,
#' SUPERCLASS, SUPERFAMILY, SUPERORDER, SUPERPHYLUM, SUPRAGENERIC_NAME,
#' TRIBE, UNRANKED, VARIETY
#' @param datasetKey (character) Filters by the dataset's key (a uuid). Must
#' be length=1
#' @param key (numeric or character) A GBIF key for a taxon
#' @param name (character) Filters by a case insensitive, canonical namestring,
#' e.g. 'Puma concolor'
#' @param data (character) Specify an option to select what data is returned.
#' See Description below.
#' @param language (character) Language, default is english
#' @param shortname (character) A short name for a dataset - it may
#' not do anything
#' @param uuid (character) A dataset key
#'
#' @section Repeat parameter inputs:
#' These parameters used to accept many inputs, but no longer do:
#'
#' \itemize{
#'  \item \strong{rank}
#'  \item \strong{name}
#'  \item \strong{langugae}
#'  \item \strong{datasetKey}
#' }
#'

