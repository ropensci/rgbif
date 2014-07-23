#' Search for datasets and dataset metadata.
#' 
#' @template all
#' @template occ
#' @import httr
#' @import plyr
#' @export
#' 
#' @param data The type of data to get. Default is all data.
#' @param type Type of dataset, options include OCCURRENCE, etc.
#' @param uuid UUID of the data node provider. This must be specified if data
#'    is anything other than 'all'.
#' @param query Query term(s). Only used when data='all'
#' @param id A metadata document id.
#' 
#' @return A list.
#' 
#' @examples \dontrun{
#' datasets()
#' datasets(type="OCCURRENCE")
#' datasets(uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
#' datasets(data='contact', uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
#' datasets(data='metadata', uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
#' datasets(data='metadata', uuid="a6998220-7e3a-485d-9cd6-73076bd85657", id=598)
#' datasets(data=c('deleted','duplicate'))
#' datasets(data=c('deleted','duplicate'), limit=1)
#' }

datasets <- function(data = 'all', type = NULL, uuid = NULL, query = NULL, id = NULL, 
                     limit = 20, start=NULL, callopts=list())
{
  args <- rgbif_compact(list(q = query, limit=as.integer(limit), offset=start))
  
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
        url <- 'http://api.gbif.org/v1/dataset'
      } else
      {
        if(!is.null(id) && x=='metadata'){
          url <- sprintf('http://api.gbif.org/v1/dataset/metadata/%s/document', id)
        } else
        {
          url <- sprintf('http://api.gbif.org/v1/dataset/%s', x)          
        }
      }
    } else
    {
      if(x=='all'){
        url <- sprintf('http://api.gbif.org/v1/dataset/%s', uuid)
      } else
      {
        url <- sprintf('http://api.gbif.org/v1/dataset/%s/%s', uuid, x)        
      }
    }
    tt <- GET(url, query=args, callopts)
    stop_for_status(tt)
    assert_that(tt$headers$`content-type`=='application/json')
    res <- content(tt, as = 'text', encoding = "UTF-8")
    RJSONIO::fromJSON(res, simplifyWithNames = FALSE)
  }
  
  # Get data
  if(length(data)==1){ out <- getdata(data) } else
  { out <- lapply(data, getdata) }
  
  out
}