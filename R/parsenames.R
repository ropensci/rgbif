#' Parse taxon names using the GBIF name parser.
#'
#' @export
#' @param scientificname A character vector of scientific names.
#' @param ... Further named parameters, such as \code{query}, \code{path}, etc, passed on to
#' \code{\link[httr]{modify_url}} within \code{\link[httr]{GET}} call. Unnamed parameters will be
#' combined with \code{\link[httr]{config}}.
#'
#' @return A \code{data.frame} containing fields extracted from parsed
#' taxon names. Fields returned are the union of fields extracted from
#' all species names in \code{scientificname}.
#' @author John Baumgartner (johnbb@@student.unimelb.edu.au)
#' @references \url{http://www.gbif.org/developer/species#parser}
#' @examples \dontrun{
#' parsenames(scientificname='x Agropogon littoralis')
#' parsenames(c('Arrhenatherum elatius var. elatius',
#'              'Secale cereale subsp. cereale', 'Secale cereale ssp. cereale',
#'              'Vanessa atalanta (Linnaeus, 1758)'))
#'
#' # Pass on options to httr
#' library('httr')
#' # res <- parsenames(c('Arrhenatherum elatius var. elatius',
#' #             'Secale cereale subsp. cereale', 'Secale cereale ssp. cereale',
#' #             'Vanessa atalanta (Linnaeus, 1758)'), config=progress())
#' }

parsenames <- function(scientificname, ...) {
  url <- paste0(gbif_base(), "/parser/name")
  tt <- POST(url, c(add_headers('Content-Type' = 'application/json')), ...,
             body = jsonlite::toJSON(scientificname), make_rgbif_ua())
  stop_for_status(tt)
  stopifnot(tt$headers$`content-type` == 'application/json')
  res <- jsonlite::fromJSON(c_utf8(tt), FALSE)
  (x <- data.table::setDF(data.table::rbindlist(res, fill = TRUE, use.names = TRUE)))
}
