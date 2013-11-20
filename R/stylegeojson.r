#' Style a data.frame prior to converting to geojson.
#' 
#' @import plyr
#' @param input A data.frame
#' @param var A single variable to map colors, symbols, and/or sizes to.
#' @param var_col The variable to map colors to.
#' @param var_sym The variable to map symbols to.
#' @param var_size The variable to map size to.
#' @param color Valid RGB hex color
#' @param symbol An icon ID from the Maki project \url{http://www.mapbox.com/maki/} or
#'    a single alphanumeric character (a-z or 0-9).
#' @param size One of "small", "medium", or "large"
#' @examples \dontrun{
#' # Get data and save map data
#' splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
#' out <- occurrencelist_many(splist, coordinatestatus = TRUE, maxresults = 50)
#' dat <- gbifdata(out)
#' names(dat)[names(dat) %in% 
#'    c("decimalLatitude","decimalLongitude")] <- c("latitude","longitude")
#' dat2 <- stylegeojson(input=dat, var="taxonName", color=c("#976AAE","#6B944D","#BD5945"), 
#'    size=c("small","medium","large"))
#' head(dat2)
#' }
#' @export
#' @seealso \code{\link{togeojson}}
stylegeojson <- function(input, var = NULL, var_col = NULL, var_sym = NULL, 
                         var_size = NULL, color = NULL, symbol = NULL, size = NULL)
{
  if(!inherits(input,"data.frame"))
    stop("Your input object needs to be a data.frame")
  if(nrow(input)==0) 
    stop("Your data.frame has no rows...")
  
  if(is.null(var_col) & is.null(var_sym) & is.null(var_size))
    var_col <- var_sym <- var_size <- var
  
  if(!is.null(color)){
    if(length(color)==1){
      color_vec <- rep(color, nrow(input))
    } else
    {
      mapping <- data.frame(var=unique(input[[var_col]]), col2=color)
      stuff <- input[[var_col]]
      color_vec <- with(mapping, col2[match(stuff, var)])
    }
  } else { color_vec <- NULL }
  
  if(!is.null(symbol)){
    if(length(symbol)==1){
      symbol_vec <- rep(symbol, nrow(input))
    } else
    {
      mapping <- data.frame(var=unique(input[[var_sym]]), symb=symbol)
      stuff <- input[[var_sym]]
      symbol_vec <- with(mapping, symb[match(stuff, var)])
    }
  } else { symbol_vec <- NULL }
  
  if(!is.null(size)){
    if(length(size)==1){
      size_vec <- rep(size, nrow(input))
    } else
    {
      mapping <- data.frame(var=unique(input[[var_size]]), sz=size)
      stuff <- input[[var_size]]
      size_vec <- with(mapping, sz[match(stuff, var)])
    }
  } else { size_vec <- NULL }
  
  output <- do.call(cbind, compact(list(input, `marker-color` = color_vec, 
                                        `marker-symbol` = symbol_vec, 
                                        `marker-size` = size_vec)))
  return( output )
}