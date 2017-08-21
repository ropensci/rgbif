#' Make a map to visualize GBIF occurrence data.
#'
#' @export
#' @param input Either a single data.frame or a list of data.frame's (e.g.,
#' from different speies). The data.frame has to have, in addition to any other
#' columns, columns named exactly "decimalLatitude" and "decimalLongitude".
#' @param mapdatabase The map database to use in mapping. What you choose here
#' determines what you can choose in the region parameter. One of: county,
#' state, usa, world, world2, france, italy, or nz.
#' @param region The region of the world to map. Run
#' `sort(unique(ggplot2::map_data("world")$region))` to see region names
#' for the world database layer, or
#' `sort(unique(ggplot2::map_data("state")$region))` for the state layer.
#' @param geom The geom to use, one of geom_point or geom_jitter. Don't
#' quote them.
#' @param jitter If you use jitterposition, the amount by which to jitter
#' points in width, height, or both.
#' @param customize Further arguments passed on to ggplot.
#'
#' @return Map (using ggplot2 package) of points on a map or tiles on a map.
#'
#' @details gbifmap takes care of cleaning up the data.frame (removing NA's,
#' etc.) returned from rgbif functions, and creating the map. This function
#' gives a simple map of your data.  You can look at the code behing the
#' function itself if you want to build on it to make a map according
#' to your specfications.
#'
#' Note that this function removes values that are impossible on the globe
#' (lat values greater than 90 or less than -90; long values greater than 180
#' or less than -180), and those rows that have both lat and long as NA
#' or zeros.
#'
#' See the `scrubr` package for more powerful and flexible vizualization
#' options with GBIF data.
#'
#' @examples \dontrun{
#' # Make a map of Puma concolor occurrences
#' key <- name_backbone(name='Puma concolor')$speciesKey
#' dat <- occ_search(taxonKey=key, return='data', limit=100)
#' gbifmap(dat)
#'
#' # Plot more Puma concolor occurrences
#' dat <- occ_search(taxonKey=key, return='data', limit=1200)
#' nrow(dat)
#' gbifmap(dat)
#'
#' # Jitter positions, compare the two
#' library("ggplot2")
#' gbifmap(dat)
#' gbifmap(dat, geom = geom_jitter, jitter = position_jitter(1, 6))
#'
#' # many species
#' splist <- c('Cyanocitta stelleri', 'Junco hyemalis', 'Aix sponsa')
#' keys <- vapply(splist, function(x) name_suggest(x)$key[1], numeric(1),
#'   USE.NAMES=FALSE)
#' dat <- occ_data(keys, limit = 50)
#' library("data.table")
#' dd <- rbindlist(lapply(dat, function(z) z$data), fill = TRUE,
#'   use.names = TRUE)
#' gbifmap(dd)
#' }

gbifmap <- function(input = NULL, mapdatabase = "world", region = ".",
                    geom = geom_point, jitter = NULL, customize = NULL) {

  check_for_a_pkg("maps")
  if (!inherits(input, "data.frame")) stop("'input' must be a data.frame")
  tomap <- input[stats::complete.cases(input$decimalLatitude,
                                       input$decimalLatitude), ]
  tomap <- tomap[!tomap$decimalLongitude == 0 & !tomap$decimalLatitude == 0, ]
  tomap <- tomap[abs(tomap$decimalLatitude) <= 90 &
                   abs(tomap$decimalLongitude) <= 180, ]
  if (NROW(tomap) == 0) stop("after cleaning data, no records remaining")
  tomap$name <- as.factor(gbif_capwords(tomap$name, onlyfirst = TRUE))

  if (is.null(jitter)) {
    jitter <- position_jitter()
  }

  if (length(unique(tomap$name)) == 1) {
    theme2 <- theme(legend.position = "none")
  } else {
    theme2 <- NULL
  }

  world <- map_data(map = mapdatabase, region = region)
  message(paste("Rendering map...plotting ", nrow(tomap), " points", sep = ""))

  ggplot(world, aes(long, lat)) +
    geom_polygon(aes(group = group), fill = "white", color = "gray40",
                 size = 0.2) +
    geom(data = tomap, aes(decimalLongitude, decimalLatitude, colour = name),
         alpha = 0.4, size = 3, position = jitter) +
    scale_color_brewer("", type = "qual", palette = 6) +
    labs(x = "", y = "") +
    theme_bw(base_size = 14) +
    theme(legend.position = "bottom", legend.key = element_blank()) +
    guides(col = guide_legend(nrow = 2)) +
    coord_fixed(ratio = 1) +
    blanktheme() +
    theme2 +
    customize
}

check_for_a_pkg <- function(x) {
  if (!requireNamespace(x, quietly = TRUE)) {
    stop("Please install ", x, call. = FALSE)
  } else {
    invisible(TRUE)
  }
}
