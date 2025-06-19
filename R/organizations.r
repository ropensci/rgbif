#' Organizations metadata.
#'
#' @export
#'
#' @template otherlimstart
#' @template occ
#' @param data (character) The type of data to get. One or more of:
#' 'organization', 'contact', 'endpoint', 'identifier', 'tag', 'machineTag',
#' 'comment', 'hostedDataset', 'ownedDataset', 'deleted', 'pending',
#' 'nonPublishing', 'installation' or the special 'all'. Default: `'all'`
#' @param country (character) Filters by country. 
#' @param uuid (character) UUID of the data node provider. This must be
#' specified if data is anything other than 'all', 'deleted', 'pending', or
#' 'nonPublishing'.
#' @param query (character) Query nodes. Only used when `data='all'`
#'
#' @return A list of length of two, consisting of a data.frame \code{meta} when
#'  uuid is NULL, and \code{data} which can either be a list or a data.frame
#'  depending on the requested type of data.
#'
#' @references <https://www.gbif.org/developer/registry#organizations>
#'
#' @examples \dontrun{
#' organizations(limit=5)
#' organizations(query="france", limit=5)
#' organizations(country = "SPAIN")
#' organizations(uuid="4b4b2111-ee51-45f5-bf5e-f535f4a1c9dc")
#' organizations(data='contact', uuid="4b4b2111-ee51-45f5-bf5e-f535f4a1c9dc")
#' organizations(data='pending')
#' organizations(data=c('contact','endpoint'),
#'   uuid="4b4b2111-ee51-45f5-bf5e-f535f4a1c9dc")
#' organizations(data="installation", uuid="96710dc8-fecb-440d-ae3e-c34ae8a9616f")    
#'
#' # Pass on curl options
#' organizations(query="spain", curlopts = list(verbose=TRUE))
#' }

organizations <- function(data = 'all', country = NULL, uuid = NULL,
                          query = NULL, limit = 100, start=NULL,
                          curlopts = list()) {


  args <-
    rgbif_compact(
      list(
        q = query,
        country = country,
        limit = as.integer(limit),
        offset = start
        )
      )

  data <- match.arg(data,
                    choices = c('all', 'organization', 'contact', 'endpoint',
                              'identifier', 'tag', 'machineTag', 'comment',
                              'hostedDataset', 'ownedDataset', 'deleted',
                              'pending', 'nonPublishing', 'installation'), several.ok = TRUE)

  # Define function to get data
  getdata <- function(x){
    if (!all(data %in% c('all','deleted', 'pending', 'nonPublishing')) &&
        is.null(uuid))
      stop('You must specify a uuid if data does not equal "all" and
       data does not equal of deleted, pending, or nonPublishing')

    if (is.null(uuid)) {
      if (x == 'all') {
        url <- paste0(gbif_base(), '/organization')
      } else {
        url <- sprintf('%s/organization/%s', gbif_base(), x)
      }
    } else {
      if (x == 'all') {
        url <- sprintf('%s/organization/%s', gbif_base(), uuid)
      } else {
        url <- sprintf('%s/organization/%s/%s', gbif_base(), uuid, x)
      }
    }
    res <- gbif_GET(url, args, TRUE, curlopts)
    structure(list(meta = get_meta(res), data = parse_results(res, uuid)))
  }

  # Get data
  if (length(data) == 1) getdata(data) else lapply(data, getdata)
}
