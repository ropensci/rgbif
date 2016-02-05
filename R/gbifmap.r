#' Make a map to visualize GBIF occurrence data.
#'
#' @template map
#' @export
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
#' }

gbifmap <- function(input = NULL, mapdatabase = "world", region = ".",
                    geom = geom_point, jitter = NULL, customize = NULL) {

  check_for_a_pkg("maps")
  tomap <- input[complete.cases(input$decimalLatitude, input$decimalLatitude), ]
  tomap <- tomap[!tomap$decimalLongitude == 0 & !tomap$decimalLatitude == 0, ]
  tomap <- tomap[-(which(tomap$decimalLatitude <= 90 || tomap$decimalLongitude <= 180)), ]
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
    geom_polygon(aes(group = group), fill = "white", color = "gray40", size = 0.2) +
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
