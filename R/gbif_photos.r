# library(rgbif)
# library(whisker)
# 
# res <- occ_search(mediatype = 'StillImage', return = "media")
# gbif_photos(res)

gbif_photos <- function(input = NULL, output = NULL, browse = TRUE)
{
  if(is.null(input))
    stop("Please supply some input")

  photos <- lapply(input, function(y){
    tmp <- y[c('key','species')]
    tmp[sapply(tmp, is.null)] <- "none"
    names(tmp) <- c("key","species")
    lapply(y[!names(y) %in% c('key','species')], function(z) c(tmp, z))
  })
  photos <- do.call(c, unname(photos))
#   class(photos) <- "stuff"

template <- '
<!DOCTYPE html>
<head>
<meta charset="utf-8">
<title>rgbif - photos</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="View photos from GBIF query">
<meta name="author" content="ecoengine">

<!-- Le styles -->
<style>
<link href="http://netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap.min.css" rel="stylesheet">
<link href="http://netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap.css" rel="stylesheet">
<link href="http://netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap-responsive.css" rel="stylesheet">
</style>
</head>

<body>

<div class="container">

<center><h2>rgbif Photo Viewer</h2></center>

<table class="table table-striped table-hover" align="center">
<thead>
<tr>
<th>Photo</th>
<th>Species</th>
<th>Occurrence key</th>
</tr>
</thead>
<tbody>
{{#photos}}
<tr>
<td><a href="{{references}}"><img src="{{identifier}}" height="250"></a></td>
<td>{{species}}</td>
<td>{{value}}</td>
</tr>
{{/photos}}
</tbody>
</table>
</div>

<script src="http://code.jquery.com/jquery-2.0.3.min.js"></script>
<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.2/js/bootstrap.min.js"></script>

</body>
</html>'

#   rendered <- 
    cat(whisker.render(template))
#   rendered <- gsub("&lt;em&gt;", "<b>", rendered)
#   rendered <- gsub("&lt;/em&gt;", "</b>", rendered)
#   if(is.null(output))
#     output <- tempfile(fileext=".html")
#   write(rendered, file = output)
#   if(browse) browseURL(output)
}

# <th>Country</th>
#   <th>Location</th>
# <td>{{country}}</td>
#   <td>{{decimalLatitude}},{{decimalLongitude}}</td>