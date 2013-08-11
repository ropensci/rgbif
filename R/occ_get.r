#' Get data for a GBIF occurrence.
#' 
#' @import httr
#' @importFrom plyr compact
#' @param key Occurrence key
#' @param return One of data, hier, meta, or all. If data, a data.frame with the 
#'    data. hier returns the classifications in a list for each record. meta 
#'    returns the metadata for the entire call. all gives all data back in a list. 
#' @param minimal Return just taxon name, latitude, and longitute if TRUE, otherwise
#'    all data. Default is TRUE.
#' @param callopts Pass on options to GET 
#' @export
#' @examples \dontrun{
#' occ_get(key=773433533, 'data')
#' occ_get(key=773433533, 'hier')
#' occ_get(key=773433533, 'all')
#' 
#' # many occurrences
#' occ_get(key=c(773433533,767047552,756083505,754201727,686550585), 'data')
#' }
occ_get <- function(key=NULL, return='all', minimal=TRUE, callopts=list())
{
  if(!is.numeric(key))
    stop('key must be numeric')
  
  # Define function to get data
  getdata <- function(x){
    url <- sprintf('http://api.gbif.org/occurrence/%s', x)
    content(GET(url, callopts))
  }
  
  # Get data
  if(length(key)==1){ out <- getdata(key) } else
  { out <- lapply(key, getdata) }
  
  # parse data
  data <- gbifparser(out, minimal=minimal)
  
  if(return=='data'){
    if(length(key)==1){ data$data } else
    {
      ldfast(lapply(data, "[[", "data"))
    }
  } else
    if(return=='hier'){
      if(length(key)==1){ data$hierarch } else
      {
        ldfast(lapply(data, "[[", "hierarch"))
      }
    } else
    { data }
}
# http://api.gbif.org/occurrence/773433533