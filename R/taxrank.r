#'Get values to be used for (taxonomic) rank arguments in GBIF API methods.
#'@export
#'@examples \dontrun{
#'taxrank()
#'}
taxrank <- function() {
    c("kingdom", "phylum", "class", "order", "family", "genus",
        "species", "infraspecific")
}
