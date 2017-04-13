#' Organizations metadata.
#'
#' @export
#'
#' @template otherlimstart
#' @template occ
#' @param data (character) The type of data to get. One or more of:
#' 'organization', 'contact', 'endpoint', 'identifier', 'tag', 'machineTag',
#' 'comment', 'hostedDataset', 'ownedDataset', 'deleted', 'pending',
#' 'nonPublishing', or the special 'all'. Default: `'all'`
#' @param uuid (character) UUID of the data node provider. This must be
#' specified if data is anything other than 'all'.
#' @param query (character) Query nodes. Only used when `data='all'`
#'
#' @return A list of length one or two. If `uuid` is NULL, then a
#' data.frame with call metadata, and a data.frame, but if `uuid` given,
#' then a list.
#'
#' @references <http://www.gbif.org/developer/registry#organizations>
#'
#' @examples \dontrun{
#' organizations(limit=5)
#' organizations(query="france", limit=5)
#' organizations(uuid="4b4b2111-ee51-45f5-bf5e-f535f4a1c9dc")
#' organizations(data='contact', uuid="4b4b2111-ee51-45f5-bf5e-f535f4a1c9dc")
#' organizations(data='pending')
#' organizations(data=c('contact','endpoint'),
#'   uuid="4b4b2111-ee51-45f5-bf5e-f535f4a1c9dc")
#'
#' # Pass on curl options
#' organizations(query="spain", curlopts = list(verbose=TRUE))
#' }

organizations <- function(data = 'all', uuid = NULL, query = NULL, limit = 100,
                          start=NULL, curlopts = list()) {

  args <- rgbif_compact(list(q = query, limit = as.integer(limit),
                             offset = start))
  data <- match.arg(data,
                    choices = c('all', 'organization', 'contact', 'endpoint',
                              'identifier', 'tag', 'machineTag', 'comment',
                              'hostedDataset', 'ownedDataset', 'deleted',
                              'pending', 'nonPublishing'), several.ok = TRUE)

  # Define function to get data
  getdata <- function(x){
    if (!data %in% c('all','deleted', 'pending', 'nonPublishing') &&
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
