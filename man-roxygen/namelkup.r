#' @param query Query term(s) for full text search.
#' @param canonical_name Canonical name
#' @param class Taxonomic class
#' @param description Description
#' @param family Taxonomic family
#' @param genus Taxonomic genus
#' @param kingdom Taxonomic kingdom
#' @param order Taxonomic order
#' @param phylum Taxonomic phylum
#' @param scientificName Scientific name
#' @param species Species name
#' @param subgenus Taxonomic subgenus
#' @param rank Taxonomic rank
#' @param vernacularName Vernacular (common) name
#' @param limit Number of records to return
#' @param callopts Further arguments passed on to the \code{\link{GET}} request.
#' @param verbose If TRUE, all data is returned as a list for each element. If 
#'    FALSE (default) a subset of the data that is thought to be most essential is
#'    organized into a data.frame.
#' @param return One of data, hier, meta, or all. If data, a data.frame with the 
#'    data. hier returns the classifications in a list for each record. meta 
#'    returns the metadata for the entire call. all gives all data back in a list. 