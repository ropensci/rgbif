#' Get extended dataset information 
#'
#' @name dataset_uuid_funs 
#' @param uuid (character) datasetKey uuid.
#' @param limit Number of records to return. 
#' @param start Record number to start at.
#' @param curlopts curlopts options passed on to [crul::HttpClient].
#'
#' @return A list.
#' 
#' @details
#' Theses functions all return dataset meta-data and other information. Not all 
#' datasets have values for these functions. Some of the endpoints are used 
#' internally by GBIF and might be difficult understand their meaning without 
#' some insider knowledge. 
#'
#' The function `dataset` will return all the data contained in the other 
#' convenience functions. 
#'
#' @export 
#'
#' @examples dontrun {
#' dataset_comment("95b17bbe-f762-11e1-a439-00145eb45e9a")
#' dataset_process("95b17bbe-f762-11e1-a439-00145eb45e9a")
#' }

#' @rdname dataset_uuid_funs
#' @export
dataset <- function(uuid = NULL, limit = 20, start=NULL, curlopts = list()) {
  if(!is_uuid(uuid)) warning("The uuid you supplied might not be valid.")
  url <- paste0(gbif_base(), '/dataset/',uuid)
  args <- rgbif_compact(list(limit = as.integer(limit),
                             offset = start))
  res <- gbif_GET(url, args, TRUE, curlopts)
  structure(list(meta = get_meta(res), data = parse_results(res,uuid)))
}

#' @rdname dataset_uuid_funs
#' @export
dataset_process <- function(uuid = NULL, limit = 20, start=NULL, curlopts = list()) {
  rgbif_dataset_uuid_get_(x= "process", uuid = NULL, limit = 20, start=NULL, curlopts = list(), 
                          pull_results = TRUE)
}

#' @rdname dataset_uuid_funs
#' @export
dataset_networks <- function(uuid = NULL, limit = 20, start=NULL, curlopts = list()) {
  rgbif_dataset_uuid_get_(x= "networks", uuid = NULL, limit = 20, start=NULL, curlopts = list(), 
                          pull_results = TRUE)
  }

#' @rdname dataset_uuid_funs
#' @export
dataset_constituents <- function(uuid = NULL, limit = 20, start=NULL, curlopts = list()) {
  rgbif_dataset_uuid_get_(x="constituents",uuid = NULL, limit = 20, start=NULL, curlopts = list(), 
                          pull_results = TRUE)
}

#' @rdname dataset_uuid_funs
#' @export
dataset_metadata <- function(uuid = NULL, limit = 20, start=NULL, curlopts = list()) {
  rgbif_dataset_uuid_get_(x="metadata",uuid = NULL, limit = 20, start=NULL, curlopts = list())
}
  
#' @rdname dataset_uuid_funs
#' @export
dataset_comment <- function(uuid = NULL, limit = 20, start=NULL, curlopts = list()) {
  rgbif_dataset_uuid_get_(x="comment",uuid = NULL, limit = 20, start=NULL, curlopts = list())
  }

#' @rdname dataset_uuid_funs
#' @export
dataset_contact <- function(uuid = NULL, limit = 20, start=NULL, curlopts = list()) {
  rgbif_dataset_uuid_get_(x="contact",uuid = NULL, limit = 20, start=NULL, curlopts = list())
  }

#' @rdname dataset_uuid_funs
#' @export
dataset_endpoint <- function(uuid = NULL, limit = 20, start=NULL, curlopts = list()) {
  rgbif_dataset_uuid_get_(x="endpoint",uuid = NULL, limit = 20, start=NULL, curlopts = list())
  }

#' @rdname dataset_uuid_funs
#' @export
dataset_identifier <- function(uuid = NULL, limit = 20, start=NULL, curlopts = list()) {
  rgbif_dataset_uuid_get_(x="identifier",uuid = NULL, limit = 20, start=NULL, curlopts = list())
  }

#' @rdname dataset_uuid_funs
#' @export
dataset_machinetag <- function(uuid = NULL,limit = 20, start=NULL, curlopts = list()) {
  rgbif_dataset_uuid_get_(x="machinetag",uuid = NULL, limit = 20, start=NULL, curlopts = list())
  }

#' @rdname dataset_uuid_funs
#' @export
dataset_tag  <- function(uuid = NULL,limit = 20, start=NULL, curlopts = list()) {
  rgbif_dataset_uuid_get_(x="tag",uuid = NULL, limit = 20, start=NULL, curlopts = list())
} 

rgbif_dataset_uuid_get_ <- function(x=NULL,uuid=NULL,limit = NULL, start=NULL, 
                               curlopts = NULL,pull_results=FALSE) {
  if(!is_uuid(uuid)) warning("The uuid you supplied might not be valid.")
  url <- paste0(gbif_base(), '/dataset/',uuid,"/",x)
  args <- rgbif_compact(list(limit = as.integer(limit),
                             offset = start))
  res <- gbif_GET(url, args, TRUE, curlopts)
  if(pull_results) {
    structure(list(meta = get_meta(res), data = parse_results(res,uuid)$results))
  } else {
    structure(list(meta = get_meta(res), data = parse_results(res,uuid)))
  }
}  
  