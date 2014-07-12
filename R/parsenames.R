#' Parse taxon names using the GBIF name parser.
#' 
#' @template all
#' @import httr
#' @import plyr
#' @importFrom RJSONIO toJSON fromJSON
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
  url <- "http://api.gbif.org/v1/parser/name"
  tt <- POST(url,
             config=c(add_headers('Content-Type' = 
                                    'application/json')),
             body=RJSONIO::toJSON(scientificname))
  stop_for_status(tt)
  assert_that(tt$headers$`content-type`=='application/json')
  temp <- content(tt, as = 'text', encoding = "UTF-8")
  res <- RJSONIO::fromJSON(temp, simplifyWithNames = FALSE)
  do.call(rbind.fill, lapply(res, as.data.frame))
}