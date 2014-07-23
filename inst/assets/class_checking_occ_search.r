ifnotnullcheck <- function(x, check='is.character'){
  if(!is.null(x))
    switch(check,
           is.numeric = if(!is.numeric(eval(x))) sprintf("%s should be of type numeric", deparse(substitute(x))),
           is.character = if(!is.character(eval(x))) sprintf("%s should be of type character", deparse(substitute(x))),
           character_numeric = if(!is.character(eval(x)) && !is.numeric(x)) sprintf("%s should be of type character or numeric", deparse(substitute(x))),
           is.factor = if(!is.factor(eval(x))) sprintf("%s should be of type factor", deparse(substitute(x))),
           is.list = if(!is.list(eval(x))) sprintf("%s should be of type list", deparse(substitute(x))),
           is.date = if(!is.date(eval(x))) sprintf("%s should be of type date", deparse(substitute(x))),
           is.logical = if(!is.date(eval(x))) sprintf("%s should be of type logical", deparse(substitute(x))))
}

check_params <- function(){
  # numerics
  b <- ifnotnullcheck(taxonKey, "is.numeric")
  g <- ifnotnullcheck(recordNumber, "is.numeric")
  z <- ifnotnullcheck(limit, "is.numeric")
  aa <- ifnotnullcheck(start, "is.numeric")
  # characters
  a <- ifnotnullcheck(scientificName, "is.character")
  c <- ifnotnullcheck(country, "is.character")
  d <- ifnotnullcheck(publishingCountry, "is.character")
  f <- ifnotnullcheck(typeStatus, "is.character")
  i <- ifnotnullcheck(continent, "is.character")
  j <- ifnotnullcheck(geometry, "is.character")
  k <- ifnotnullcheck(collectorName, "is.character")
  l <- ifnotnullcheck(basisOfRecord, "is.character")
  m <- ifnotnullcheck(datasetKey, "is.character")
  o <- ifnotnullcheck(catalogNumber, "is.character")
  v <- ifnotnullcheck(institutionCode, "is.character")
  w <- ifnotnullcheck(collectionCode, "is.character")
  y <- ifnotnullcheck(search, "is.character")
  # character or numeric
  n <- ifnotnullcheck(eventDate, "character_numeric")
  p <- ifnotnullcheck(year, "character_numeric")
  q <- ifnotnullcheck(month, "character_numeric")
  h <- ifnotnullcheck(lastInterpreted, "character_numeric")
  r <- ifnotnullcheck(decimalLatitude, "character_numeric")
  s <- ifnotnullcheck(decimalLongitude, "character_numeric")
  t <- ifnotnullcheck(elevation, "character_numeric")
  u <- ifnotnullcheck(depth, "character_numeric")
  # logicals
  e <- ifnotnullcheck(hasCoordinate, "is.logical")
  x <- ifnotnullcheck(spatialIssues, "is.logical")
  out <- rgbif_compact(list(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,aa))
  if(length(out)==0){ NULL } else {
    res <- paste(out, collapse = "\n")
    stop(res)
  }
}