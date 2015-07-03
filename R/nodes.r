#' Nodes metadata.
#'
#' @template otherlimstart
#' @template occ
#' @template identifierargs
#' @export
#'
#' @param data The type of data to get. Default is all data.
#' @param uuid UUID of the data node provider. This must be specified if data
#'    is anything other than 'all'.
#' @param query Query nodes. Only used when data='all'
#' @param isocode A 2 letter country code. Only used if data='country'.
#'
#' @references \url{http://www.gbif.org/developer/registry#nodes}
#'
#' @examples \dontrun{
#' nodes(limit=5)
#' nodes(uuid="1193638d-32d1-43f0-a855-8727c94299d8")
#' nodes(data='identifier', uuid="03e816b3-8f58-49ae-bc12-4e18b358d6d9")
#' nodes(data=c('identifier','organization','comment'), uuid="03e816b3-8f58-49ae-bc12-4e18b358d6d9")
#'
#' uuids = c("8cb55387-7802-40e8-86d6-d357a583c596","02c40d2a-1cba-4633-90b7-e36e5e97aba8",
#'   "7a17efec-0a6a-424c-b743-f715852c3c1f","b797ce0f-47e6-4231-b048-6b62ca3b0f55",
#'   "1193638d-32d1-43f0-a855-8727c94299d8","d3499f89-5bc0-4454-8cdb-60bead228a6d",
#'   "cdc9736d-5ff7-4ece-9959-3c744360cdb3","a8b16421-d80b-4ef3-8f22-098b01a89255",
#'   "8df8d012-8e64-4c8a-886e-521a3bdfa623","b35cf8f1-748d-467a-adca-4f9170f20a4e",
#'   "03e816b3-8f58-49ae-bc12-4e18b358d6d9","073d1223-70b1-4433-bb21-dd70afe3053b",
#'   "07dfe2f9-5116-4922-9a8a-3e0912276a72","086f5148-c0a8-469b-84cc-cce5342f9242",
#'   "0909d601-bda2-42df-9e63-a6d51847ebce","0e0181bf-9c78-4676-bdc3-54765e661bb8",
#'   "109aea14-c252-4a85-96e2-f5f4d5d088f4","169eb292-376b-4cc6-8e31-9c2c432de0ad",
#'   "1e789bc9-79fc-4e60-a49e-89dfc45a7188","1f94b3ca-9345-4d65-afe2-4bace93aa0fe")
#'
#' res <- lapply(uuids, function(x) nodes(x, data='identifier')$data)
#' res <- res[!sapply(res, length)==0]
#' res[1]
#'
#' # Pass on options to httr
#' library('httr')
#' # res <- nodes(limit=20, config=progress())
#' }

nodes <- function(data = 'all', uuid = NULL, query = NULL, identifier=NULL,
  identifierType=NULL, limit=100, start=NULL, isocode = NULL, ...) {

  args <- rgbif_compact(list(q = query, limit=as.integer(limit), offset=start))

  data <- match.arg(data, choices=c('all', 'organization', 'endpoint',
                                    'identifier', 'tag', 'machineTag', 'comment',
                                    'pendingEndorsement', 'country', 'dataset',
                                    'installation'), several.ok = TRUE)

  # Define function to get data
  getdata <- function(x){
    if(!data == 'all' && is.null(uuid))
      stop('You must specify a uuid if data does not equal "all"')

    url <- if(is.null(uuid)){
      if(x=='all'){ paste0(gbif_base(), '/node') } else {
        if(!is.null(isocode) && x=='country'){
          sprintf('%s/node/country/%s', gbif_base(), isocode)
        } else {
          sprintf('%s/node/%s', gbif_base(), x)
        }
      }
    } else {
      if(x=='all'){ sprintf('%s/node/%s', gbif_base(), uuid) } else {
        sprintf('%s/node/%s/%s', gbif_base(), uuid, x)
      }
    }
    res <- gbif_GET(url, args, TRUE, ...)
    structure(list(meta=get_meta(res), data=parse_results(res, uuid)))
  }

  # Get data
  if(length(data)==1) getdata(data) else lapply(data, getdata)
}
