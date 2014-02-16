#' Parse taxon names using the GBIF name parser.
#' 
#' @template all
#' @import httr
#' @import plyr
#' @importFrom RJSONIO toJSON
#' @param scientificname A character vector of scientific names.
#' @return A \code{data.frame} containing fields extracted from parsed 
#' taxon names. Fields returned are the union of fields extracted from
#' all species names in \code{scientificname}.
#' @author John Baumgartner (johnbb@@student.unimelb.edu.au)
#' @export
#' @examples \dontrun{
#' parsenames(scientificname='x Agropogon littoralis')
#' parsenames(c('Arrhenatherum elatius var. elatius', 
#'              'Secale cereale subsp. cereale', 'Secale cereale ssp. cereale',
#'              'Vanessa atalanta (Linnaeus, 1758)'))
#' }
parsenames <- function(scientificname) {
  url <- "http://api.gbif.org/v0.9/parser/name"
  tt <- POST(url,
             config=c(add_headers('Content-Type' = 
                                    'application/json')),
             body=RJSONIO::toJSON(scientificname))
  stop_for_status(tt)
  res <- content(tt)
  do.call(rbind.fill, lapply(res, as.data.frame))
}