#' Parse and examine further GBIF issues on a dataset.
#'
#' @export
#' @param .data Output from a call to \code{occ_search}
#' @param ... Named parameters to only get back (e.g., cdround), or to remove (e.g. -cdround).
#' @param mutate (character) One of: 
#' \itemize{
#'  \item split Split issues into new columns.
#'  \item split_expand Split into new columns, and expand issue names.
#'  \item expand Expand issue abbreviated codes into descriptive names.
#' }
#' For split and split_expand, values in cells become y ("yes") or n ("no").
#' 
#' @examples \donttest{
#' # Parsing output by issue
#' (res <- occ_search(geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))', limit = 50))
#' ## what do issues mean, can print whole table, or search for matches
#' head(gbifissues)
#' gbifissues[ gbifissues$code %in% c('cdround','cudc','gass84','txmathi'), ]
#' ## or parse issues in various ways
#' ### remove data rows with certain issue classes
#' library('magrittr')
#' res %>% occ_issues(-gass84, -mdatunl)
#' ### split issues into separate columns
#' res %>% occ_issues(mutate = "split")
#' ### expand issues to more descriptive names
#' res %>% occ_issues(mutate = "expand")
#' ### split and expand
#' res %>% occ_issues(mutate = "split_expand")
#' ### split, expand, and remove an issue class
#' res %>% occ_issues(-gass84, mutate = "split_expand")
#' 
#' # Or you can use occ_issues without %>%
#' occ_issues(res, -gass84, mutate = "split_expand")
#' }

occ_issues <- function(.data, ..., mutate=NULL){
  assert_that(is(.data, "gbif"))
  tmp <- .data$data
  
  if(!is.null(filter)){
    filters <- parse_input(...)
    if(length(filters$neg) > 0){
      tmp <- tmp[ !grepl(paste(filters$neg, collapse = "|"), tmp$issues), ]
    }
    if(length(filters$pos) > 0){
      tmp <- tmp[ grepl(paste(filters$pos, collapse = "|"), tmp$issues), ]
    }
  }
  
  if(!is.null(mutate)){
    if(mutate == 'split'){
      tmp <- split_iss(tmp)
    } else if(mutate == 'split_expand') {
      tmp <- mutate_iss(tmp)
      tmp <- split_iss(tmp)
    } else if(mutate == 'expand') {
      tmp <- mutate_iss(tmp)
    }
  }
  
  .data$data <- tmp
  return( .data )
}


mutate_iss <- function(w){
  w$issues <- sapply(strsplit(w$issues, split=","), function(z) paste(gbifissues[ gbifissues$code %in% z, "issue" ], collapse = ",") )
  return( w )
}

split_iss <- function(m){
  unq <- unique(unlist(strsplit(m$issues, split=",")))
  df <- data.frame(rbindlist(lapply(strsplit(m$issues, split=","), function(b) { v <- unq %in% b; data.frame(rbind(ifelse(v, "y", "n")), stringsAsFactors = FALSE) } )), stringsAsFactors = FALSE)
  names(df) <- unq
  m$issues <- NULL
  m <- cbind(m, df)
  return( m )
}

parse_input <- function(...){
  x <- as.character(dots(...))
  neg <- gsub('-', '', x[grepl("-", x)])
  pos <- x[!grepl("-", x, )]
  list(neg=neg, pos=pos)
}

dots <- function(...){
  eval(substitute(alist(...)))
}
