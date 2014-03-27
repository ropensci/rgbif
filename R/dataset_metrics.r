#' Geta details on a dataset.
#' 
#' @template all
#' @import httr
#' @import plyr
#' @export
#' @param uuid A dataset UUID.
#' @param callopts Pass on options to GET.
#' @description 
#' You should be able to pass in more than one uuid to this function, but I have
#' not yet found more than the one uuid below in the example that actually has
#' data available.
#' @examples \dontrun{
#' dataset_metrics(uuid='3f8a1297-3259-4700-91fc-acc4170b27ce')
#' }

dataset_metrics <- function(uuid, callopts=list())
{
  # Define function to get data
  getdata <- function(x){
    url <- sprintf('http://api.gbif.org/v0.9/dataset_metrics/%s', x)
    tt <- GET(url, callopts)
    stop_for_status(tt)
    assert_that(tt$headers$`content-type`=='application/json')
    res <- content(tt, as = 'text', encoding = "UTF-8")
    RJSONIO::fromJSON(res, simplifyWithNames = FALSE)
  }
  
  # Get data
  if(length(uuid)==1){ out <- getdata(uuid) } else
    { out <- lapply(uuid, getdata) }
  
  out
}