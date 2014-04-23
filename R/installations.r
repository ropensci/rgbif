#' Installations metadata.
#' 
#' @template all
#' @template occ
#' @import httr
#' @import plyr 
#' @param data The type of data to get. Default is all data. If not 'all', then one 
#'    or more of 'contact', 'endpoint', 'dataset', 'comment', 'deleted', 'nonPublishing'.
#' @param uuid UUID of the data node provider. This must be specified if data
#'    is anything other than 'all'.
#' @param query Query nodes. Only used when data='all'. Ignored otherwise.
#' @param identifier The value for this parameter can be a simple string or integer, 
#'    e.g. identifier=120. This parameter doesn't seem to be useful right now.
#' @param identifierType Used in combination with the identifier parameter to filter 
#'    identifiers by identifier type. See details. This parameter doesn't seem to 
#'    be useful right now.
#' @return A list.
#' @details
#' identifierType options:
#' 
#' \itemize{
#'  \item {DOI}
#'  \item {FTP}
#'  \item {GBIF_NODE}
#'  \item {GBIF_PARTICIPANT}
#'  \item {GBIF_PORTAL}
#'  \item {HANDLER}
#'  \item {LSID}
#'  \item {SOURCE_ID}
#'  \item {UNKNOWN}
#'  \item {URI}
#'  \item {URL}
#'  \item {UUID}
#' }
#' @export
#' @examples \dontrun{
#' installations()
#' installations(query="france")
#' installations(uuid="b77901f9-d9b0-47fa-94e0-dd96450aa2b4")
#' installations(data='contact', uuid="b77901f9-d9b0-47fa-94e0-dd96450aa2b4")
#' installations(data='contact', uuid="2e029a0c-87af-42e6-87d7-f38a50b78201")
#' installations(data='endpoint', uuid="b77901f9-d9b0-47fa-94e0-dd96450aa2b4")
#' installations(data='dataset', uuid="b77901f9-d9b0-47fa-94e0-dd96450aa2b4")
#' installations(data='deleted')
#' installations(data='deleted', limit=2)
#' installations(data=c('deleted','nonPublishing'), limit=2)
#' installations(identifierType='DOI', limit=2)
#' }
installations <- function(data = 'all', uuid = NULL, query = NULL, identifier=NULL,
                          identifierType=NULL, limit=20, start=NULL, callopts=list())
{
  args <- compact(list(q = query, limit=as.integer(limit), offset=start))
  
  data <- match.arg(data, choices=c('all', 'contact', 'endpoint', 'dataset', 
                                    'identifier', 'tag', 'machinetag', 'comment', 
                                    'deleted', 'nonPublishing'), several.ok=TRUE)
  
  # Define function to get data
  getdata <- function(x){
    if(!data %in% c('all','deleted', 'nonPublishing') && is.null(uuid))
      stop('You must specify a uuid if data does not equal "all" and 
       data does not equal one of deleted or nonPublishing')
    
    if(is.null(uuid)){
      if(x=='all'){
        url <- 'http://api.gbif.org/v0.9/installation'
      } else
      {
        url <- sprintf('http://api.gbif.org/v0.9/installation/%s', x)
      }
    } else
    {
      if(x=='all'){
        url <- sprintf('http://api.gbif.org/v0.9/installation/%s', uuid)
      } else
      {
        url <- sprintf('http://api.gbif.org/v0.9/installation/%s/%s', uuid, x)        
      }
    }
    temp <- GET(url, query=args, callopts)
    stop_for_status(temp)
    assert_that(temp$headers$`content-type`=='application/json')
    res <- content(temp, as = 'text', encoding = "UTF-8")
    RJSONIO::fromJSON(res, simplifyWithNames = FALSE)
  }
  
  # Get data
  if(length(data)==1){ out <- getdata(data) } else
  { out <- lapply(data, getdata) }
  
  return( out )
}
