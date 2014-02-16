#' Post a file as a Github gist
#' 
#' @import httr
#' @param gist An object
#' @param description brief description of gist (optional)
#' @param public whether gist is public (default: TRUE)
#' @description 
#' You will be asked ot enter you Github credentials (username, password) during
#' each session, but only once for each session. Alternatively, you could enter
#' your credentials into your .Rprofile file with the entries
#' 
#' \enumerate{
#'  \item options(github.username = "your_github_username")
#'  \item options(github.password = "your_github_password")
#' }
#' 
#' then \code{gist} will simply read those options.
#' 
#' \code{gist} was modified from code in the rCharts package by Ramnath Vaidyanathan 
#' @return Posts your file as a gist on your account, and prints out the url for the 
#' gist itself in the console.
#' @examples \dontrun{
#' library(plyr)
#' splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
#' keys <- sapply(splist, function(x) name_backbone(name=x, kingdom='plants')$speciesKey, 
#'    USE.NAMES=FALSE)
#' out <- occ_search(keys, georeferenced=TRUE, limit=50, return="data")
#' dat <- ldply(out)
#' datgeojson <- stylegeojson(input=dat, var="name", color=c("#976AAE","#6B944D","#BD5945"),
#'    size=c("small","medium","large"))
#' write.csv(datgeojson, "~/my.csv")
#' togeojson(input="~/my.csv", method="web", outfilename="my")
#' gist("~/my.geojson", description = "Occurrences of three bird species mapped")
#' }
#' @export
gist <- function(gist, description = "", public = TRUE)
{
  dat <- create_gist(gist, description = description, public = public)
  credentials = get_credentials()
  response = POST(
    url = 'https://api.github.com/gists',
    body = dat,
    config = c(
      authenticate(
        getOption('github.username'), 
        getOption('github.password'), 
        type = 'basic'
      ),
      add_headers("User-Agent" = "Dummy")
    )
  )
  stop_for_status(response)
  html_url = content(response)$html_url
  message('Your gist has been published')
  message('View gist at ', 
          paste("https://gist.github.com/", 
                getOption('github.username'), 
                "/", basename(html_url), sep=""))
  invisible(basename(html_url))
}

#' Function that takes a list of files and creates payload for API
#' @param filenames names of files to post
#' @param description brief description of gist (optional)
#' @param public whether gist is public (defaults to TRUE)
#' @export
#' @keywords internal
create_gist <- function(filenames, description = "", public = TRUE){
  files = lapply(filenames, function(file){
    x = list(content =  paste(readLines(file, warn = F), collapse = "\n"))
  })
  names(files) = basename(filenames)
  body = list(description = description, public = public, files = files)
  RJSONIO::toJSON(body)
}

#' Get Github credentials from use in console
#' @export
#' @keywords internal
get_credentials = function(){
  if (is.null(getOption('github.username'))){
    username <- readline("Please enter your github username: ")
    options(github.username = username)
  }
  if (is.null(getOption('github.password'))){
    password <- readline("Please enter your github password: ")
    options(github.password = password)
  }
}