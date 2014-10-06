#' The density web service provides access to records showing the density
#'    of occurrence records from the GBIF Network by one-degree cell.
#'
#' This function is defunct
#'
#' @keywords internal
density_spplist <- function(...)
{
  .Defunct(msg="This function is defunct. There is no longer a similar function.")
}

#' The density web service provides access to records showing the density
#'     of occurrence records from the GBIF Network by one-degree cell.
#'
#' This function is defunct.
#'
#' @keywords internal
densitylist <- function(...)
{
  .Defunct(msg="This function is defunct. There is no longer a similar function.")
}

#' Counts taxon concept records matching a range of filters.
#'
#' This function is defunct.
#'
#' @keywords internal
#' @seealso occ_count
occurrencecount <- function(...)
{
  .Defunct(new="occ_count", package="rgbif", msg="This function is defunct. See ?occ_count")
}

#' Returns summary counts of occurrence records by one-degree cell for a single
#'   	taxon, country, dataset, data publisher or data network.
#'
#' This function is defunct.
#'
#' @keywords internal
occurrencedensity <- function()
{
  .Defunct(new="densitylist", package="rgbif", msg="This function is defunct. See ?densitylist")
}

#' Get individual records for a given occurrence record.
#'
#' This function is defunct.
#'
#' @keywords internal
#' @seealso occ_get
occurrenceget <- function(...)
{
  .Defunct(new="occ_get", package="rgbif", msg="This function is defunct. See ?occ_get")
}

#' Occurrencelist searches for taxon concept records matching a range of filters.
#'
#' This function is defunct.
#'
#' @keywords internal
#' @seealso occ_search
occurrencelist <- function(...)
{
  .Defunct(new="occ_search", package="rgbif", msg="This function is defunct. See ?occ_search")
}

#' Occurrencelist_all carries out an occurrencelist query for a single name and
#' all its name variants according to GBIF's name matching.
#'
#' This function is defunct.
#'
#' @keywords internal
#' @seealso occ_search
occurrencelist_all <- function(...)
{
  .Defunct(new="occ_search", package="rgbif", msg="This function is defunct. See ?occ_search")
}

#' occurrencelist_many is the same as occurrencelist, but takes in a vector
#' of species names.
#'
#' This function is defunct.
#'
#' @keywords internal
#' @seealso occ_search
occurrencelist_many <- function(...)
{
  .Defunct(new="occ_search", package="rgbif", msg="This function is defunct. See ?occ_search")
}

#' Get data providers and their unique keys.
#'
#' This function is defunct.
#'
#' @keywords internal
#' @seealso networks organizations datasets
providers <- function(...)
{
  .Defunct(new="networks", package="rgbif", msg="This function is defunct. See ?networks, ?organizations, and ?datasets")
}

#' Get data resources and their unique keys.
#'
#' This function is defunct.
#'
#' @keywords internal
#' @seealso networks organizations datasets
resources <- function(...)
{
  .Defunct(new="networks", package="rgbif", msg="This function is defunct. See ?networks, ?organizations, and ?datasets")
}

#' Search by taxon to retrieve number of records in GBIF.
#'
#' This function is defunct.
#'
#' @keywords internal
#' @seealso occ_count
taxoncount <- function(...)
{
  .Defunct(new="occ_count", package="rgbif", msg="This function is defunct. See ?occ_count")
}

#' Get taxonomic information on a specific taxon or taxa in GBIF by their taxon
#'   	concept keys.
#'
#' This function is defunct.
#'
#' @keywords internal
#' @seealso name_usage
taxonget <- function(...)
{
  .Defunct(new="name_usage", package="rgbif", msg="This function is defunct. See ?name_usage")
}


#' Search for taxa in GBIF.
#'
#' This function is defunct.
#'
#' @keywords internal
#' @seealso occ_search
taxonsearch <- function(...)
{
  .Defunct(new="name_lookup", package="rgbif", msg="This function is defunct. See ?name_lookup")
}

#' Make a simple map to visualize GBIF data density data
#'
#' This function is defunct.
#'
#' @keywords internal
#' @seealso gbifmap
gbifmap_dens <- function(...)
{
  .Defunct(new="gbifmap", package="rgbif", msg="This function is defunct. See ?gbifmap")
}

#' Make a simple map to visualize GBIF point data.
#'
#' This function is defunct.
#'
#' @keywords internal
#' @seealso gbifmap
gbifmap_list <- function(...)
{
  .Defunct(new="gbifmap", package="rgbif", msg="This function is defunct. See ?gbifmap")
}

#' Get data.frame from occurrencelist, occurrencelist_many, or densitylist.
#'
#' This function is defunct.
#'
#' @keywords internal
gbifdata <- function(...) UseMethod("gbifdata")

#' @keywords internal
gbifdata.gbiflist <- function(input, coordinatestatus=FALSE, minimal=FALSE, ...)
{
  .Defunct(msg="This function is defunct.")
}

#' @keywords internal
gbifdata.gbifdens <- function(input, ...)
{
  .Defunct(msg="This function is defunct.")
}

#' @keywords internal
gbifdata.gbiflist_na <- function(input, ...)
{
  .Defunct(msg="This function is defunct.")
}

#' @keywords internal
print.gbifdens <- function(...){
  .Defunct(msg="This function is defunct.")
}

#' @keywords internal
print.gbiflist <- function(...){
  .Defunct(msg="This function is defunct.")
}

#' @keywords internal
print.gbiflist_na <- function(...){
  .Defunct(msg="This function is defunct.")
}

#' Style a data.frame prior to converting to geojson.
#'
#' This function is defunct.  See the package spocc for similar functionality.
#'
#' @keywords internal

stylegeojson <- function(...)
{
  .Defunct(msg="This function is defunct. There is no longer a similar function. See the package spocc for similar functionality.")
}

#' Convert spatial data files to GeoJSON from various formats.
#'
#' This function is defunct.  See the package togeojson for similar functionality.
#'
#' @keywords internal

togeojson <- function(...)
{
  .Defunct(msg="This function is defunct. There is no longer a similar function. See the package togeojson for similar functionality.")
}

#' Post a file as a Github gist
#'
#' This function is defunct.  See the package gistr for similar functionality.
#'
#' @keywords internal

gist <- function(...)
{
  .Defunct(msg="This function is defunct. There is no longer a similar function. See the package gistr for similar functionality.")
}

#' Function that takes a list of files and creates payload for API
#'
#' This function is defunct.  See the package gistr for similar functionality.
#'
#' @keywords internal
create_gist <- function(...){
  .Defunct(msg="This function is defunct. There is no longer a similar function. See the package gistr for similar functionality.")
}

#' Get Github credentials from use in console
#'
#' This function is defunct.  See the package gistr for similar functionality.
#'
#' @keywords internal
get_credentials = function(...){
  .Defunct(msg="This function is defunct. There is no longer a similar function. See the package gistr for similar functionality.")
}
