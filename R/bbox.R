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
  # legacy code using wk package
  # stopifnot(!is.null(wkt))
  # as.numeric(wk::wk_bbox(wk::wkt(wkt)))
  stopifnot(is.character(wkt))

    one <- function(s) {
    if (is.na(s)) return(rep(NA_real_, 4))
    s <- trimws(s)

    # Handle EMPTY
    if (grepl("\\bEMPTY\\b", s, ignore.case = TRUE)) return(rep(NA_real_, 4))

    # Remove optional SRID=...; prefix
    s <- sub("^\\s*SRID\\s*=\\s*\\d+\\s*;\\s*", "", s, ignore.case = TRUE)

    # Extract all numbers (incl. scientific notation)
    nums <- regmatches(
      s,
      gregexpr("[-+]?(?:\\d+\\.?\\d*|\\.\\d+)(?:[eE][-+]?\\d+)?", s, perl = TRUE)
    )[[1]]

    if (length(nums) < 2) return(rep(NA_real_, 4))

    vals <- as.numeric(nums)

    # WKT coordinates are grouped like (x y [z [m]]), repeated.
    # We take the first two of each group; assume constant dimension across tuples.
    # Try to detect dimension from tokens like "POINT Z", "LINESTRING ZM", etc.
    dim_guess <- 2L
    if (grepl("\\bZM\\b", s, ignore.case = TRUE)) dim_guess <- 4L
    else if (grepl("\\bZ\\b", s, ignore.case = TRUE) || grepl("\\bM\\b", s, ignore.case = TRUE)) dim_guess <- 3L

    if (length(vals) %% dim_guess != 0L) {
      # Fallback if guess doesn't divide cleanly: assume XY pairs
      dim_guess <- 2L
    }

    mat <- matrix(vals, ncol = dim_guess, byrow = TRUE)
    x <- mat[, 1]
    y <- mat[, 2]
    c(min(x, na.rm = TRUE), min(y, na.rm = TRUE),
      max(x, na.rm = TRUE), max(y, na.rm = TRUE))
  }

  res <- t(vapply(wkt, one, numeric(4)))
  if (nrow(res) == 1) as.numeric(res[1, ]) else res
}


