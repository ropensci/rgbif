#' Get citation for datasets used
#'
#' @export
#' @param x (character) Result of call to [occ_download_get()], [occ_download_meta()].
#' @return list with S3 class assigned, used by a print method to pretty print
#' citation information. Though you can unclass the output or just index to the
#' named items as needed.
#' @details 
#' The function is deprecated for use with [occ_search()] and [occ_data()] 
#' results, and is deprecated for use with datasetKeys and gbifids. Instead,
#' we encourage you to use [derived_dataset()] instead. 
#' 
#' [occ_download_get()] and [occ_download_meta()] results are still supported.
#' 
#' @examples \dontrun{
#' # Downloads
#' ## occ_download_get()
#' # d1 <- occ_download(pred("country", "BG"), pred_gte("year", 2020))
#' # occ_download_meta(d1) # wait until status = succeeded
#' # d1 <- occ_download_get(d1, overwrite = TRUE)
#' # gbif_citation(d1)
#'
#' ## occ_download_meta()
#' # key <- "0000122-171020152545675"
#' # res <- occ_download_meta(key)
#' # gbif_citation(res)
#' }
gbif_citation <- function(x) {
  UseMethod("gbif_citation")
}

#' @export
gbif_citation.gbif <- function(x) {
  .Deprecated(msg="gbif_citation() for occ_search() and occ_data() is deprecated. \nUse rgbif::occ_download() or rgbif::derived_dataset() instead.")
  if (!inherits(x, "data.frame")) {
    x <- x$data
  }
  dkeys <- unique(suppressWarnings(x$datasetKey))
  if (is.null(dkeys)) {
    occ_keys <- x$key
    if (!is.null(occ_keys)) {
      dkeys <- unique(vapply(occ_get(as.numeric(unique(occ_keys)),fields = "all"), "[[", "", c('data', 'datasetKey')))
    } else {
      stop("No 'datasetKey' or 'key' fields found", call. = FALSE)
    }
  }
  
  lapply(dkeys, function(z) {
    tmp <- dataset_get(uuid = z)
    cit <- list(title = tmp$title,
                text = tmp$citation$text,
                accessed =
                  paste0(
                    "Accessed from R via rgbif (https://github.com/ropensci/rgbif) on ",
                    Sys.Date()))
    cit$citation <- paste(cit$text, cit$accessed, sep = ". ")
    structure(list(citation = cit, rights = tmp$rights %||% tmp$license),
              class = "gbif_citation")
  })
}

#' @export
gbif_citation.gbif_data <- gbif_citation.gbif

#' @export
gbif_citation.character <- function(x) {
  if (is_download_key(x)) {
    gbif_citation.occ_download_meta(occ_download_meta(x))
  } else {
    .Deprecated(msg="gbif_citation() for datasetKeys is deprecated since rgbif 3.8.0. \nUse rgbif::derived_dataset() instead.")
    tmp <- as_occ_d_key(x)
    print(tmp$citation)
    cit <- list(
      title = tmp$title,
      text = tmp$citation$text,
      accessed =
        paste0(
          "Accessed from R via rgbif (https://github.com/ropensci/rgbif) on ",
          Sys.Date()))
    cit$citation <- paste(cit$text, cit$accessed, sep = ". ")
    structure(list(citation = cit, rights = tmp$rights %||% tmp$license),
              class = "gbif_citation")
    
  }
  
}

#' @export
gbif_citation.numeric <- function(x) {
  .Deprecated(msg="gbif_citation() for gbifids is deprecated since rgbif 3.8.0. \nUse rgbif::derived_dataset() instead.")
  tmp <- as_occ_d_key(x)
  cit <- list(
    title = tmp$title,
    text = tmp$citation$text,
    accessed =
      paste0(
        "Accessed from R via rgbif (https://github.com/ropensci/rgbif) on ",
        Sys.Date()))
  cit$citation <- paste(cit$text, cit$accessed, sep = ". ")
  structure(list(citation = cit, rights = tmp$rights %||% tmp$license),
            class = "gbif_citation")
}

gbif_cit <- "GBIF Occurrence Download %s Accessed from R via rgbif (https://github.com/ropensci/rgbif) on %s"

#' @export
gbif_citation.occ_download_get <- function(x) {
  # get DOI for citation
  met <- occ_download_meta(attr(x, "key"))
  doi_url <- if (is.null(met$doi)) {
    file.path("https://www.gbif.org/occurrence/download", attr(x, "key"))
  } else {
    file.path("https://doi.org", sub("doi:", "", met$doi))
  }
  citation <- sprintf(gbif_cit, doi_url, as.character(as.Date(met$created)))

  # individual datasets
  tmpdir <- file.path(tempdir(), met$key)
  utils::unzip(x[1], exdir = tmpdir, overwrite = TRUE)
  on.exit(unlink(tmpdir))
  dsets <- list.files(file.path(tmpdir, "dataset"), full.names = TRUE)
  list(
    download = citation,
    datasets = lapply(dsets, get_cit_rights)
  )
}

#' @export
gbif_citation.occ_download_meta <- function(x) {
  doi_url <- if (is.null(x$doi)) {
    file.path("https://www.gbif.org/occurrence/download", x$key)
  } else {
    file.path("https://doi.org", sub("doi:", "", x$doi))
  }
  citation <- sprintf(gbif_cit, doi_url, as.character(as.Date(x$created)))

  list(
    download = citation,
    datasets = NULL # keeping this for legacy reasons
  )
}


### helpers ----------------------------------------------------
get_cit_rights <- function(x) {
  xml <- xml2::read_xml(x)
  key <- gsub("\\..+", "", basename(x))
  rights <- xml2::xml_text(xml2::xml_find_all(xml, "//intellectualRights"))
  title <- xml2::xml_text(xml2::xml_find_all(xml, "//title"))
  citation <- xml2::xml_text(xml2::xml_find_all(xml, "//citation"))
  cit <- list(
    key = key, title = title, text = citation,
    accessed =
      paste0(
        "Accessed from R via rgbif (https://github.com/ropensci/rgbif) on ",
        Sys.Date()))
  cit$citation <- paste(cit$text, cit$accessed, sep = ". ")
  structure(list(citation = cit, rights = rights), class = "gbif_citation")
}

#' @export
print.gbif_citation <- function(x, indent = 3, width = 80, ...) {
  cat("<<rgbif citation>>", sep = "\n")
  cat(rgbif_wrap("  Citation: ", x$citation$citation, indent = indent,
                 width = width), sep = "\n")
  cat(rgbif_wrap("  Rights: ", x$rights, indent = indent, width = width),
      "\n", sep = "")
}

as_occ_d_key <- function(x) {
  if (is_uuid(x)) {
    dataset_get(x)
  }
  else {
    if (is_occ_key(x)) {
      key <- occ_get(as.numeric(x), fields = "all")[[1]]$data$datasetKey
      dataset_get(key)
    } else {
      stop("Pass in either an occurrence key or dataset key", call. = FALSE)
    }
  }
}

is_occ_key <- function(x) {
  cli <- crul::HttpClient$new(
    url = paste0("https://api.gbif.org/v1/occurrence/", x), headers = rgbif_ual
  )
  temp <- cli$head()
  temp$status_code <= 201
}

