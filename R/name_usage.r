#' Lookup details for specific names in all taxonomies in GBIF.
#'
#' @template all
#' @import httr
#' @import plyr
#' @param key A key for a taxon
#' @param data Specify an option to select what data is returned. See Description
#'    below.
#' @param language Language, default is english
#' @param datasetKey Dataset key
#' @param sourceId Source id
#' @param rank Taxonomic rank
#' @param uuid A uuid for a dataset.
#' @param shortname A short name..need more info on this...
#' @param callopts Options passed on to GET
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
#' 'references', 'species_profiles', 'vernacular_names', 'type_specimens', 'root'
#' @export
#' @examples \dontrun{
#' # All name usages
#' name_usage()
#' 
#' # A single name usage
#' name_usage(key=1)
#' 
#' # References for a name usage
#' name_usage(key=3119195, data='references')
#' 
#' # Vernacular names for a name usage
#' name_usage(key=3119195, data='vernacular_names')
#' 
#' # Select many options
#' name_usage(key=3119195, data=c('images','synonyms'))
#' }
name_usage <- function(key=NULL, data='all', language=NULL, datasetKey=NULL,
  sourceId=NULL, rank=NULL, uuid=NULL, shortname=NULL, callopts=list())
{
  args <- compact(list(language=language, datasetKey=datasetKey, 
                       sourceId=sourceId, rank=rank))  
  data <- match.arg(data, 
                    choices=c('all', 'verbatim', 'name', 'parents', 'children', 
                              'descendants', 'related', 'synonyms', 'descriptions',
                              'distributions', 'images', 'references', 'species_profiles',
                              'vernacular_names', 'type_specimens', 'root'), several.ok=TRUE)
  
  # Define function to get data
  getdata <- function(x){
    if(!x == 'all' && is.null(key))
      stop('You must specify a key if data does not equal "all"')
    
    if(x == 'all' && is.null(key)){
      url <- 'http://api.gbif.org/v0.9/species'
    } else
    {
      if(x=='all' && !is.null(key)){
        url <- sprintf('http://api.gbif.org/v0.9/species/%s', key)
      } else
      if(x %in% c('verbatim', 'name', 'parents', 'children', 
         'descendants', 'related', 'synonyms', 'descriptions',
         'distributions', 'images', 'references', 'species_profiles',
         'vernacular_names', 'type_specimens')){
        url <- sprintf('http://api.gbif.org/v0.9/species/%s/%s', key, x)
      } else
      if(x == 'root'){
        url <- sprintf('http://api.gbif.org/v0.9/species/root/%s/%s', uuid, shortname)
      }
    }
    tt <- GET(url, query=args, callopts)
    stop_for_status(tt)
    content(tt)
  }
  
  # Get data
  if(length(data)==1){ out <- getdata(data) } else
  { out <- lapply(data, getdata) }
  
  out
}