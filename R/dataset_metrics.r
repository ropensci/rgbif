#' Get details on a GBIF dataset.
#' 
#' @export
#' 
#' @param uuid (character) One or more dataset UUIDs. See examples.
#' @param ... Further named parameters, such as \code{query}, \code{path}, etc, passed on to 
#' \code{\link[httr]{modify_url}} within \code{\link[httr]{GET}} call. Unnamed parameters will 
#' be combined with \code{\link[httr]{config}}.
#' 
#' @references \url{http://www.gbif.org/developer/registry#datasetMetrics}
#' 
#' @examples \dontrun{
#' dataset_metrics(uuid='3f8a1297-3259-4700-91fc-acc4170b27ce')
#' dataset_metrics(uuid='66dd0960-2d7d-46ee-a491-87b9adcfe7b1')
#' dataset_metrics(uuid=c('3f8a1297-3259-4700-91fc-acc4170b27ce',
#'    '66dd0960-2d7d-46ee-a491-87b9adcfe7b1'))
#' 
#' library("httr")
#' dataset_metrics(uuid='66dd0960-2d7d-46ee-a491-87b9adcfe7b1', config=verbose())
#' }

dataset_metrics <- function(uuid, ...) {
  getdata <- function(x){
    url <- sprintf('%s/dataset/%s/metrics', gbif_base(), x)
    gbif_GET(url, list(), FALSE, ...)
  }
  if(length(uuid) == 1) {
    getdata(uuid) 
  } else {
    lapply(uuid, getdata)
  }
}
