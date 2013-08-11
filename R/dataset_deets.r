#' Geta details on a dataset.
#' 
#' @import 
#' @param uuid A dataset UUID.
#' @examples \dontrun{
#' dataset_deets(uuid='28573c0a-b833-41b1-9999-56c6b9bce519')
#' dataset_deets(uuid=c('28573c0a-b833-41b1-9999-56c6b9bce519','3f8a1297-3259-4700-91fc-acc4170b27ce'), 'endpoints')
#' }
dataset_deets <- function(uuid, return='all', callopts=list())
{
  # Define function to get data
  getdata <- function(x){
    url <- sprintf('http://api.gbif.org/dataset/%s', x)
    content(GET(url, callopts))
  }
  
  # Get data
  if(length(uuid)==1){ out <- getdata(uuid) } else
  { out <- lapply(uuid, getdata) }
  
  # parse data
  data <- datasetparser(out)
  
  if(return=='contacts'){
    if(length(uuid)==1){ data$contacts } else
    {
      temp <- lapply(data, "[[", "contacts")
      names(temp) <- uuid
      temp
    }
  } else
    if(return=='endpoints'){
      if(length(uuid)==1){ data$endpoints } else
      {
        temp <- lapply(data, "[[", "endpoints")
        names(temp) <- uuid
        temp
      }
    } else
      if(return=='identifiers'){
        if(length(uuid)==1){ data$identifiers } else
        {
          temp <- lapply(data, "[[", "identifiers")
          names(temp) <- uuid
          temp
        }
      } else
      { data }
}
# http://api.gbif.org/dataset/28573c0a-b833-41b1-9999-56c6b9bce519

#' Parser for gbif data
#' @param input A list
#' @param minimal Get minimal input, default to TRUE
#' @export
#' @keywords internal
datasetparser <- function(input, minimal=TRUE){
  parse <- function(x){
    x[sapply(x, length) == 0] <- "none"
    contacts <- ldfast(x$contacts, TRUE)
    endpoints <- ldfast(x$endpoints, TRUE)
    identifiers <- ldfast(x$identifiers, TRUE)
    rest <- x[!names(x) %in% c('contacts','endpoints','identifiers')]
    list(other=rest, contacts=contacts, endpoints=endpoints, identifiers=identifiers)
  }
  if(is.character(input[[1]])){
    parse(input)
  } else
  {
    lapply(input, parse)
  }
}