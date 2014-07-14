#' View photos
#' 
#' @import whisker
#' @export
#' @param input Input output from occ_search
#' @param output Output file name and path
#' @param browse (logical) Browse output
#' @examples \dontrun{
#' (res <- occ_search(mediatype = 'StillImage', return = "media"))
#' gbif_photos(res)
#' 
#' res <- occ_search(scientificName = "Helianthus", mediatype = 'StillImage', return = "media")
#' gbif_photos(res)
#' 
#' res <- occ_search(scientificName = "Helianthus", mediatype = 'StillImage', return = "media", limit=400)
#' gbif_photos(res)
#' }

gbif_photos <- function(input = NULL, output = NULL, browse = TRUE)
{
  if(is.null(input))
     stop("Please supply some input")
  
  if(length(input) > 20){
    input <- split(input, ceiling(seq_along(input)/20))
    filenames <- replicate(length(input), tempfile(fileext=".html"))
    filenames <- as.list(filenames)
    links <- list()
    for(i in seq_along(filenames)) links[[i]] <- list(url=filenames[[i]], pagenum=i)
    
    for(i in seq_along(input)){
      photos <- foo(input[[i]])
      rendered <- whisker.render(template)
      paginated <- whisker.render(pagination)
      rendered <- paste0(rendered, paginated, footer)
      write(rendered, file = filenames[[i]])
    }
    
    if(browse) browseURL(filenames[[1]])
  } else {
    photos <- foo(input)
    rendered <- whisker.render(template)
    rendered <- paste0(rendered, footer)
    if(is.null(output))
      output <- tempfile(fileext=".html")
    write(rendered, file = output)
    if(browse) browseURL(output)
  }
}

foo <- function(x){
  photos <- lapply(x, function(y){
    tmp <- y[c('key','species','decimalLatitude','decimalLongitude','country')]
    tmp[sapply(tmp, is.null)] <- "none"
    names(tmp) <- c('key','species','decimalLatitude','decimalLongitude','country')
    list(c(tmp, y[!names(y) %in% c('key','species','decimalLatitude','decimalLongitude','country')][[1]][c(3:4)]))
  })
  do.call(c, unname(photos))
} 

template <- '
<!DOCTYPE html>
<head>
<meta charset="utf-8">
<title>rgbif - photos</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="View photos from GBIF query">
<meta name="author" content="ecoengine">

<link href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet">
<link href="http://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">

</head>

<body>

<div class="container">

<center><h2>rgbif photo viewer</h2></center>

<table class="table table-striped table-hover" align="center">
<thead>
<tr>
<th>Photo</th>
<th>Species</th>
<th>Country</th>
<th>Location</th>
</tr>
</thead>
<tbody>
{{#photos}}
<tr>
<td><a href="{{{references}}}"><img src="{{{identifier}}}" height="250"></a></td>
<td>{{species}}</td>
<td>{{country}}</td>
<td><a href="https://www.google.com/maps/@{{decimalLatitude}},{{decimalLongitude}},15z" class="btn btn-primary btn-sm">Map</a></td>
</tr>
{{/photos}}
</tbody>
</table>
</div>
'

pagination <- '
<center>
  <ul class="pagination pagination-lg">
    {{#links}}
    <li><a href="{{url}}">{{pagenum}}</a></li>
    {{/links}}
  </ul>
</center>
'

footer <- '
<script src="http://code.jquery.com/jquery-2.0.3.min.js"></script>
<script src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>

</body>
</html>'