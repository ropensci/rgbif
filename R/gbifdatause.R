# gbifdatause.R

gbifdatause <- 
# Args:
#   NONE
# Examples:
#   gbifdatause()

function(url = 'http://data.gbif.org/tutorial/datasharingagreement',
  ..., 
  curl = getCurlHandle() ) 
{
  tt <- getURLContent(url)
#   jsonout <- xmlTreeParse(I(tt))  
  return(tt)
}