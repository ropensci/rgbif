#' Lookup name issue definitions and short codes
#'
#' @export
#' @param issue Full name of name issue, e.g, CONTINENT_COUNTRY_MISMATCH
#' @param code an name issue short code, e.g. ccm
#' @examples
#' name_issues_lookup(issue = 'BACKBONE_MATCH_NONE')
#' name_issues_lookup(issue = 'RANK_INVALID')
#' name_issues_lookup(code = 'bbmn')
#' name_issues_lookup(code = 'rankinv')
name_issues_lookup <- function(issue=NULL, code=NULL){

  if (!is.null(code) & !is.null(issue)) {
    stop(paste("Only one issue or one code allowed. Got: issue",
               paste0("'", issue, "'"),
               "and code",
               paste0("'", code, "'"),
               "at the same time.")
    )
  }
  if (is.null(code)) {
    if (is.null(issue)) {
      stop("Invalid pattern argument: issue and code both NULL.")
    }
    if (!issue %in% gbifissues$issue) {
      stop(paste0("Invalid issue. Valid issues: ",
                  paste0(gbifissues$issue[which(gbifissues$type == "name")],
                         collapse = ","),
                  ".")
      )
    }
    if (!issue %in%
        gbifissues$issue[which(gbifissues$type == "name")]) {
      stop(paste("Issue",
                 paste0("'", issue, "'"),
                 "is not related to names.",
                 "Try occ_issues_lookup(issue =",
                 paste0("'", issue,"')."))
      )
    }
    gbifissues[grep(issue, gbifissues$issue),]
  } else{
    if (!code %in% gbifissues$code) {
      stop("Invalid code.")
    }
    if (!code %in%
        gbifissues$code[which(gbifissues$type == "name")]) {
      stop(paste("Code",
                 paste0("'", code, "'"),
                 "is not related to names.",
                 "Try occ_issues_lookup(code =",
                 paste0("'", code,"')."))
      )
    }
    gbifissues[grep(code, gbifissues$code),]
  }
}
