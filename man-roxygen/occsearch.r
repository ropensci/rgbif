#' @import httr
#' @importFrom plyr compact
#' @param taxonKey Scientific name 
#' @param boundingBox Location
#' @param collectorName Collector 
#' @param basisOfRecord Basis of record
#' @param datasetKey Dataset
#' @param date Collection date
#' @param catalogNumber Catalog number
#' @param callopts Pass on options to GET 
#' @param limit Number of records to return
#' @param start Record number to start at
#' @param minimal Return just taxon name, latitude, and longitute if TRUE, otherwise
#'    all data. Default is TRUE.
#' @param return One of data, hier, meta, or all. If data, a data.frame with the 
#'    data. hier returns the classifications in a list for each record. meta 
#'    returns the metadata for the entire call. all gives all data back in a list. 
#' @return A data.frame or list
#' @export