#' Dataset metadata.
#' 
#' @import httr
#' @importFrom plyr compact
#' @param data The type of data to get. Default is all data.
#' @param uuid UUID of the data node provider. This must be specified if data
#'    is anything other than 'all'.
#' @param query Query nodes. Only used when data='all'
#' @param isocode A 2 letter country code. Only used if data='country'.    
#' @param callopts Further args passed on to GET.
#' @export
#' @examples \dontrun{
#' datasets()
#' datasets(uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
#' datasets(data='contact', uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
#' datasets(data='metadata', uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
#' datasets(data='metadata', uuid="a6998220-7e3a-485d-9cd6-73076bd85657", id=598)
#' datasets(data=c('deleted','duplicate'))
#' }
datasets <- function(data = 'all', uuid = NULL, query = NULL, id = NULL, callopts=list())
{
  args <- compact(list(q = query))
  
  data <- match.arg(data, choices=c('all', 'organization', 'contact', 'endpoint', 
                                    'identifier', 'tag', 'machinetag', 'comment', 
                                    'constituents', 'document', 'metadata', 
                                    'deleted', 'duplicate', 'subDataset', 
                                    'withNoEndpoint'), several.ok=TRUE)
  
  # Define function to get data
  getdata <- function(x){
    if(!data %in% c('all','deleted','duplicate','subDataset','withNoEndpoint') && is.null(uuid))
      stop('You must specify a uuid if data does not equal all and 
       data does not equal of deleted, duplicate, subDataset, or withNoEndpoint')
    
    if(is.null(uuid)){
      if(x=='all'){
        url <- 'http://api.gbif.org/dataset'
      } else
      {
        if(!is.null(id) && x=='metadata'){
          url <- sprintf('http://api.gbif.org/dataset/metadata/%s/document', id)
        } else
        {
          url <- sprintf('http://api.gbif.org/dataset/%s', x)          
        }
      }
    } else
    {
      if(x=='all'){
        url <- sprintf('http://api.gbif.org/dataset/%s', uuid)
      } else
      {
        url <- sprintf('http://api.gbif.org/dataset/%s/%s', uuid, x)        
      }
    }
    content(GET(url, query=args, callopts))
  }
  
  # Get data
  if(length(data)==1){ out <- getdata(data) } else
  { out <- lapply(data, getdata) }
  
  out
}