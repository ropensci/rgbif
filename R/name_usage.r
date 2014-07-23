#' Lookup details for specific names in all taxonomies in GBIF.
#'
#' @template all
#' @template occ
#' @template nameusage
#' @import httr plyr
#' @return A list of length two. The first element is metadata. The second is 
#' either a data.frame (verbose=FALSE, default) or a list (verbose=TRUE)
#' @description
#' This service uses fuzzy lookup so that you can put in partial names and 
#' you should get back those things that match. See examples below.
#' 
#' This function is different from \code{name_lookup} in that that function 
#' searches for names, while this function requires that you already have a key.
#' 
#' Note that verbatim hasn't been working for me.
#' 
#' Options for the data parameter are: 'all', 'verbatim', 'name', 'parents', 'children', 
#' 'descendants', 'related', 'synonyms', 'descriptions','distributions', 'images', 
#' 'references', 'species_profiles', 'vernacular_names', 'type_specimens'
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
#' }
#' 
#' @examples \donttest{
#' ### Not working right now for some unknown reason
#' # Select many options
#' name_usage(key=3119195, data=c('images','synonyms'))
#' }

name_usage <- function(key=NULL, name=NULL, data='all', language=NULL, datasetKey=NULL, uuid=NULL,
  sourceId=NULL, rank=NULL, shortname=NULL, start=NULL, limit=20, callopts=list())
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
      url <- 'http://api.gbif.org/v1/species'
    } else
    {
      if(x=='all' && !is.null(key)){
        url <- sprintf('http://api.gbif.org/v1/species/%s', key)
      } else
      if(x %in% c('verbatim', 'name', 'parents', 'children', 
         'related', 'synonyms', 'descriptions',
         'distributions', 'images', 'references', 'speciesProfiles',
         'vernacularNames', 'typeSpecimens')){
        url <- sprintf('http://api.gbif.org/v1/species/%s/%s', key, x)
      } else
      if(x == 'root'){
        url <- sprintf('http://api.gbif.org/v1/species/root/%s/%s', uuid, shortname)
      }
    }
    tt <- GET(url, query=args, callopts)
    stop_for_status(tt)
    assert_that(tt$headers$`content-type`=='application/json')
    res <- content(tt, as = 'text', encoding = "UTF-8")
    RJSONIO::fromJSON(res, simplifyWithNames = FALSE)
  }
  
  # Get data
  if(length(data)==1){ out <- getdata(data) } else
  { out <- lapply(data, getdata) }
  
  out
}