#' Geta details on a dataset.
#' 
#' @template all
#' @export
#' 
#' @param uuid (character) One or more dataset UUIDs. See examples.
#' @param callopts Pass on options to GET.
#' 
#' @examples \dontrun{
#' dataset_metrics(uuid='3f8a1297-3259-4700-91fc-acc4170b27ce')
#' dataset_metrics(uuid='66dd0960-2d7d-46ee-a491-87b9adcfe7b1')
#' dataset_metrics(uuid=c('3f8a1297-3259-4700-91fc-acc4170b27ce',
#'    '66dd0960-2d7d-46ee-a491-87b9adcfe7b1'))
#' 
#' library("httr")
#' dataset_metrics(uuid='66dd0960-2d7d-46ee-a491-87b9adcfe7b1', verbose())
#' }

dataset_metrics <- function(uuid, callopts=list())
{
  getdata <- function(x){
    url <- sprintf('http://api.gbif.org/v1/dataset/%s/metrics', x)
    tt <- GET(url, callopts)
    stop_for_status(tt)
    assert_that(tt$headers$`content-type`=='application/json')
    res <- content(tt, as = 'text', encoding = "UTF-8")
    RJSONIO::fromJSON(res, simplifyWithNames = FALSE)
  }
  
  if(length(uuid)==1){ out <- getdata(uuid) } else
    { out <- lapply(uuid, getdata) }
  
  return( out )
}