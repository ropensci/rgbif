#' Geta details on a dataset.
#' 
#' @template all
#' @importFrom httr GET content verbose
#' @importFrom plyr compact
#' @param uuid A dataset UUID.
#' @param callopts Pass on options to GET.
#' @examples \dontrun{
#' dataset_metrics(uuid='3f8a1297-3259-4700-91fc-acc4170b27ce')
#' }
#' @export
dataset_metrics <- function(uuid, callopts=list())
{
  # Define function to get data
  getdata <- function(x){
    url <- sprintf('http://api.gbif.org/dataset_metrics/%s', x)
    content(GET(url, callopts))
  }
  
  # Get data
  if(length(uuid)==1){ out <- getdata(uuid) } else
    { out <- lapply(uuid, getdata) }
  
  out
}