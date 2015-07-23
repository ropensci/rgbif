#' View highlighted terms in name results from GBIF.
#'
#' @export
#'
#' @param input Input output from occ_search
#' @param output Output folder path. If not given uses temporary folder.
#' @param browse (logical) Browse output (default: TRUE)
#'
#' @examples \dontrun{
#' # browse=FALSE returns path to file
#' gbif_names(name_lookup(query='snake', hl=TRUE), browse=FALSE)
#'
#' (out <- name_lookup(query='canada', hl=TRUE, limit=5))
#' gbif_names(out)
#' gbif_names(name_lookup(query='snake', hl=TRUE))
#' gbif_names(name_lookup(query='bird', hl=TRUE))
#'
#' # or not highlight
#' gbif_names(name_lookup(query='bird', limit=200))
#' }

gbif_names <- function(input, output = NULL, browse = TRUE) {
  if (!is(input, "list")) stop("input should be of class list", call. = FALSE)

  input <- input$data
  elements <- gn_tolist(input)
  outfile <- gn_dirhandler(output)
  rr <- whisker.render(gn_template)
  rr <- gsub("&lt;em class=&quot;gbifHl&quot;&gt;", "<b>", rr)
  rr <- gsub("&lt;/em&gt;", "</b>", rr)
  write(rr, file = outfile)
  if (browse) browseURL(outfile) else outfile
}

gn_dirhandler <- function(x, which="file"){
  if (is.null(x)) {
    dir <- tempdir()
    dir.create(dir, recursive = TRUE, showWarnings = FALSE)
    switch(which, file = file.path(dir, "index.html"), dir = dir)
  } else {
    if (!file.exists(x)) dir.create(x, recursive = TRUE, showWarnings = FALSE)
    switch(which, file = file.path(x, "index.html"), dir = x)
  }
}

gn_tolist <- function(x){
  out <- apply(x, 1, function(y){
    tmp <- as.list(y[c('key','canonicalName','parent','rank','kingdom','phylum','order','family','nubKey')])
    tmp[sapply(tmp, function(x) is.null(x) || is.na(x))] <- "none"
    tmp
  })
  addurl <- function(z) {
    if (z$nubKey == "none") {
      c(z, url = paste0("http://www.gbif.org/species/", z$key))
    } else {
      c(z, url = paste0("http://www.gbif.org/species/", z$nubKey))
    }
  }
  Map(addurl, out)
}

gn_template <- '
<!DOCTYPE html>
<head>
<meta charset="utf-8">
<title>rgbif - names</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="View highlighted text elements in names from GBIF">
<meta name="author" content="rgbif">

<link href="http://netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">
<link href="http://netdna.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.css" rel="stylesheet">

</head>

<body>

<div class="container">

<center><h2><i class="fa fa-book"></i> rgbif name viewer</h2></center>

<table class="table table-striped table-hover" align="center">
<thead>
<tr>
<th>Key</th>
<th>Canonical Name</th>
<th>Parent</th>
<th>Rank</th>
<th>Kingdom</th>
<th>Phylum</th>
<th>Order</th>
<th>Family</th>
<th>View</th>
</tr>
</thead>
<tbody>
{{#elements}}
<tr>
<td>{{key}}</td>
<td>{{canonicalName}}</td>
<td>{{parent}}</td>
<td>{{rank}}</td>
<td>{{kingdom}}</td>
<td>{{phylum}}</td>
<td>{{order}}</td>
<td>{{family}}</td>
<td><a href="{{{url}}}" target="_blank"><i class="fa fa-link"></i></a></td>
</tr>
{{/elements}}
</tbody>
</table>
</div>

<script src="http://code.jquery.com/jquery-2.0.3.min.js"></script>
<script src="http://netdna.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

</body>
</html>'
