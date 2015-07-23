#' View photos from GBIF.
#'
#' @importFrom whisker whisker.render
#' @export
#' @param input Input output from occ_search
#' @param output Output folder path. If not given uses temporary folder.
#' @param which One of map or table (default).
#' @param browse (logical) Browse output (default: TRUE)
#' @details The max number of photos you can see when which="map" is ~160, so cycle through
#' if you have more than that.
#' @examples \dontrun{
#' (res <- occ_search(mediatype = 'StillImage', return = "media"))
#' gbif_photos(res)
#' gbif_photos(res, which='map')
#'
#' res <- occ_search(scientificName = "Aves", mediatype = 'StillImage', return = "media", limit=150)
#' gbif_photos(res)
#' gbif_photos(res, output = '~/barfoo')
#' }

gbif_photos <- function(input, output = NULL, which='table', browse = TRUE) {
  if (!is(input, "gbif")) stop("input should be of class gbif", call. = FALSE)

  which <- match.arg(which, c("map", "table"))
  if (which == 'map') {
    photos <- foo(input)
    outfile <- dirhandler(output)
    filepath <- system.file("singlemaplayout.html", package = "rgbif")
    ff <- paste(readLines(filepath), collapse = "\n")
    rr <- whisker.render(ff)
    write(rr, file = outfile)
    if (browse) browseURL(outfile) else outfile
  } else {
    if (length(input) > 20) {
      outdir <- dirhandler(output, 'dir')
      input <- split(input, ceiling(seq_along(input)/20))
      filenames <- replicate(length(input), path.expand(tempfile(fileext = ".html", tmpdir = outdir)))
      filenames <- as.list(filenames)
      links <- list()
      for (i in seq_along(filenames)) links[[i]] <- list(url = filenames[[i]], pagenum = i)

      for (i in seq_along(input)) {
        photos <- foo(input[[i]])
        mappaths <- makemapfiles(photos, outdir)
        photos <- Map(function(x,y) c(x, mappath = y), photos, mappaths)
        rendered <- whisker.render(template)
        paginated <- whisker.render(pagination)
        rendered <- paste0(rendered, paginated, footer)
        write(rendered, file = filenames[[i]])
      }

      if (browse) browseURL(filenames[[1]]) else filenames[[1]]
    } else {
      outfile <- dirhandler(output)
      outdir <- dirname(outfile)
      photos <- foo(input)
      mappaths <- makemapfiles(photos, outdir)
      photos <- Map(function(x,y) c(x, mappath = y), photos, mappaths)
      rendered <- whisker.render(template)
      rendered <- paste0(rendered, footer)
      write(rendered, file = outfile)
      if (browse) browseURL(outfile) else outfile
    }
  }
}

dirhandler <- function(x, which="file"){
  if (is.null(x)) {
    dir <- tempdir()
    dir.create(dir, recursive = TRUE, showWarnings = FALSE)
    switch(which, file = file.path(dir, "index.html"), dir = dir)
  } else {
    if (!file.exists(x)) dir.create(x, recursive = TRUE, showWarnings = FALSE)
    switch(which, file = file.path(x, "index.html"), dir = x)
  }
}

foo <- function(x){
  photos <- lapply(x, function(y){
    if (is.null(y$decimalLatitude) || is.null(y$decimalLongitude)) {
      NULL
    } else {
      tmp <- y[c('key','species','decimalLatitude','decimalLongitude','country')]
      tmp[sapply(tmp, is.null)] <- "none"
      names(tmp) <- c('key','species','decimalLatitude','decimalLongitude','country')
      list(c(tmp, y[!names(y) %in% c('key','species','decimalLatitude','decimalLongitude','country')][[1]][c(3:4)]))
    }
  })
  do.call(c, unname(rgbif_compact(photos)))
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
<th>Species</th>
<th>Photo</th>
<th>Location</th>
</tr>
</thead>
<tbody>
{{#photos}}
<tr>
<td><i>{{species}}</i></td>
<td><a href="{{{references}}}"><img src="{{{identifier}}}" height="200" style="border-radius: 10px 10px 10px 10px; max-width: 400px"></a></td>
<td><iframe src="{{mappath}}" width="400" height="200" frameborder="0"></iframe></td>
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

makemapfiles <- function(x, dir){
  mapfiles <- list()
  for (i in seq_along(x)) {
    file <- path.expand(tempfile("map", tmpdir = dir, fileext = ".html"))
    mapfiles[[i]] <- file
    tmp <- whisker.render(map, data = x[[i]])
    write(tmp, file = file)
  }
  mapfiles
}

map <- '
<!DOCTYPE html>
<html>
<head>
<meta charset=utf-8 />
<title>Single marker</title>
<meta name="viewport" content="initial-scale=1,maximum-scale=1,user-scalable=no" />
<script src="https://api.tiles.mapbox.com/mapbox.js/v1.6.4/mapbox.js"></script>
<link href="https://api.tiles.mapbox.com/mapbox.js/v1.6.4/mapbox.css" rel="stylesheet" />
<style>
  body { margin:0; padding:0; }
  #map { position:absolute; top:0; bottom:0; width:100%; }
</style>
</head>
<body>

<div id="map"></div>

<script>
var map = L.mapbox.map("map", "examples.map-i86nkdio")
    .setView([{{decimalLatitude}}, {{decimalLongitude}}], 5);

L.mapbox.featureLayer({
    type: "Feature",
    geometry: {
        type: "Point",
        coordinates: [ {{decimalLongitude}}, {{decimalLatitude}} ]
    },
    properties: {
        "title": "{{species}}",
        "marker-size": "large",
        "marker-color": "#FB8A24",
        "marker-symbol": "garden"
}
}).addTo(map);
</script>

  </body>
  </html>
'
