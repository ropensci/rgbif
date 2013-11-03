#' Get data for specific GBIF occurrences.
#' 
#' @template all
#' @import httr
#' @import plyr
#' @param key Occurrence key
#' @param return One of data, hier, meta, or all. If data, a data.frame with the 
#'    data. hier returns the classifications in a list for each record. meta 
#'    returns the metadata for the entire call. all gives all data back in a list. 
#' @param verbatim Return verbatim object (TRUE) or cleaned up object (FALSE, default).
#' @param minimal Return just taxon name, latitude, and longitute if TRUE, 
#'    otherwise all data. Default is TRUE.
#' @param callopts Further arguments passed on to the \code{\link{GET}} request.
#' @return A data.frame or list.
#' @export
#' @examples \dontrun{
#' occ_get(key=773433533, return='data')
#' occ_get(key=773433533, 'hier')
#' occ_get(key=773433533, 'all')
#' 
#' # many occurrences
#' occ_get(key=c(773433533,101010,240713150,855998194,49819470), return='data')
#' 
#' # Verbatim data
#' occ_get(key=c(773433533,766766824,620594291,766420684), verbatim=TRUE)
#' }
occ_get <- function(key=NULL, return='all', verbatim=FALSE, minimal=TRUE, callopts=list())
{
  if(!is.numeric(key))
    stop('key must be numeric')
  
  # Define function to get data
  getdata <- function(x){
    if(verbatim){
      url <- sprintf('http://api.gbif.org/v0.9/occurrence/%s/verbatim', x)
    } else
    {
      url <- sprintf('http://api.gbif.org/v0.9/occurrence/%s', x)
    }
    temp <- GET(url, callopts)
    stop_for_status(temp)
    content(temp)
  }
  
  # Get data
  if(length(key)==1){ out <- getdata(key) } else
  { out <- lapply(key, getdata) }
  
  # parse data
  if(verbatim){
    gbifparser_verbatim(out, minimal=minimal)
  } else
  {
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
}