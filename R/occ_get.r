#' Get data for specific GBIF occurrences.
#' 
#' @template all
#' @import httr assertthat
#' @import plyr
#' @importFrom RJSONIO fromJSON
#' @param key Occurrence key
#' @param return One of data, hier, meta, or all. If 'data', a data.frame with the 
#'    data. 'hier' returns the classifications in a list for each record. meta 
#'    returns the metadata for the entire call. 'all' gives all data back in a list. Ignored if
#'    \code{verbatim=TRUE}.
#' @param verbatim Return verbatim object (TRUE) or cleaned up object (FALSE, default).
#' @param fields (character) Default ('minimal') will return just taxon name, key, latitude, and 
#'    longitute. 'all' returns all fields. Or specify each field you want returned by name, e.g.
#'    fields = c('name','decimalLatitude','altitude').
#' @param callopts Further arguments passed on to the \code{\link{GET}} request.
#' @return A data.frame or list of data.frame's.
#' @export
#' @examples \dontrun{
#' occ_get(key=766766824, return='data')
#' occ_get(key=766766824, 'hier')
#' occ_get(key=766766824, 'all')
#' 
#' # many occurrences
#' occ_get(key=c(101010,240713150,855998194,49819470), return='data')
#' 
#' # Verbatim data
#' occ_get(key=766766824, verbatim=TRUE)
#' occ_get(key=766766824, fields='all', verbatim=TRUE)
#' occ_get(key=766766824, fields=c('scientificName','lastCrawled','county'), verbatim=TRUE)
#' occ_get(key=c(766766824,620594291,766420684), verbatim=TRUE)
#' occ_get(key=c(766766824,620594291,766420684), fields='all', verbatim=TRUE)
#' occ_get(key=c(766766824,620594291,766420684), 
#'    fields=c('scientificName','decimalLatitude','basisOfRecord'), verbatim=TRUE)
#'    
#' # Pass in curl options
#' library("httr")
#' occ_get(key=766766824, callopts=verbose())
#' occ_get(key=766766824, callopts=timeout(1))
#' }

occ_get <- function(key=NULL, return='all', verbatim=FALSE, fields='minimal', callopts=list())
{
  assert_that(is.numeric(key))
  
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
    assert_that(temp$headers$`content-type`=='application/json')
    res <- content(temp, as = 'text', encoding = "UTF-8")
    RJSONIO::fromJSON(res, simplifyWithNames = FALSE)
  }
  
  # Get data
  if(length(key)==1){ out <- getdata(key) } else
  { out <- lapply(key, getdata) }
  
  # parse data
  if(verbatim){
    gbifparser_verbatim(out, fields=fields)
  } else
  {
    data <- gbifparser(out, fields=fields)
    
    if(return=='data'){
      if(length(key)==1){ data$data } else
      {
        ldfast(lapply(data, "[[", "data"))
      }
    } else
      if(return=='hier'){
        if(length(key)==1){ data$hierarch } else
        {
          ldfast(lapply(data, "[[", "hierarchy"))
        }
      } else
      { data }
  }
}