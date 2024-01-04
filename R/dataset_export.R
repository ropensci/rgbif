#' @name dataset_search
#' @export
dataset_export <- function(query = NULL,
                           type = NULL,
                           publishingCountry= NULL,  
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
                           doi = NULL
                           ) {
  
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
  args <- rgbif_compact(list(
            format = "TSV",
            q = query
            ))
  
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
  
  url_query <- paste0(names(args),"=",args,collapse="&")
  url <- paste0(gbif_base(),"/dataset/search/export?",url_query)
  url <- gsub("\\[|\\]","",url)
  url <- utils::URLencode(url)
  temp_file <- tempfile()
  utils::download.file(url,destfile=temp_file,quiet=TRUE)
  out <- tibble::as_tibble(data.table::fread(temp_file, showProgress=FALSE))
  colnames(out) <- to_camel(colnames(out))
  out[] <- lapply(out, as.character)
  out$occurrenceRecordsCount <- as.numeric(out$occurrenceRecordsCount)
  out$nameUsagesCount <- as.numeric(out$nameUsagesCount)
  out
}
