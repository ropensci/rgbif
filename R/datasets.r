#' Search for datasets and dataset metadata.
#'
#' @template otherlimstart
#' @template occ
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
#' @references \url{http://www.gbif.org/developer/registry#datasets}
#'
#' @examples \dontrun{
#' datasets(limit=5)
#' datasets(type="OCCURRENCE")
#' datasets(uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
#' datasets(data='contact', uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
#' datasets(data='metadata', uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
#' datasets(data='metadata', uuid="a6998220-7e3a-485d-9cd6-73076bd85657", id=598)
#' datasets(data=c('deleted','duplicate'))
#' datasets(data=c('deleted','duplicate'), limit=1)
#'
#' # httr options
#' library('httr')
#' # res <- datasets(data=c('deleted','duplicate'), config=progress())
#' }

datasets <- function(data = 'all', type = NULL, uuid = NULL, query = NULL, id = NULL,
                     limit = 100, start=NULL, ...)
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

    url <- if(is.null(uuid)){
      if(x=='all'){
        paste0(gbif_base(), '/dataset')
      } else {
        if(!is.null(id) && x=='metadata'){
          sprintf('%s/dataset/metadata/%s/document', gbif_base(), id)
        } else
        {
          sprintf('%s/dataset/%s', gbif_base(), x)
        }
      }
    } else {
      if(x=='all'){
        sprintf('%s/dataset/%s', gbif_base(), uuid)
      } else
      {
        sprintf('%s/dataset/%s/%s', gbif_base(), uuid, x)
      }
    }
    res <- gbif_GET(url, args, TRUE, ...)
    structure(list(meta=get_meta(res), data=parse_results(res, uuid)))
    # parse_results(res, uuid)
  }

  # Get data
  if(length(data)==1) getdata(data) else lapply(data, getdata)
}
