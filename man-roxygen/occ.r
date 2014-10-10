#' @param callopts Pass on options to httr::GET for more refined control of 
#'    http calls, and error handling
#' @param limit Number of records to return. Defaults: For \code{\link{occ_search}} 500, for others
#'    100. Maximum: 1,000,000 records for \code{\link{occ_search}}, others, don't know yet.
#' @param start Record number to start at. Use in combination with limit to page through results.
#'    Note that in \code{\link{occ_search}} we do the paging internally for you, so there's no
#'    \code{start} parameeter, but in other functions you have to do paging yourself.
