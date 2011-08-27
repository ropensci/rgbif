# taxonsearch.R

taxonsearch <- 
# Args:
#   sciname: scientitic name of taxon (character, see example)
# Examples:
#   taxonsearch("Puma concolor")

function(sciname = NA,
  url = 'http://data.gbif.org/ws/rest/taxon/list',
  ..., 
  curl = getCurlHandle() ) 
{
  args <- list()
  if(!is.na(sciname))
    args$scientificname <- sub(" ", "+", sciname)
  tt <- getForm(url, 
    .params = args,
    ...,
    curl = curl)
  out <- xmlTreeParse(tt)$doc$children$gbifResponse  
  return(out)
}