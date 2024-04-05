geometry_handler <- function(x, geom_big = "asis", size = 40, n = 10, verbose = TRUE) {
  gbopts <- c('asis', 'bbox', 'axe')
  if (!geom_big %in% gbopts) {
    stop('geom_big must be one of: ', paste0(gbopts, collapse = ", "))
  }

  assert(size, c("numeric", "integer"))
  assert(n, c("numeric", "integer"))
  if (size <= 0) stop("geom_size must be > 0")
  if (n <= 0) stop("geom_n must be > 0")

  if (!is.null(x)) {
    if (!is.character(x)) {
      return(gbif_bbox2wkt(bbox = x))
    }

    out <- c()
    for (i in seq_along(x)) {
      out[[i]] <- switch(geom_big,
        asis = {
         x[i]
        },
        bbox = {
          if (nchar(x[i]) > 1500) {
            if (verbose) message("geometry is big, querying BBOX, then pruning results to polygon")
            # set run time option so that we know to prune result once it returns
            options(rgbif.geometry.original = x)
            gbif_bbox2wkt(bbox = gbif_wkt2bbox(x[i]))
          } else {
            x[i]
          }
        },
        axe = {
          .Deprecated(msg = "Using 'axe=' is deprecated Since rgbif v3.8.0. Please 
                      use occ_download(pred_within('...')) instead for complex polygons.")
          warning("This might return error or not work correctly, because of new polygon interpretation by GBIF.")
          check_for_a_pkg("sf")
          xsf <- sf::st_as_sfc(x[i])
          gt <- sf::st_make_grid(xsf, cellsize = rep(size, 2), n = rep(n, 2))
          res <- sf::st_intersection(xsf, gt)
          unlist(lapply(res, function(w) {
            if (inherits(w, "MULTIPOLYGON")) mp2wkt(w) else sf::st_as_text(w)
          }))
        }
      )

    }
    unlist(out, recursive = FALSE)

  } else {
    return(x)
  }
}

mp2wkt <- function(x) {
  z <- lapply(x, sf::st_polygon)
  vapply(z, sf::st_as_text, "")
}

prune_result <- function(x) {
  geom_orig <- getOption('rgbif.geometry.original')
  if (!is.null(geom_orig)) {
    check_for_a_pkg("sf")
    poly_orig <- sf::st_as_sf(data.frame(wkt=geom_orig),wkt="wkt",crs = "+proj=longlat +datum=WGS84")
    xx <- sf::st_as_sf(x, coords = c("decimalLongitude", "decimalLatitude"),crs = "+proj=longlat +datum=WGS84")
    clipped <- unlist(sf::st_intersects(xx,poly_orig,sparse=FALSE)) == 1
    clipped[is.na(clipped)] <- FALSE
    x <- x[clipped, ]
  }
  # set rgbif.geometry.original to NULL on return
  options(rgbif.geometry.original = NULL)
  return(x)
}

is_integer <- function(x){
  !grepl("[^[:digit:]]", format(x,  digits = 20, scientific = FALSE))
}
