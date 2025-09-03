#' @name dataset_search
#' @export
dataset_suggest <- function(query = NULL,
                            type = NULL,
                            publishingCountry = NULL,  
                            subtype = NULL,
                            license = NULL,
                            keyword = NULL,
                            publishingOrg = NULL,
                            hostingOrg = NULL,
                            endorsingNodeKey = NULL,
                            decade = NULL,
                            projectId = NULL,
                            hostingCountry = NULL,
                            networkKey = NULL,
                            doi = NULL, 
                            limit = 100,
                            start = NULL,
                            description = FALSE,
                            curlopts = list(http_version = 2)) {
  
  assert(query,"character")
  assert(type,"character")
  assert(subtype,"character")
  assert(license,"character")
  assert(keyword,"character")
  assert(publishingOrg,"character")
  assert(hostingOrg,"character")
  assert(endorsingNodeKey,"character")
  assert(publishingCountry,"character")
  assert(projectId,"character")
  assert(hostingCountry,"character")
  assert(networkKey,"character")
  assert(doi,"character")

  # args with single value 
  args <- as.list(
    rgbif_compact(c(q=query,
                    limit=limit,
                    offset=start
                    )))
  
  args <- rgbif_compact(c(
    args,
    convmany(type),
    convmany(subtype),
    convmany(license),
    convmany(keyword),
    convmany(publishingOrg),
    convmany(hostingOrg),
    convmany(endorsingNodeKey),
    convmany(decade),
    convmany(publishingCountry),
    convmany(projectId),
    convmany(hostingCountry),
    convmany(networkKey),
    convmany(doi)
  ))
  
  url <- paste0(gbif_base(), '/dataset/suggest')
  tt <- gbif_GET(url, args, FALSE, curlopts)
  
  if (description) {
    out <- lapply(tt, "[[", "description")
    names(out) <- lapply(tt, "[[", "title")
    out <- rgbif_compact(out)
  } else {
    if (length(tt) == 1) {
      out <- parse_suggest(x = tt$results)
    } else {
      out <- tibble::as_tibble(setdfrbind(lapply(tt, parse_suggest)))
    }
  }
  out
}

parse_suggest <- function(x){
  tmp <- rgbif_compact(list(
    key = x$key,
    type = x$type,
    title = x$title
  ))
  tibble::as_tibble(tmp)
}
