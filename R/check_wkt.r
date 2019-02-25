#' Check input WKT
#'
#' @export
#' @param wkt (character) one or more Well Known Text objects
#' @param skip_validate (logical) whether to skip `wicket::wkt_validate`
#' call or not. Default: `FALSE`
#' @examples \dontrun{
#' check_wkt('POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 10.1))')
#' check_wkt('POINT(30.1 10.1)')
#' check_wkt('LINESTRING(3 4,10 50,20 25)')
#'
#' # check many passed in at once
#' check_wkt(c('POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 10.1))',
#'   'POINT(30.1 10.1)'))
#'
#' # bad WKT
#' # wkt <- 'POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 a))'
#' # check_wkt(wkt)
#'
#' # many wkt's, semi-colon separated, for many repeated "geometry" args
#' wkt <- "POLYGON((-102.2 46.0,-93.9 46.0,-93.9 43.7,-102.2 43.7,-102.2 46.0))
#' ;POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))"
#' check_wkt(gsub("\n", '', wkt))
#' }

check_wkt <- function(wkt = NULL, skip_validate = FALSE){
  stopifnot(is.logical(skip_validate))

  if (!is.null(wkt)) {
    stopifnot(is.character(wkt))

    newwkt <- c()
    for (i in seq_along(wkt)) {
      if (grepl(";", wkt[[i]])) {
        newwkt[[i]] <- strsplit(wkt[[i]], ";")[[1]]
      } else {
        newwkt[[i]] <- wkt[[i]]
      }
    }
    wkt <- unlist(newwkt)

    y <- strextract(wkt, "[A-Z]+")

    wkts <- c('POINT', 'POLYGON', 'MULTIPOLYGON', 'LINESTRING', 'LINEARRING')

    for (i in seq_along(wkt)) {
      if (!y[i] %in% wkts) {
        stop(
          paste0("WKT must be one of the types: ",
                 paste0(wkts, collapse = ", "))
        )
      }

      if (!skip_validate) {
        res <- wicket::validate_wkt(wkt[i])
        if (grepl("\\?wkt_correct", res$comments)) {
          res$comments <- sub("\\?wkt_correct", "\\?wicket::wkt_correct",
            res$comments)
        }
        if (!res$is_valid) stop(res$comments)
      }
    }

    return(wkt)
  } else {
    NULL
  }
}
