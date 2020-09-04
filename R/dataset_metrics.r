#' Get details on a GBIF dataset.
#'
#' @export
#' @param uuid (character) One or more dataset UUIDs. See examples.
#' @template occ
#' @references <https://www.gbif.org/developer/registry#datasetMetrics>
#' @note Dataset metrics are only available for checklist type datasets.
#' @examples \dontrun{
#' dataset_metrics(uuid='863e6d6b-f602-4495-ac30-881482b6f799')
#' dataset_metrics(uuid='66dd0960-2d7d-46ee-a491-87b9adcfe7b1')
#' dataset_metrics(uuid=c('863e6d6b-f602-4495-ac30-881482b6f799',
#'    '66dd0960-2d7d-46ee-a491-87b9adcfe7b1'))
#' dataset_metrics(uuid='66dd0960-2d7d-46ee-a491-87b9adcfe7b1',
#'   curlopts = list(verbose=TRUE))
#' }

dataset_metrics <- function(uuid, curlopts = list()) {
  getdata <- function(x){
    url <- sprintf('%s/dataset/%s/metrics', gbif_base(), x)
    gbif_GET(url, NULL, FALSE, curlopts,
             "(only checklist datasets have metrics)")
  }
  if (length(uuid) == 1) {
    getdata(uuid)
  } else {
    lapply(uuid, getdata)
  }
}
