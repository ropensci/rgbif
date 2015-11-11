#' Check input WKT
#'
#' @export
#' @param wkt (character) A Well Known Text string
#' @examples
#' wkt <- 'LINESTRING (30 10, 10 30, 40 40)'
#' read_wkt(wkt)
#'
#' wkt <- "POLYGON((38.4 -125,40.9 -125,40.9 -121.8,38.4 -121.8,38.4 -125))"
#' read_wkt(wkt)
read_wkt <- function(wkt) {
  terr$eval(sprintf("var out = terrwktparse.parse('%s');", wkt))
  terr$get("out")
}
