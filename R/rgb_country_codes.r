#' Look up 2 character ISO country codes
#'
#' @param country_name Name of country to look up
#' @param fuzzy If TRUE, uses agrep to do fuzzy search on names.
#' @param ... Further arguments passed on to agrep or grep
#' @export
#' @examples
#' rgb_country_codes(country_name="United")
rgb_country_codes <- function(country_name, fuzzy=FALSE, ...)
{
  if(fuzzy){
    isocodes[agrep(country_name, isocodes$name, ...),]
  } else
  {
    isocodes[grep(country_name, isocodes$name, ...),]
  }
}
