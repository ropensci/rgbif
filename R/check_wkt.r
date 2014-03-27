#' Check input WKT
#' 
#' @import assertthat rgeos plyr
#' @importFrom stringr str_extract
#' @export
#' @param wkt A Well Known Text object
#' @examples 
#' check_wkt('POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 10.1))')
#' check_wkt('POINT(30.1 10.1)')
#' check_wkt('LINESTRING(3 4,10 50,20 25)')

check_wkt <- function(wkt=NULL){
  if(!is.null(wkt)){
    assert_that(is.character(wkt))
    y <- str_extract(wkt, "[A-Z]+")
    if(!y %in% c('POINT','POLYGON','LINESTRING','LINEARRING')) 
      stop("WKT must be of type POINT, POLYGON, LINESTRING, or LINEARRING")
    res <- try_default(readWKT(wkt), 'notvalid')
    if(!is(res, 'Spatial'))
      stop("Your WKT malformed somehow")
    wkt
  } else { NULL }
}