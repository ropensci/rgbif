#' @importFrom V8 new_context
terr <- NULL
.onLoad <- function(libname, pkgname){
  terr <<- V8::new_context();
  terr$source(system.file("js/terraformer-wkt-parser.js", package = pkgname))
}
