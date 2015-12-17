#' Facetted count occurrence search.
#'
#' @param keys (numeric) GBIF keys, a vector.
#' @param by (character) One of georeferenced, basisOfRecord, country, or
#' publishingCountry.
#' @param countries (numeric) Number of countries to facet on, or a vector of country names
#' @param removezeros (logical) Default is FALSE
#' @export
#' @examples \dontrun{
#' # Select number of countries to facet on
#' count_facet(by='country', countries=3, removezeros = TRUE)
#' # Or, pass in country names
#' count_facet(by='country', countries='AR', removezeros = TRUE)
#'
#' spplist <- c('Geothlypis trichas','Tiaris olivacea','Pterodroma axillaris',
#'              'Calidris ferruginea','Pterodroma macroptera','Gallirallus australis',
#'              'Falco cenchroides','Telespiza cantans','Oreomystis bairdi',
#'              'Cistothorus palustris')
#' keys <- sapply(spplist, function(x) name_backbone(x, rank="species")$usageKey)
#' count_facet(keys, by='country', countries=3, removezeros = TRUE)
#' count_facet(keys, by='country', countries=3, removezeros = FALSE)
#' count_facet(by='country', countries=20, removezeros = TRUE)
#'
#' # Pass in country names instead
#' countries <- isocodes$code[1:10]
#' count_facet(by='country', countries=countries, removezeros = TRUE)
#'
#' # get occurrences by georeferenced state
#' ## across all records
#' count_facet(by='georeferenced')
#'
#' ## by keys
#' out <- count_facet(keys, by='georeferenced')
#' library("reshape2")
#' dcast(out, .id ~ georeferenced)
#'
#' # by basisOfRecord
#' count_facet(by="basisOfRecord")
#' }

count_facet <- function(keys = NULL, by = 'country', countries = 10, removezeros = FALSE) {

  # can't do both keys and basisofrecord
  if (!is.null(keys) && by == 'basisOfRecord') {
    stop("you can't pass in both keys and have by='basisOfRecord'")
  }

  # faceting data vectors
  if (is.numeric(countries)) {
    countrynames <- list(country = as.character(isocodes$code)[1:countries])
  } else{
    countrynames <- list(country = as.character(countries))
  }
  georefvals <- list(georeferenced = c(TRUE, FALSE))
  basisvals <- list(basisOfRecord =
                      c("FOSSIL_SPECIMEN", "HUMAN_OBSERVATION", "LITERATURE",
                        "LIVING_SPECIMEN", "MACHINE_OBSERVATION", "OBSERVATION",
                        "PRESERVED_SPECIMEN", "UNKNOWN"))
  byvar <- switch(by,
                  georeferenced = georefvals,
                  basisOfRecord = basisvals,
                  country = countrynames,
                  publishingCountry = countrynames)

  if (!is.null(keys)) {
    out <- lapply(keys, occ_by_keys, tt = byvar)
    names(out) <- keys
    df <- ldfast_names(lapply(out, function(x){
      tmp <- rbind_rows(x)
      names(tmp)[1] <- by
      tmp
    }))
  } else {
    out <- occ_by(byvar)
    df <- rbind_rows(out)
    names(df)[1] <- by
    df
  }

  # remove NAs (which were caused by errors in country names)
  df <- na.omit(df)

  if (removezeros) {
    df[!df$V1 == 0, ]
  } else {
    df
  }
}

# Function to get data for each name
occ_by_keys <- function(spkey=NULL, tt){
  occ_count_safe <- fail_with(NULL, occ_count)
  tmp <- lapply(tt[[1]], function(x){
    xx <- list(x)
    names(xx) <- names(tt)
    if (!is.null(spkey)) {
      xx$taxonKey <- spkey
    }
    do.call(occ_count_safe, xx)
  })
  names(tmp) <- tt[[1]]
  tmp[grep("No enum", tmp)] <- NA
  tmp
}

# Function to get data for each name
occ_by <- function(tt){
  occ_count_safe <- fail_with(NULL, occ_count)
  tmp <- lapply(tt[[1]], function(x){
    xx <- list(x)
    names(xx) <- names(tt)
    do.call(occ_count_safe, xx)
  })
  names(tmp) <- tt[[1]]
  tmp[grep("No enum", tmp)] <- NA
  tmp
}
