#' GBIF registry data via OAI-PMH
#'
#' @export
#' @name gbif_oai
#' @param prefix (character) A string to specify the metadata format in OAI-PMH requests issued to
#' the repository. The default (\code{"oai_dc"}) corresponds to the mandatory OAI unqualified
#' Dublin Core metadata schema.
#' @param from (character) string giving datestamp to be used as lower bound for datestamp-based
#' selective harvesting (i.e., only harvest records with datestamps in the given range). Dates
#' and times must be encoded using ISO 8601. The trailing Z must be used when including time.
#' OAI-PMH implies UTC for data/time specifications.
#' @param until (character) Datestamp to be used as an upper bound, for datestamp-based
#' selective harvesting (i.e., only harvest records with datestamps in the given range).
#' @param set (character) A set to be used for selective harvesting (i.e., only
#' harvest records in the given set).
#' @param token	(character) a token previously provided by the server to resume a
#' request where it last left off. 50 is max number of records returned. We will
#' loop for you internally to get all the records you asked for.
#' @param as (character) What to return. One of "df" (for data.frame; default),
#' "list", or "raw" (raw text)
#' @param id,ids (character) The OAI-PMH identifier for the record. Optional.
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @return raw text, list or data.frame, depending on requested output via \code{as}
#' parameter
#' @details These functions only work with GBIF registry data, and do so via the
#' OAI-PMH protocol (https://www.openarchives.org/OAI/openarchivesprotocol.html).
#' @examples \dontrun{
#' gbif_oai_identify()
#'
#' today <- format(Sys.Date(), "%Y-%m-%d")
#' gbif_oai_list_identifiers(from = today)
#' gbif_oai_list_identifiers(set = "country:NL")
#'
#' gbif_oai_list_records(from = today)
#' gbif_oai_list_records(set = "country:NL")
#'
#' gbif_oai_list_metadataformats()
#' gbif_oai_list_metadataformats(id = "9c4e36c1-d3f9-49ce-8ec1-8c434fa9e6eb")
#'
#' gbif_oai_list_sets()
#' gbif_oai_list_sets(as = "list")
#'
#' gbif_oai_get_records("9c4e36c1-d3f9-49ce-8ec1-8c434fa9e6eb")
#' ids <- c("9c4e36c1-d3f9-49ce-8ec1-8c434fa9e6eb",
#'          "e0f1bb8a-2d81-4b2a-9194-d92848d3b82e")
#' gbif_oai_get_records(ids)
#' }
gbif_oai_identify <- function(...) {
  as.list(oai::id(url = gboai(), ...))
}

#' @export
#' @rdname gbif_oai
gbif_oai_list_identifiers <- function(prefix = "oai_dc", from = NULL, until = NULL,
  set = NULL, token = NULL, as = "df", ...) {

  oai::list_identifiers(url = gboai(), from = from, until = until,
        prefix = prefix, set = set, token = token, as = as, ...)
}

#' @export
#' @rdname gbif_oai
gbif_oai_list_records <- function(prefix = "oai_dc", from = NULL, until = NULL,
  set = NULL, token = NULL, as = "df", ...) {

  oai::list_records(url = gboai(), from = from, until = until,
        prefix = prefix, set = set, token = token, as = as, ...)
}

#' @export
#' @rdname gbif_oai
gbif_oai_list_metadataformats <- function(id = NULL, ...) {
  oai::list_metadataformats(url = gboai(), id = id, ...)
}

#' @export
#' @rdname gbif_oai
gbif_oai_list_sets <- function(token = NULL, as = "df", ...) {
  oai::list_sets(url = gboai(), token = token, as = as, ...)
}

#' @export
#' @rdname gbif_oai
gbif_oai_get_records <- function(ids, prefix = "oai_dc", as = "df", ...) {
  oai::get_records(ids = ids, prefix = prefix, url = gboai(), as = as, ...)
}

gboai <- function() {
  file.path(gbif_base(), "oai-pmh/registry")
}
