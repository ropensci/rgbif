#' Check if a dataset is gridded
#'
#' @param uuid (vector) A character vector of GBIF datasetkey uuids.
#' @param min_dis (numeric) (default 0.02) Minimum distance in degrees to accept
#'  as gridded.
#' @param min_per (integer)(default 50%) Minimum percentage of points having same nearest 
#' neighbor distance to be considered gridded.
#' @param return (character) (default "logical"). Choice of "data" will return 
#' a data.frame of more information or "logical" will return just TRUE or FALSE 
#' indicating whether a dataset is considered 'gridded". 
#' @param min_dis_count (default 30) Minimum number of unique points to accept
#' an assessment of 'griddyness'.
#' @param warn (logical) indicates whether to warn about missing values or bad 
#' values. 
#'
#' @details 
#' Gridded datasets are a known problem at GBIF. Many datasets have 
#' equally-spaced points in a regular pattern. These datasets are usually 
#' systematic national surveys or data taken from some atlas 
#' (“so-called rasterized collection designs”). This function uses the 
#' percentage of unique lat-long points with the most common nearest 
#' neighbor distance to identify gridded datasets.
#' 
#' \href{https://data-blog.gbif.org/post/finding-gridded-datasets/}{https://data-blog.gbif.org/post/finding-gridded-datasets/}
#' 
#' I recommend keeping the default values for the parameters. 
#'
#'
#' @return
#' A logical \code{vector} indicating whether a dataset is considered gridded.
#' Or if \code{return="data"}, a \code{data.frame} of more information.
#' 
#' @export
#'
#' @examples \dontrun{
#' 
#' dataset_gridded("9070a460-0c6e-11dd-84d2-b8a03c50a862")
#' dataset_gridded(c("9070a460-0c6e-11dd-84d2-b8a03c50a862",
#'                "13b70480-bd69-11dd-b15f-b8a03c50a862"))
#'
#' 
#' }
#' 
dataset_gridded <- function(uuid=NULL,
                            min_dis=0.05,
                            min_per=50,
                            min_dis_count=30,
                            return="logical",
                            warn=TRUE) {
  
  uuid_bool <- sapply(uuid, function(x) is_uuid(x))
  if(all(!uuid_bool)) stop ("'uuid' should be a GBIF datasetkey uuid.")

  x <- unique(uuid[uuid_bool & !is.na(uuid)]) # filtered uuids
  d_input <- tibble::tibble(index=1:length(uuid),uuid,is_uuid=uuid_bool)
  
  if(!all(uuid_bool) & warn) warning("'uuid' should be a GBIF datasetkey uuid.")
  url_base <- paste0(gbif_base(), '/dataset/')
  urls <- paste0(url_base,x,"/gridded")
  res <- gbif_async_get(urls)
  res <- lapply(res,function(z) {
    z <- unlist(z,recursive = FALSE)
    if(!is_empty(z)) {
      tibble::tibble(
        min_distance = z$minDist,
        percentage_gridded = z$percent*100,
        total_count = z$totalCount,
        min_distance_count = z$minDistCount
        )  
    } else {
      tibble::tibble(
        min_distance = NA, # dummy fill
        percentage_gridded = NA,
        total_count = NA,
        min_distance_count = NA
      )
    }
  })
  d <- bind_rows(res)
  d$uuid <- x
  d <- merge(d_input,d,id="uuid",all.x=TRUE)

  d$is_gridded <- (d$percentage_gridded >= min_per & d$min_distance > min_dis & d$min_distance_count >= min_dis_count)
  d$is_gridded[is.na(d$is_gridded) & !is.na(d$uuid) & uuid_bool] <- FALSE # fill missing as not gridded
  d <- d[order(d$index),]
  if(return=="logical") d$is_gridded
  else d
}



