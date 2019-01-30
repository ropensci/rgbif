#' Lookup occurrence issue definitions and short codes
#'
#' @export
#' @param issue Full name of occurrence issue, e.g, CONTINENT_COUNTRY_MISMATCH
#' @param code an occurrence issue short code, e.g. ccm
#' @examples
#' occ_issues_lookup(issue = 'CONTINENT_COUNTRY_MISMATCH')
#' occ_issues_lookup(issue = 'MULTIMEDIA_DATE_INVALID')
#' occ_issues_lookup(issue = 'ZERO_COORDINATE')
#' occ_issues_lookup(code = 'cdiv')

occ_issues_lookup <- function(issue=NULL, code=NULL){

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
                  paste0(gbifissues$issue[which(gbifissues$type == "occurrence")],
                         collapse = ","),
                  ".")
      )
    }
    if (!issue %in%
            gbifissues$issue[which(gbifissues$type == "occurrence")]) {
      stop(paste("Issue",
                 paste0("'", issue, "'"),
                 "is not related to occurrences.",
                 "Try name_issues_lookup(issue =",
                 paste0("'", issue, "')."))
      )
    }
    gbifissues[grep(issue, gbifissues$issue),]
  } else{
    if (!code %in% gbifissues$code) {
      stop("Invalid code.")
    }
    if (!code %in%
        gbifissues$code[which(gbifissues$type == "occurrence")]) {
      stop(paste("Code",
                 paste0("'", code, "'"),
                 "is not related to occurrences.",
                 "Try name_issues_lookup(code =",
                 paste0("'",code,"')."))
      )
    }
    gbifissues[grep(code, gbifissues$code),]
  }

}
