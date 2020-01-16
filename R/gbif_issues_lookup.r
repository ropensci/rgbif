#' Lookup issue definitions and short codes
#'
#' @export
#' @param issue Full name of issue, e.g, CONTINENT_COUNTRY_MISMATCH
#' @param code An issue short code, e.g. 'ccm'
#' @examples
#' gbif_issues_lookup(issue = 'CONTINENT_COUNTRY_MISMATCH')
#' gbif_issues_lookup(code = 'ccm')
#' gbif_issues_lookup(issue = 'COORDINATE_INVALID')
#' gbif_issues_lookup(code = 'cdiv')

gbif_issues_lookup <- function(issue=NULL, code=NULL){

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
      stop("issue and code both NULL.")
    }
     if (!issue %in% gbifissues$issue) {
      stop(paste0("Issue '", issue, "' doesn't exists. ",
                  "Type gbif_issues() for table with all possible issues.")
      )
    }

    gbifissues[grep(issue, gbifissues$issue),]

  } else{
    if (!code %in% gbifissues$code) {
      stop(paste0("Issue code '", code, "' doesn't exists. ",
                  "Type gbif_issues() for table with all possible issue codes.")
      )
    }
    gbifissues[grep(code, gbifissues$code),]
  }
}
