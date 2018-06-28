#' Convert a bounding box to a Well Known Text polygon, and a WKT to a
#' bounding box
#'
#' @export
#' @param minx (numeric) Minimum x value, or the most western longitude
#' @param miny (numeric) Minimum y value, or the most southern latitude
#' @param maxx (numeric) Maximum x value, or the most eastern longitude
#' @param maxy (numeric) Maximum y value, or the most northern latitude
#' @param bbox (numeric) A vector of length 4, with the elements: minx, miny,
#' maxx, maxy
#' @param wkt (character) A Well Known Text object.
#' @return gbif_bbox2wkt returns an object of class charactere, a Well
#' Known Text string of the form
#' 'POLYGON((minx miny, maxx miny, maxx maxy, minx maxy, minx miny))'.
#'
#' gbif_wkt2bbox returns a numeric vector of length 4, like
#' c(minx, miny, maxx, maxy)
#' @examples \dontrun{
#' # Convert a bounding box to a WKT
#' ## Pass in a vector of length 4 with all values
#' gbif_bbox2wkt(bbox=c(-125.0,38.4,-121.8,40.9))
#'
#' ## Or pass in each value separately
#' gbif_bbox2wkt(minx=-125.0, miny=38.4, maxx=-121.8, maxy=40.9)
#'
#' # Convert a WKT object to a bounding box
#' wkt <- "POLYGON((-125 38.4,-125 40.9,-121.8 40.9,-121.8 38.4,-125 38.4))"
#' gbif_wkt2bbox(wkt)
#' }
gbif_bbox2wkt <- function(minx=NA, miny=NA, maxx=NA, maxy=NA, bbox=NULL){
  if (is.null(bbox)) bbox <- c(minx, miny, maxx, maxy)
  stopifnot(noNA(bbox)) #check for NAs
  stopifnot(is.numeric(as.numeric(bbox))) #check for numeric-ness
  # wicket::bounding_wkt(values = bbox)
  bbox_template <- 'POLYGON((%s %s,%s %s,%s %s,%s %s,%s %s))'
  sprintf(bbox_template, 
    bbox[1], bbox[2],
    bbox[3], bbox[2],
    bbox[3], bbox[4],
    bbox[1], bbox[4],
    bbox[1], bbox[2]
  )
}

#' @export
#' @rdname gbif_bbox2wkt
gbif_wkt2bbox <- function(wkt = NULL){
  stopifnot(!is.null(wkt))
  as.numeric(wicket::wkt_bounding(wkt))
}
