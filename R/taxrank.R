#' Get the possible values to be used for (taxonomic) rank arguments in GBIF
#'   	API methods.
#'
#' @examples \dontrun{
#' taxrank()
#' }
#' @export
taxrank <- function() {
  c("kingdom", "phylum", "class", "order", "family", "genus", "species", "infraspecific")
}
