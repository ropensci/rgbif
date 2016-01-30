#' Parse and examine further GBIF issues on a dataset.
#'
#' @export
#'
#' @param .data Output from a call to \code{occ_search}, but only if \code{return="all"},
#' or \code{return="data"}, otherwise function stops with error
#' @param ... Named parameters to only get back (e.g., cdround), or to remove (e.g. -cdround).
#' @param mutate (character) One of:
#' \itemize{
#'  \item split Split issues into new columns.
#'  \item split_expand Split into new columns, and expand issue names.
#'  \item expand Expand issue abbreviated codes into descriptive names.
#' }
#' For split and split_expand, values in cells become y ("yes") or n ("no").
#'
#' @references
#' \url{http://gbif.github.io/gbif-api/apidocs/org/gbif/api/vocabulary/OccurrenceIssue.html}
#'
#' @details See also the vignette \code{Cleaning data using GBIF issues}.
#'
#' Note that you can also query based on issues, e.g.,
#' \code{occ_search(taxonKey=1, issue='DEPTH_UNLIKELY')}. However, I imagine it's more likely
#' that you want to search for occurrences based on a taxonomic name, or geographic area,
#' not based on issues, so it makes sense to pull data down, then clean as needed
#' using this function.
#'
#' This function only affects the \code{data} element in the \code{gbif} class that is
#' returned from a call to \code{\link[rgbif]{occ_search}}. Maybe in a future version
#' we will remove the associated records from the \code{hierarchy} and \code{media}
#' elements as they are remove from the \code{data} element.
#'
#' @examples \dontrun{
#' ## what do issues mean, can print whole table, or search for matches
#' head(gbif_issues())
#' gbif_issues()[ gbif_issues()$code %in% c('cdround','cudc','gass84','txmathi'), ]
#'
#' # compare out data to after occ_issues use
#' (out <- occ_search(limit=100))
#' out %>% occ_issues(cudc)
#'
#' # Parsing output by issue
#' (res <- occ_search(geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))', limit = 50))
#'
#' ## or parse issues in various ways
#' ### inlude only rows with gass84 issue
#' gg <- res %>% occ_issues(gass84)
#' NROW(res$data)
#' NROW(gg$data)
#' head(res$data)[,c(1:5)]
#' head(gg$data)[,c(1:5)]
#'
#' ### remove data rows with certain issue classes
#' res %>% occ_issues(-cdround, -cudc)
#'
#' ### split issues into separate columns
#' res %>% occ_issues(mutate = "split")
#' res %>% occ_issues(-cudc, -mdatunl, mutate = "split")
#' res %>% occ_issues(gass84, mutate = "split")
#'
#' ### expand issues to more descriptive names
#' res %>% occ_issues(mutate = "expand")
#'
#' ### split and expand
#' res %>% occ_issues(mutate = "split_expand")
#'
#' ### split, expand, and remove an issue class
#' res %>% occ_issues(-cudc, mutate = "split_expand")
#'
#' ## Or you can use occ_issues without %>%
#' occ_issues(res, -cudc, mutate = "split_expand")
#' }

occ_issues <- function(.data, ..., mutate = NULL) {

  stopifnot(xor(is(.data, "gbif"), is(.data, "gbif_data")))
  if ("data" %in% names(.data)) {
    tmp <- .data$data
  } else {
    tmp <- .data
  }

  if (!length(dots(...)) == 0) {
    filters <- parse_input(...)
    if (length(filters$neg) > 0) {
      tmp <- tmp[ !grepl(paste(filters$neg, collapse = "|"), tmp$issues), ]
    }
    if (length(filters$pos) > 0) {
      tmp <- tmp[ grepl(paste(filters$pos, collapse = "|"), tmp$issues), ]
    }
  }

  if (!is.null(mutate)) {
    if (mutate == 'split') {
      tmp <- split_iss(tmp)
    } else if (mutate == 'split_expand') {
      tmp <- mutate_iss(tmp)
      tmp <- split_iss(tmp)
    } else if (mutate == 'expand') {
      tmp <- mutate_iss(tmp)
    }
  }

  if ("data" %in% names(.data)) {
    .data$data <- tmp
    return( .data )
  } else {
    return( tmp )
  }
}

mutate_iss <- function(w){
  w$issues <- sapply(strsplit(w$issues, split = ","), function(z) paste(gbifissues[ gbifissues$code %in% z, "issue" ], collapse = ",") )
  return( w )
}

split_iss <- function(m){
  unq <- unique(unlist(strsplit(m$issues, split = ",")))
  df <- data.table::setDF(
    data.table::rbindlist(
      lapply(strsplit(m$issues, split = ","), function(b) {
        v <- unq %in% b
        data.frame(rbind(ifelse(v, "y", "n")), stringsAsFactors = FALSE)
      })
    )
  )
  names(df) <- unq
  m$issues <- NULL
  first <- c('name','key','decimalLatitude','decimalLongitude')
  data.frame(m[, first], df, m[, !names(m) %in% first], stringsAsFactors = FALSE)
}

parse_input <- function(...) {
  x <- as.character(dots(...))
  neg <- gsub('-', '', x[grepl("-", x)])
  pos <- x[!grepl("-", x)]
  list(neg = neg, pos = pos)
}

dots <- function(...){
  eval(substitute(alist(...)))
}
