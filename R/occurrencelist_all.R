#' Occurrencelist_all carries out an occurrencelist query for a single name and all its name variants according to GBIF's name matching.
#'
#' @template oclist
#' @examples \dontrun{
#' # Query for a single species
#' # compare the names returned by occurrencelist to occurrencelist_all
 occurrencelist(scientificname = 'Aristolochia serpentaria', coordinatestatus = TRUE, 
    maxresults = 40)
 occurrencelist_all(scientificname = 'Aristolochia serpentaria', coordinatestatus = TRUE, 
    maxresults = 40)
#' 
#' }
#' @export
occurrencelist_all <- function(scientificname, ...) 
{	
  gbifkey <- taxonsearch(scientificname=scientificname)$gbifkey
  name_lkup <- taxonget(key = as.numeric(as.character(gbifkey)))
  sciname <- unique(as.character(subset(name_lkup, select='sciname', 
                                        subset=rank == 'species' |
                                               rank == 'variety')[ , 1]))
  sciname <- paste(sciname, '*', sep='')
  out <- occurrencelist_many(scientificname = sciname, ...)
  return(out)
}