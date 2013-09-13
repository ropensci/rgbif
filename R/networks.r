#' Networks metadata.
#' 
#' @template all
#' @importFrom httr GET content verbose
#' @importFrom plyr compact
#' @param data The type of data to get. Default is all data.
#' @param uuid UUID of the data network provider. This must be specified if data
#'    is anything other than 'all'.
#' @param callopts Further args passed on to GET.
#' @export
#' @examples \dontrun{
#' networks()
#' networks(uuid='16ab5405-6c94-4189-ac71-16ca3b753df7')
#' networks(data='endpoint', uuid='16ab5405-6c94-4189-ac71-16ca3b753df7')
#' }
networks <- function(data = 'all', uuid = NULL, callopts=list())
{
  data <- match.arg(data, choices=c('all', 'contact', 'endpoint', 'identifier', 
                                    'tag', 'machinetag', 'comment'))
  
  # Define function to get data
  getdata <- function(x){
    if(!x == 'all' && is.null(uuid))
      stop('You must specify a uuid if data does not equal "all"')
    
    if(is.null(uuid)){
      url <- 'http://api.gbif.org/network'
    } else
    {
      if(x=='all'){
        url <- sprintf('http://api.gbif.org/network/%s', uuid)
      } else
      {
        url <- sprintf('http://api.gbif.org/network/%s/%s', uuid, x)        
      }
    }
    content(GET(url, callopts))
  }
  
  # Get data
  if(length(data)==1){ out <- getdata(data) } else
    { out <- lapply(data, getdata) }
  
  out
}