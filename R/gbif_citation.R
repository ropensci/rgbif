#' Get citation for datasets used
#'
#' @export
#' @param x (character) Result of call to \code{occ_search}, \code{occ_download_get},
#' a dataset key, or occurrence key (character or numeric).
#' @return list with S3 class assigned, used by a print method to pretty print
#' citation information. Though you can unclass the output or just index to the
#' named items as needed.
#' @details Returns a set of citations, one for each dataset. We pull out unique dataset keys
#' and get citations, so the length of citations may not be equal to the number of records you
#' pass in.
#'
#' Currently, this function gives back citations at the dataset level, not at the individual
#' occurrence level. If occurrence keys are passed in, then we track down the dataset
#' the key is from, and get the citation for the dataset.
#' @examples \dontrun{
#' res1 <- occ_search(taxonKey=3119195, limit=2)
#' (xx <- gbif_citation(res1))
#'
#' res2 <- occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a',
#'  return='data', limit=20)
#' (xx <- gbif_citation(res2))
#'
#' # if no datasetKey field included, we attempt to identify the dataset
#' ## key field included - still works
#' res3 <- occ_search(taxonKey=3119195, fields=c('name','basisOfRecord','key'), limit=20)
#' (xx <- gbif_citation(res3))
#' ## key field not included - errors
#' # res3 <- occ_search(taxonKey=3119195, fields=c('name','basisOfRecord','protocol'), limit=20)
#' # (xx <- gbif_citation(res3))
#'
#' # character class inputs
#' ## pass in a dataset key
#' gbif_citation(x='0ec3229f-2b53-484e-817a-de8ceb1fce2b')
#' ## pass in an occurrence key
#' gbif_citation(x='766766824')
#'
#' # pass in an occurrence key as a numeric
#' gbif_citation(x=766766824)
#'
#' # Downloads
#' ## only works with output from occ_download_get for now
#' d1 <- occ_download_get("0000066-140928181241064", overwrite = TRUE)
#' gbif_citation(d1)
#' }
gbif_citation <- function(x) {
  UseMethod("gbif_citation")
}

#' @export
gbif_citation.gbif <- function(x) {
  if (!is(x, "data.frame")) {
    x <- x$data
  }
  dkeys <- unique(x$datasetKey)
  if (is.null(dkeys)) {
    occ_keys <- x$key
    if (!is.null(occ_keys)) {
      dkeys <- unique(vapply(occ_get(unique(occ_keys), fields = "all"), "[[", "", c('data', 'datasetKey')))
    } else {
      stop("No 'datasetKey' or 'key' fields found", call. = FALSE)
    }
  }

  lapply(dkeys, function(z) {
    tmp <- datasets(uuid = z)
    cit <- list(title = tmp$data$title,
      text = tmp$data$citation$text,
      accessed = paste0("Accessed from R via rgbif (https://github.com/ropensci/rgbif) on ", Sys.Date()))
    cit$citation <- paste(cit$text, cit$accessed, sep = ". ")
    structure(list(citation = cit, rights = tmp$data$rights), class = "gbif_citation")
  })
}

#' @export
gbif_citation.character <- function(x) {
  tmp <- as_occ_d_key(x)
  cit <- list(title = tmp$data$title,
              text = tmp$data$citation$text,
              accessed = paste0("Accessed from R via rgbif (https://github.com/ropensci/rgbif) on ", Sys.Date()))
  cit$citation <- paste(cit$text, cit$accessed, sep = ". ")
  structure(list(citation = cit, rights = tmp$data$rights), class = "gbif_citation")
}

#' @export
gbif_citation.numeric <- function(x) {
  tmp <- as_occ_d_key(x)
  cit <- list(title = tmp$data$title,
              text = tmp$data$citation$text,
              accessed = paste0("Accessed from R via rgbif (https://github.com/ropensci/rgbif) on ", Sys.Date()))
  cit$citation <- paste(cit$text, cit$accessed, sep = ". ")
  structure(list(citation = cit, rights = tmp$data$rights), class = "gbif_citation")
}

#' @export
gbif_citation.occ_download_get <- function(x) {
  path <- x[1]
  tmpdir <- file.path(tempdir(), x)
  unzip(path, exdir = tmpdir, overwrite = TRUE)
  on.exit(unlink(tmpdir))
  dsets <- list.files(file.path(tmpdir, "dataset"), full.names = TRUE)
  lapply(dsets, get_cit_rights)
}

get_cit_rights <- function(x) {
  xml <- xml2::read_xml(x)
  key <- gsub("\\..+", "", basename(x))
  rights <- xml2::xml_text(xml2::xml_find_all(xml, "//intellectualRights"))
  title <- xml2::xml_text(xml2::xml_find_all(xml, "//title"))
  citation <- xml2::xml_text(xml2::xml_find_all(xml, "//citation"))
  cit <- list(key = key, title = title, text = citation,
              accessed = paste0("Accessed from R via rgbif (https://github.com/ropensci/rgbif) on ", Sys.Date()))
  cit$citation <- paste(cit$text, cit$accessed, sep = ". ")
  structure(list(citation = cit, rights = rights), class = "gbif_citation")
}

#' @export
print.gbif_citation <- function(x, indent = 3, width = 80, ...) {
  cat("<<rgbif citation>>", sep = "\n")
  cat(rgbif_wrap("  Citation: ", x$citation$citation, indent = indent, width = width), sep = "\n")
  cat(rgbif_wrap("  Rights: ", x$rights, indent = indent, width = width), "\n", sep = "")
}

as_occ_d_key <- function(x) {
  if (is_dataset_key_pattern(x)) {
    datasets(uuid = x)
  } else {
    if (is_occ_key(x)) {
      key <- occ_get(as.numeric(x), fields = "all")$data$datasetKey
      datasets(uuid = key)
    } else {
      stop("Pass in either an occurrence key or dataset key", call. = FALSE)
    }
  }
}

is_occ_key <- function(x) {
  res <- HEAD(paste0("http://api.gbif.org/v1/occurrence/", x))
  res$status_code <= 201
}

# is_dataset_key <- function(x) {
#   does_dataset_key_exist(x) && is_dataset_key_pattern(x)
# }

# does_dataset_key_exist <- function(x) {
#   res <- HEAD(paste0("http://api.gbif.org/v1/dataset/", x))
#   res$status_code <= 201
# }

is_dataset_key_pattern <- function(x) {
  grepl("^[A-Za-z0-9]{8}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{12}$", x)
}
