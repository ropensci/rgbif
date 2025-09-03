#' Get installation metadata using an installation key
#' 
#' @param uuid A GBIF installationKey uuid.
#' @param limit The number of results to return. Default is 20.
#' @param start The offset of the first result to return.
#' @param curlopts A list of curl options to pass to the request.
#' 
#' @return A `tibble` or a `list`. 
#' 
#' @examples \dontrun{
#' # Get all datasets for a given installation 
#' installation_dataset(uuid="d209e552-7e6e-4840-b13c-c0596ef36e55", limit=10)
#' installation_comment(uuid="a0e05292-3d09-4eae-9f83-02ae3516283c")
#' installation_contact(uuid="896898e8-c0ac-47a0-8f38-0f792fbe3343")
#' installation_endpoint(uuid="896898e8-c0ac-47a0-8f38-0f792fbe3343")
#' installation_identifier(uuid="896898e8-c0ac-47a0-8f38-0f792fbe3343")
#' installation_machinetag(uuid="896898e8-c0ac-47a0-8f38-0f792fbe3343")
#' }
#' 

#' @name installation_uuid_funs
#' @export
installation_dataset <- function(uuid=NULL,limit=20, start = NULL, curlopts = list()) {
  installation_uuid_get_(uuid=uuid,endpoint="/dataset",limit=limit,start=start,curlopts,meta=TRUE)
}

#' @name installation_uuid_funs
#' @export
installation_comment <- function(uuid=NULL, curlopts = list()) {
  installation_uuid_get_(uuid=uuid,endpoint="/comment",meta=FALSE)
}

#' @name installation_uuid_funs
#' @export
installation_contact <- function(uuid=NULL, curlopts = list()) {
  installation_uuid_get_(uuid=uuid,endpoint="/contact",meta=FALSE)
}

#' @name installation_uuid_funs
#' @export
installation_endpoint <- function(uuid=NULL, curlopts = list()) {
  installation_uuid_get_(uuid=uuid,endpoint="/endpoint",meta=FALSE)
}

#' @name installation_uuid_funs
#' @export
installation_identifier <- function(uuid=NULL, curlopts = list()) {
  installation_uuid_get_(uuid=uuid,endpoint="/identifier",meta=FALSE)
}

#' @name installation_uuid_funs
#' @export
installation_machinetag <- function(uuid=NULL, curlopts = list()) {
  installation_uuid_get_(uuid=uuid,endpoint="/machineTag",meta=FALSE)
}

#' @name installation_uuid_funs
#' @export
installation_tag <- function(uuid=NULL, curlopts = list()) {
  installation_uuid_get_(uuid=uuid,endpoint="/tag",meta=FALSE)
}

installation_uuid_get_ <- function(uuid=NULL,endpoint,curlopts,limit=NULL, start=NULL,meta) {
    if(!is_uuid(uuid)) stop("'uuid' should be a GBIF installationKey uuid.")
    url <- paste0(gbif_base(),"/installation/",uuid,endpoint)
    if(!is.null(limit)) {
      args <- rgbif_compact(c(limit=limit,offset=start))
      tt <- gbif_GET(url, args, TRUE, curlopts)
    } else {
      tt <- gbif_GET(url, args = NULL, TRUE, curlopts)
    }
    if(meta) {
      meta <- tt[c('offset','limit','endOfRecords','count')]
      if (length(tt$results) == 0) {
        out <- NULL
      } else {
        out <- tibble::as_tibble(tt$results)  
      }
      list(meta = data.frame(meta), data = out) 
    } else {
      tibble::as_tibble(tt)
    }
  }
  
  
  




