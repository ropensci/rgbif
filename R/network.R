#' Get data about GBIF networks
#'
#' @template otherlimstart
#' @template occ
#' @template identifierargs
#' @export
#'
#' @param data The type of data to get. One or more of: 'contact', 'endpoint',
#'    'identifier', 'tag', 'machineTag', 'comment', 'constituents', or the
#'    special 'all'. Default: `'all'`
#' @param uuid UUID of the data network provider. This must be specified if
#' data is anything other than 'all'. Only 1 can be passed in
#' @param query Query nodes. Only used when `data='all'`. Ignored
#' otherwise.
#'
#' @return 
#' - `network()` returns a list
#' - `network_constituents()` returns a data.frame of datasets in the network
#' 
#' @details 
#' Get various information about GBIF networks. `network_constituents()` is a 
#' convenience function that allows you to get all the datasets in a network. 
#'
#'
#' @references <https://www.gbif.org/developer/registry#networks>
#'
#' @examples \dontrun{
#' network()
#' network(uuid='2b7c7b4f-4d4f-40d3-94de-c28b6fa054a6')
#' 
#' network_constituents('2b7c7b4f-4d4f-40d3-94de-c28b6fa054a6')
#' 
#' # curl options
#' network(curlopts = list(verbose=TRUE))
#' }

network <- function(data = 'all', uuid = NULL, query = NULL, identifier=NULL,
                     identifierType=NULL, limit=100, start=NULL,
                     curlopts = list()) {
  
  args <- rgbif_compact(list(q = query, limit = as.integer(limit),
                             offset = start))
  data <- match.arg(data,
                    choices = c(
                      'all', 'contact', 'endpoint', 'identifier',
                      'tag', 'machineTag', 'comment', 'constituents'),
                    several.ok = TRUE)
  
  # Define function to get data
  getdata <- function(x){
    if (!x == 'all' && is.null(uuid))
      stop('You must specify a uuid if data does not equal "all"')
    
    url <- if (is.null(uuid)) {
      paste0(gbif_base(), '/network')
    } else {
      if (x == 'all') { sprintf('%s/network/%s', gbif_base(), uuid) } else {
        sprintf('%s/network/%s/%s', gbif_base(), uuid, x)
      }
    }
    res <- gbif_GET(url, args, TRUE, curlopts)
    structure(list(meta = get_meta(res), data = parse_results(res, uuid)))
  }
  
  # Get data
  if (length(data) == 1) getdata(data) else lapply(data, getdata)
}


#' @export
#' @rdname network
network_constituents <- function(uuid=NULL,
                                 limit=100,
                                 start=0) {
  out<-tibble::as_tibble(network(uuid,data="constituents",start=start,limit=limit)$data)$results
  names(out)[names(out) == "key"] <- "datasetKey"
  out
}

