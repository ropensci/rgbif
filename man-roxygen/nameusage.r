#' @param rank Taxonomic rank. Filters by taxonomic rank as one of:
#' 		CLASS, CULTIVAR, CULTIVAR_GROUP, DOMAIN, FAMILY, FORM, GENUS, INFORMAL, 
#'   	INFRAGENERIC_NAME, INFRAORDER, INFRASPECIFIC_NAME, INFRASUBSPECIFIC_NAME, 
#'     KINGDOM, ORDER, PHYLUM, SECTION, SERIES, SPECIES, STRAIN, SUBCLASS, SUBFAMILY, 
#'     SUBFORM, SUBGENUS, SUBKINGDOM, SUBORDER, SUBPHYLUM, SUBSECTION, SUBSERIES, 
#'     SUBSPECIES, SUBTRIBE, SUBVARIETY, SUPERCLASS, SUPERFAMILY, SUPERORDER, 
#'     SUPERPHYLUM, SUPRAGENERIC_NAME, TRIBE, UNRANKED, VARIETY
#' @param datasetKey Filters by the dataset's key (a uuid)
#' @param key A GBIF key for a taxon
#' @param name Filters by a case insensitive, canonical namestring, e.g. 'Puma concolor'
#' @param data Specify an option to select what data is returned. See Description
#'    below.
#' @param language Language, default is english
#' @param sourceId Filters by the source identifier
#' @param uuid A uuid for a dataset.
#' @param shortname A short name..need more info on this?