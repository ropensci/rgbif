#' Lookup details for specific names in all taxonomies in GBIF.
#'
#' @template occ
#' @template nameusage
#' @return A list of length two. The first element is metadata. The second is 
#' either a data.frame (verbose=FALSE, default) or a list (verbose=TRUE)
#' @references \url{http://www.gbif.org/developer/species#nameUsages}
#' @description
#' This service uses fuzzy lookup so that you can put in partial names and 
#' you should get back those things that match. See examples below.
#' 
#' This function is different from \code{name_lookup} in that that function 
#' searches for names, while this function requires that you already have a key.
#' 
#' Note that verbatim hasn't been working
#' 
#' Options for the data parameter are: 'all', 'verbatim', 'name', 'parents', 'children', 
#' 'related', 'synonyms', 'descriptions','distributions', 'images', 
#' 'references', 'speciesProfiles', 'vernacularNames', 'typeSpecimens', 'root'
#' @export
#' @examples \dontrun{
#' # All name usages
#' name_usage()
#' 
#' # A single name usage
#' name_usage(key=1)
#' 
#' # Name usage for a taxonomic name
#' name_usage(name='Puma concolor')
#' name_usage(name='Puma', rank="GENUS")
#' 
#' # References for a name usage
#' name_usage(key=3119195, data='references')
#' 
#' # Species profiles, descriptions
#' name_usage(key=3119195, data='speciesProfiles')
#' name_usage(key=3119195, data='descriptions')
#' res <- name_usage(key=2435099, data='children')
#' sapply(res$results, "[[", "scientificName")
#' 
#' # Vernacular names for a name usage
#' name_usage(key=3119195, data='vernacularNames')
#' 
#' # Limit number of results returned
#' name_usage(key=3119195, data='vernacularNames', limit=3)
#' 
#' # Search for names by dataset with datasetKey parameter
#' name_usage(datasetKey="d7dddbf4-2cf0-4f39-9b2a-bb099caae36c")
#' 
#' # Search for a particular language
#' name_usage(key=3119195, language="FRENCH", data='vernacularNames')
#' 
#' # Pass on httr options
#' library('httr')
#' res <- name_usage(name='Puma concolor', limit=300, config=progress())
#' }
#' 
#' @examples \donttest{
#' ### Not working right now for some unknown reason
#' # Select many options
#' name_usage(key=3119195, data=c('images','synonyms'))
#' }

name_usage <- function(key=NULL, name=NULL, data='all', language=NULL, datasetKey=NULL, uuid=NULL,
  sourceId=NULL, rank=NULL, shortname=NULL, start=NULL, limit=100, ...)
{
  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- c("sourceId") %in% calls
  if(any(calls_vec))
    stop("Parameters not currently accepted: \n sourceId")
  
  
  args <- rgbif_compact(list(language=language, name=name, datasetKey=datasetKey, 
                       rank=rank, offset=start, limit=limit, sourceId=sourceId))
  data <- match.arg(data, 
      choices=c('all', 'verbatim', 'name', 'parents', 'children',
                'related', 'synonyms', 'descriptions',
                'distributions', 'images', 'references', 'speciesProfiles',
                'vernacularNames', 'typeSpecimens', 'root'), several.ok=TRUE)
  
  # Define function to get data
  getdata <- function(x){
    if(!x == 'all' && is.null(key))
      stop('You must specify a key if data does not equal "all"')
    
    if(x == 'all' && is.null(key)){
      url <- paste0(gbif_base(), '/species')
    } else
    {
      if(x=='all' && !is.null(key)){
        url <- sprintf('%s/species/%s', gbif_base(), key)
      } else
      if(x %in% c('verbatim', 'name', 'parents', 'children', 
         'related', 'synonyms', 'descriptions',
         'distributions', 'images', 'references', 'speciesProfiles',
         'vernacularNames', 'typeSpecimens')){
        url <- sprintf('%s/species/%s/%s', gbif_base(), key, x)
      } else
      if(x == 'root'){
        url <- sprintf('%s/species/root/%s/%s', gbif_base(), uuid, shortname)
      }
    }
    
    gbif_GET(url, args, FALSE, ...)
  }
  
  # Get data
  if(length(data)==1){ out <- getdata(data) } else
  { out <- lapply(data, getdata) }
  
  out
}
