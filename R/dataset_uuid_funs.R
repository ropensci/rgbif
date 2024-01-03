#' Get dataset metadata using a datasetkey
#' 
#' @name dataset_uuid_funs
#' @param uuid A GBIF datasetkey uuid. 
#' @param limit Number of records to return.
#' @param start Record number to start at. 
#' @param curlopts options passed on to [crul::HttpClient]. 
#'
#' @return A `tibble` or a `list`. 
#' 
#' @details
#' `dataset_metrics()` can only be used with checklist type datasets. 
#' 
#' @references 
#' <https://techdocs.gbif.org/en/openapi/v1/registry>
#' 
#' @examples \dontrun{
#' dataset_get("38b4c89f-584c-41bb-bd8f-cd1def33e92f")
#' dataset_process("38b4c89f-584c-41bb-bd8f-cd1def33e92f",limit=3)
#' dataset_networks("3dab037f-a520-4bc3-b888-508755c2eb52")
#' dataset_constituents("7ddf754f-d193-4cc9-b351-99906754a03b",limit=3)
#' dataset_comment("2e4cc37b-302e-4f1b-bbbb-1f674ff90e14")
#' dataset_contact("7ddf754f-d193-4cc9-b351-99906754a03b")
#' dataset_endpoint("7ddf754f-d193-4cc9-b351-99906754a03b")
#' dataset_identifier("7ddf754f-d193-4cc9-b351-99906754a03b")
#' dataset_machinetag("7ddf754f-d193-4cc9-b351-99906754a03b")
#' dataset_tag("c47f13c1-7427-45a0-9f12-237aad351040")
#' dataset_metrics("7ddf754f-d193-4cc9-b351-99906754a03b")
#' }

#' @name dataset_uuid_funs
#' @export
dataset_get <- function(uuid = NULL, curlopts = list()) {
  if(!is_uuid(uuid)) stop("'uuid' should be a GBIF datasetkey uuid.")
  url <- paste0(gbif_base(),"/dataset/",uuid)
  res <- rgbif_compact(gbif_GET(url, args = NULL, TRUE, curlopts))
  nest_if_needed <- function(x) ifelse(length(x) > 1, list(x), x)
  out <- tibble::as_tibble(lapply(res, nest_if_needed))
  out
}

#' @name dataset_uuid_funs
#' @export
dataset_process <- function(uuid = NULL, limit=20, start = NULL, curlopts = list()) {
  dataset_uuid_get_(uuid,"/process",limit=limit,start=start,curlopts,meta=TRUE)
}

#' @name dataset_uuid_funs
#' @export
dataset_networks <- function(uuid = NULL, limit = 20, start = NULL, curlopts = list()) {
  dataset_uuid_get_(uuid,"/networks",curlopts=curlopts,meta=FALSE)
}

#' @name dataset_uuid_funs
#' @export
dataset_constituents <- function(uuid = NULL, limit = 20, start = NULL, curlopts = list()) {
  dataset_uuid_get_(uuid,"/constituents",limit=limit,start=start,curlopts=curlopts,meta=TRUE)
}

#' @name dataset_uuid_funs
#' @export
dataset_comment <- function(uuid = NULL, curlopts = list()) {
  dataset_uuid_get_(uuid,"/comment",curlopts=curlopts,meta=FALSE)
}

#' @name dataset_uuid_funs
#' @export
dataset_contact <- function(uuid = NULL, curlopts = list()) {
  dataset_uuid_get_(uuid,"/contact",curlopts=curlopts,meta=FALSE)
}

#' @name dataset_uuid_funs
#' @export
dataset_endpoint <- function(uuid = NULL, curlopts = list()) {
  dataset_uuid_get_(uuid,"/endpoint",curlopts=curlopts,meta=FALSE)
}

#' @name dataset_uuid_funs
#' @export
dataset_identifier <- function(uuid = NULL, curlopts = list()) {
  dataset_uuid_get_(uuid,"/identifier",curlopts=curlopts,meta=FALSE)
}

#' @name dataset_uuid_funs
#' @export
dataset_machinetag <- function(uuid = NULL, curlopts = list()) {
  dataset_uuid_get_(uuid,"/machineTag",curlopts=curlopts,meta=FALSE)
}

#' @name dataset_uuid_funs
#' @export
dataset_tag <- function(uuid = NULL, curlopts = list()) {
  dataset_uuid_get_(uuid,"/tag",curlopts=curlopts,meta=FALSE)
}

#' @name dataset_uuid_funs
#' @export
dataset_metrics <- function(uuid = NULL, curlopts = list()) {
  if(!is_uuid(uuid)) warn("'uuid' should be a GBIF datasetkey uuid.")
  if(!dataset_get(uuid)$type == "CHECKLIST") stop("Dataset should be a checklist.")
  url <- paste0(gbif_base(),"/dataset/",uuid,"/metrics")
  res <- rgbif_compact(gbif_GET(url, args = NULL, TRUE, curlopts))
  nest_if_needed <- function(x) ifelse(length(x) > 1, list(x), x)
  out <- tibble::as_tibble(lapply(res, nest_if_needed))
  out
  }

dataset_uuid_get_ <- function(uuid,endpoint,curlopts,limit=NULL,start=NULL,meta) {
  if(!is_uuid(uuid)) stop("'uuid' should be a GBIF datasetkey uuid.")
  url <- paste0(gbif_base(),"/dataset/",uuid,endpoint)
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
