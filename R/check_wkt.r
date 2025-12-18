#' Check input WKT
#'
#' @export
#' @param wkt (character) one or more Well Known Text objects
#' @param skip_validate (logical) whether to skip `wk::wk_problems`
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
    
    wkt <- unlist(strsplit(wkt, ";")) # kept for legacy reasons
    strextract <- function(str, pattern) regmatches(str, regexpr(pattern, str))
    
    extracted_wkts <- strextract(wkt, "[A-Z]+")
    accepted_wkts <- c('POINT', 'POLYGON', 'MULTIPOLYGON', 'LINESTRING', 'LINEARRING')
    
    for (i in seq_along(wkt)) {
      if (!extracted_wkts[i] %in% accepted_wkts) stop(paste0("WKT must be one of the types: ",paste0(accepted_wkts, collapse = ", ")))
      if (!skip_validate) { res <- wk_problems(wkt[i])
      if (!is.na(res)) stop(res) # print error 
      }
    }
    return(wkt)
  } else {
    NULL
  }
}

wk_problems <- function(wkt) {
  if (!is.character(wkt) || length(wkt) != 1L) {
    return("not_character_scalar")
  }

  wkt <- trimws(wkt)

  if (is.na(wkt) || wkt == "") {
    return("missing_or_empty")
  }

  problems <- character()

  # 1. EMPTY keyword misuse
  if (grepl("\\bEMPTY\\b", wkt, ignore.case = TRUE) &&
      !grepl("\\b(POINT|LINESTRING|POLYGON|MULTI|GEOMETRYCOLLECTION)\\s+EMPTY\\b",
             wkt, ignore.case = TRUE)) {
    problems <- c(problems, "invalid_EMPTY_usage")
  }

  # 2. Unbalanced parentheses
  n_open  <- lengths(regmatches(wkt, gregexpr("\\(", wkt)))
  n_close <- lengths(regmatches(wkt, gregexpr("\\)", wkt)))
  if (n_open != n_close) {
    problems <- c(problems, "unbalanced_parentheses")
  }

  # 3. Geometry type missing or invalid
  if (!grepl(
    "^\\s*(SRID\\s*=\\s*\\d+\\s*;\\s*)?(POINT|LINESTRING|POLYGON|MULTIPOINT|MULTILINESTRING|MULTIPOLYGON|GEOMETRYCOLLECTION)\\b",
    wkt, ignore.case = TRUE
  )) {
    problems <- c(problems, "invalid_or_missing_geometry_type")
  }

  # 4. Non-numeric coordinates
  coord_text <- gsub(
    "^[^\\(]*\\(|\\)[^\\)]*$", "", wkt
  )
  bad_nums <- grepl("[A-Za-z]", coord_text) &&
              !grepl("\\b(Z|M|ZM)\\b", wkt, ignore.case = TRUE)
  if (bad_nums) {
    problems <- c(problems, "non_numeric_coordinates")
  }

  # 5. Comma / coordinate separator issues
  if (grepl(",\\s*,", wkt)) {
    problems <- c(problems, "double_comma")
  }
  if (grepl("\\(\\s*,|,\\s*\\)", wkt)) {
    problems <- c(problems, "dangling_comma")
  }

  # 6. Odd number of coordinate values (XY expected)
  nums <- regmatches(
    wkt,
    gregexpr("[-+]?(?:\\d+\\.?\\d*|\\.\\d+)(?:[eE][-+]?\\d+)?", wkt, perl = TRUE)
  )[[1]]

  if (length(nums) > 0 && length(nums) %% 2 != 0) {
    problems <- c(problems, "odd_number_of_coordinates")
  }

  # 7. Empty coordinate lists
  if (grepl("\\(\\s*\\)", wkt)) {
    problems <- c(problems, "empty_coordinate_list")
  }

  if (!all(is.na(problems))) {
  stop(paste(problems, collapse = "; "))
}

if (length(problems) == 0L) NA_character_ else problems
}

