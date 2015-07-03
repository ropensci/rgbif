#' Installations metadata.
#'
#' @template otherlimstart
#' @template occ
#' @template identifierargs
#' @export
#'
#' @param data The type of data to get. Default is all data. If not 'all', then one
#'    or more of 'contact', 'endpoint', 'dataset', 'comment', 'deleted', 'nonPublishing'.
#' @param uuid UUID of the data node provider. This must be specified if data
#'    is anything other than 'all'.
#' @param query Query nodes. Only used when data='all'. Ignored otherwise.
#'
#' @references \url{http://www.gbif.org/developer/registry#installations}
#'
#' @examples \dontrun{
#' installations(limit=5)
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
#'
#' # Pass on options to httr
#' library('httr')
#' # res <- installations(data='deleted', config=progress())
#' }

installations <- function(data = 'all', uuid = NULL, query = NULL, identifier=NULL,
                          identifierType=NULL, limit=100, start=NULL, ...)
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

    url <- if(is.null(uuid)){
      if(x=='all'){ paste0(gbif_base(), '/installation') } else {
        sprintf('%s/installation/%s', gbif_base(), x)
      }
    } else {
      if(x=='all'){ sprintf('%s/installation/%s', gbif_base(), uuid) } else {
        sprintf('%s/installation/%s/%s', gbif_base(), uuid, x)
      }
    }
    res <- gbif_GET(url, args, TRUE, ...)
    structure(list(meta=get_meta(res), data=parse_results(res, uuid)))
  }

  # Get data
  if(length(data)==1) getdata(data) else lapply(data, getdata)
}
