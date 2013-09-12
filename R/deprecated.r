#' The density web service provides access to records showing the density
#'    of occurrence records from the GBIF Network by one-degree cell.
#'
#' Note: TThis function is deprecated. There is no longer a similar function.
#' @export
density_spplist <- function()
{
  message("This function is deprecated. There is no longer a similar function.")
}

#' The density web service provides access to records showing the density
#'    of occurrence records from the GBIF Network by one-degree cell.
#'
#' Note: This function is deprecated. There is no longer a similar functio
#' @export
densitylist <- function() 
{
  message("This function is deprecated. There is no longer a similar function.")
}

#' Counts taxon concept records matching a range of filters.
#'
#' Note: This function is deprecated. See \code{occ_count}
#' @export
occurrencecount <- function() 
{  
  message("This function is deprecated. See ?occ_count")
}

#' Returns summary counts of occurrence records by one-degree cell for a single
#'    taxon, country, dataset, data publisher or data network.
#'
#' Note: Function deprecated.
#' @export
occurrencedensity <- function()
{
  message("Function deprecated.")
}

#' Get individual records for a given occurrence record.
#'
#' Note: This function is deprecated. See \code{occ_get}
#' @export
occurrenceget <- function()
{
  message("This function is deprecated. See ?occ_get")
}

#' Occurrencelist searches for taxon concept records matching a range of filters.
#'
#' Note: This function is deprecated. See \code{occ_search}
#' @export
occurrencelist <- function() 
{	
  message("This function is deprecated. See ?occ_search")
}

#' Occurrencelist_all carries out an occurrencelist query for a single name and all its name variants according to GBIF's name matching.
#'
#' Note: This function is deprecated. See \code{occ_search}
#' @export
occurrencelist_all <- function()
{  
  message("This function is deprecated. See ?occ_search")
}

#' occurrencelist_many is the same as occurrencelist, but takes in a vector of species names.
#'
#' Note: his function is deprecated. See \code{occ_search}
#' @export
occurrencelist_many <- function() 
{    
  message("This function is deprecated. See ?occ_search")
}

#' Get data providers and their unique keys.
#'
#' Note: This function is deprecated. See \code{datasets}, \code{networks}, \code{nodes}, and \code{organizations}
providers <- function()
{
  message("This function is deprecated. See ?datasets, ?networks, ?nodes, and ?organizations")
}

#' Get data resources and their unique keys.
#'
#' Note: This function is deprecated. See \code{datasets}, \code{networks}, \code{nodes}, and \code{organizations}
#' @export
resources <- function()
{
  message("This function is deprecated. See ?datasets, ?networks, ?nodes, and ?organizations")
}

#' Search by taxon to retrieve number of records in GBIF.
#'
#' Note: This function is deprecated. See \code{occ_count}.
#' @export
taxoncount <- function()
{
  message("This function is deprecated. See ?occ_count.")
}

#' Get taxonomic information on a specific taxon or taxa in GBIF by their taxon concept keys.
#'
#' Note: This function is deprecated. See \code{name_lookup}.
#' @export
taxonget <- function()
{
  message("This function is deprecated. See ?name_lookup.")
}

#' Search for taxa in GBIF.
#'
#' Note: This function is deprecated. See \code{name_lookup} for names across all of GBIF and \code{gbif_lookup} for names only in the GBIF backbone taxonomy
#' @export
taxonsearch <- function()
{
  message("This function is deprecated. See ?name_lookup for names across all of GBIF and ?gbif_lookup for names only in the GBIF backbone taxonomy")
}