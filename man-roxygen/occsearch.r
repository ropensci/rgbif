#' @param taxonKey Taxonomic key. This is the GBIF backbone taxonomic key for a 
#'    single taxon. You can pass many keys by passing occ_search in a call to an 
#'    lapply-family function (see last example below).
#' @param country Country, a two letter ISO country code. See here
#'    \url{http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2}
#' @param boundingBox Location
#' @param collectorName Collector 
#' @param basisOfRecord Basis of record
#' @param datasetKey Dataset
#' @param date Collection date
#' @param catalogNumber Catalog number
#' @param minimal Return just taxon name, latitude, and longitute if TRUE, otherwise
#'    all data. Default is TRUE.
#' @param return One of data, hier, meta, or all. If data, a data.frame with the 
#'    data. hier returns the classifications in a list for each record. meta 
#'    returns the metadata for the entire call. all gives all data back in a list. 
#' @return A data.frame or list
#' @description
#' Note that you can pass in a vector to one of taxonkey, datasetKey, and 
#' catalogNumber parameters in a function call, but not a vector >1 of the three 
#' parameters at the same time
#' 
#' Hierarchies: hierarchies are returned wih each occurrence object. There is no
#' option no to return them from the API. However, within the \code{occ_search}
#' function you can select whether to return just hierarchies, just data, all of 
#' data and hiearchies and metadata, or just metadata. If all hierarchies are the 
#' same we just return one for you. 
#' 
#' Data: By default only three data fields are returned: name (the species name),
#' latitude, and longitude. Set parameter minimal=FALSE if you want more data.
#' 
#' Nerds: You can pass parameters not defined in this function into the call to 
#' the GBIF API to control things about the call itself using the \code{callopts} 
#' function. See an example below that passes in the \code{verbose} function to 
#' get details on the http call.
#' 
#' Why can't I search by species name? In the previous GBIF API and the version
#' of rgbif that wrapped that API, you could search the equivalent of this function
#' with a species name, which was convenient. However, names are messy right. So 
#' it sorta makes sense to sort out the species key numbers you want exactly, 
#' and then get your occurrence data with this function. UPDATE - GBIF folks say 
#' that they are planning to allow using actual scientific names in this API endpoint, 
#' so eventually it will happen.