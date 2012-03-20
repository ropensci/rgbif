#' Get values to be used for rank arguments in GBIF API methods. 
#' @param  None
#' @export
#' @examples \dontrun{
#' rank()
#' }
rank <- function()
{
  c(
    'kingdom', 'phylum', 'class', 'order', 'family', 'genus', 'species', 
    'infraspecific'
    )
}