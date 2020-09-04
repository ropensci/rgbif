#' Parse taxon names using the GBIF name parser.
#'
#' @export
#' @param scientificname A character vector of scientific names.
#' @template occ
#'
#' @return A `data.frame` containing fields extracted from parsed
#' taxon names. Fields returned are the union of fields extracted from
#' all species names in `scientificname`.
#' @author John Baumgartner (johnbb@@student.unimelb.edu.au)
#' @references <https://www.gbif.org/developer/species#parser>
#' @examples \dontrun{
#' parsenames(scientificname='x Agropogon littoralis')
#' parsenames(c('Arrhenatherum elatius var. elatius',
#'              'Secale cereale subsp. cereale', 'Secale cereale ssp. cereale',
#'              'Vanessa atalanta (Linnaeus, 1758)'))
#' parsenames("Ajuga pyramidata")
#' parsenames("Ajuga pyramidata x reptans")
#'
#' # Pass on curl options
#' # res <- parsenames(c('Arrhenatherum elatius var. elatius',
#' #          'Secale cereale subsp. cereale', 'Secale cereale ssp. cereale',
#' #          'Vanessa atalanta (Linnaeus, 1758)'), curlopts=list(verbose=TRUE))
#' }
parsenames <- function(scientificname, curlopts = list()) {
  url <- paste0(gbif_base(), "/parser/name")
  cli <- crul::HttpClient$new(url = url, headers = c(
    rgbif_ual,
    `Content-Type` = 'application/json'), opts = curlopts)
  tt <- cli$post(body = jsonlite::toJSON(scientificname), encode = "json")
  tt$raise_for_status()
  stopifnot(tt$response_headers$`content-type` == 'application/json')
  res <- jsonlite::fromJSON(tt$parse("UTF-8"), FALSE)
  res <- lapply(res, function(x) Map(function(z) if (is.null(z)) NA else z, x))
  (x <- data.table::setDF(
    data.table::rbindlist(res, fill = TRUE, use.names = TRUE)))
  stats::setNames(x, tolower(names(x)))
}
