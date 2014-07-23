#' Installations metadata.
#' 
#' @template all
#' @template occ
#' @import httr
#' @import plyr 
#' @export
#' 
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
#' 
#' @return A list.
#' @details
#' identifierType options:
#' 
#' \itemize{
#'  \item {DOI} No description.
#'  \item {FTP} No description.
#'  \item {GBIF_NODE} Identifies the node (e.g: 'DK' for Denmark, 'sp2000' for Species 2000).
#'  \item {GBIF_PARTICIPANT} Participant identifier from the GBIF IMS Filemaker system.
#'  \item {GBIF_PORTAL} Indicates the identifier originated from an auto_increment column in the 
#'  portal.data_provider or portal.data_resource table respectively.
#'  \item {HANDLER} No description.
#'  \item {LSID} Reference controlled by a separate system, used for example by DOI.
#'  \item {SOURCE_ID} No description.
#'  \item {UNKNOWN} No description.
#'  \item {URI} No description.
#'  \item {URL} No description.
#'  \item {UUID} No description.
#' }
#' 
#' @examples \dontrun{
#' installations()
#' installations(query="france")
#' installations(uuid="b77901f9-d9b0-47fa-94e0-dd96450aa2b4")
#' installations(data='contact', uuid="b77901f9-d9b0-47fa-94e0-dd96450aa2b4")
#' installations(data='contact', uuid="2e029a0c-87af-42e6-87d7-f38a50b78201")
#' installations(data='endpoint', uuid="b77901f9-d9b0-47fa-94e0-dd96450aa2b4")
#' installations(data='dataset', uuid="b77901f9-d9b0-47fa-94e0-dd96450aa2b4")
#' installations(data='deleted')
#' installations(data='deleted', limit2=2)
#' installations(data=c('deleted','nonPublishing'), limit=2)
#' installations(identifierType='DOI', limit=2)
#' }

installations <- function(data = 'all', uuid = NULL, query = NULL, identifier=NULL,
                          identifierType=NULL, limit=20, start=NULL, callopts=list())
{
  args <- rgbif_compact(list(q = query, limit=as.integer(limit), offset=start))
  
  data <- match.arg(data, choices=c('all', 'contact', 'endpoint', 'dataset', 
                                    'identifier', 'tag', 'machineTag', 'comment', 
                                    'deleted', 'nonPublishing'), several.ok=TRUE)
  
  # Define function to get data
  getdata <- function(x){
    if(!data %in% c('all','deleted', 'nonPublishing') && is.null(uuid))
      stop('You must specify a uuid if data does not equal "all" and 
       data does not equal one of deleted or nonPublishing')
    
    if(is.null(uuid)){
      if(x=='all'){
        url <- 'http://api.gbif.org/v1/installation'
      } else
      {
        url <- sprintf('http://api.gbif.org/v1/installation/%s', x)
      }
    } else
    {
      if(x=='all'){
        url <- sprintf('http://api.gbif.org/v1/installation/%s', uuid)
      } else
      {
        url <- sprintf('http://api.gbif.org/v1/installation/%s/%s', uuid, x)        
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
