#' Search for datasets and dataset metadata.
#' 
#' @template all
#' @import httr
#' @import plyr
#' @param data The type of data to get. Default is all data.
#' @param type Type of dataset, options include OCCURRENCE, etc.
#' @param uuid UUID of the data node provider. This must be specified if data
#'    is anything other than 'all'.
#' @param query Query term(s). Only used when data='all'
#' @param id A metadata document id.
#' @param callopts Further args passed on to GET.
#' @return A list.
#' @export
#' @examples \dontrun{
#' datasets()
#' datasets(type="OCCURRENCE")
#' datasets(uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
#' datasets(data='contact', uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
#' datasets(data='metadata', uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
#' datasets(data='metadata', uuid="a6998220-7e3a-485d-9cd6-73076bd85657", id=598)
#' datasets(data=c('deleted','duplicate'))
#' }
datasets <- function(data = 'all', type = NULL, uuid = NULL, query = NULL, id = NULL, 
                     callopts=list())
{
  args <- compact(list(q = query, type = type))
  
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
        url <- 'http://api.gbif.org/v0.9/dataset'
      } else
      {
        if(!is.null(id) && x=='metadata'){
          url <- sprintf('http://api.gbif.org/v0.9/dataset/metadata/%s/document', id)
        } else
        {
          url <- sprintf('http://api.gbif.org/v0.9/dataset/%s', x)          
        }
      }
    } else
    {
      if(x=='all'){
        url <- sprintf('http://api.gbif.org/v0.9/dataset/%s', uuid)
      } else
      {
        url <- sprintf('http://api.gbif.org/v0.9/dataset/%s/%s', uuid, x)        
      }
    }
    tt <- GET(url, query=args, callopts)
    stop_for_status(tt)
    content(tt)
  }
  
  # Get data
  if(length(data)==1){ out <- getdata(data) } else
  { out <- lapply(data, getdata) }
  
  out
}