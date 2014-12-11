#' Lookup occurrence issue definitions and short codes
#'
#' @export
#' @param issue Full name of issue, e.g, CONTINENT_COUNTRY_MISMATCH
#' @param code an issue short code, e.g. ccm
#' @examples
#' occ_issues_lookup(issue = 'CONTINENT_COUNTRY_MISMATCH')
#' occ_issues_lookup(issue = 'MULTIMEDIA_DATE_INVALID')
#' occ_issues_lookup(issue = 'ZERO_COORDINATE')
#' occ_issues_lookup(code = 'cdiv')

occ_issues_lookup <- function(issue=NULL, code=NULL){
  if(is.null(code))
    gbifissues[grep(issue, gbifissues$issue),]
  else
    gbifissues[grep(code, gbifissues$code),]
}
