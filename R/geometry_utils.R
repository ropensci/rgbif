geometry_handler <- function(x) {
  if (!is.null(x)) {

    for (i in seq_along(x)) {
      if (!is.character(x)) {
        x <- gbif_bbox2wkt(bbox = x)
      }
      if (nchar(x) > 1500) {
        message("geometry is big, querying BBOX, then pruning results to polygon")
        # set run time option so that we know to prune result once it returns
        options(rgbif.geometry.original = x)
        x <- gbif_bbox2wkt(bbox = gbif_wkt2bbox(x))
      }
    }
  }
  return(x)
}

prune_result <- function(x) {
  geom_orig <- getOption('rgbif.geometry.original')
  if (!is.null(geom_orig)) {
    check_for_a_pkg("sp")
    check_for_a_pkg("rgeos")
    poly_orig <- rgeos::readWKT(geom_orig)
    xx <- x
    sp::coordinates(xx) <- ~decimalLongitude + decimalLatitude
    clipped <- sp::over(xx, poly_orig) == 1
    clipped[is.na(clipped)] <- FALSE
    x <- x[clipped, ]
  }
  # set rgbif.geometry.original to NULL on return
  options(rgbif.geometry.original = NULL)
  return(x)
}
