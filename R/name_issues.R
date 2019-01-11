#' Parse and examine further GBIF name issues on a dataset.
#'
#' @export
#'
#' @param .data Output from a call to [name_usage()], but only if
#'   `return="all"`, or `return="data"`, otherwise function stops with error.
#' @param ... Named parameters to only get back (e.g. bbmn), or to
#' remove (e.g. -bbmn).
#' @param mutate (character) One of:
#'
#' - `split` Split issues into new columns.
#' - `expand` Expand issue abbreviated codes into descriptive names.
#' for downloads datasets, this is not super useful since the
#' issues come to you as expanded already.
#' - `split_expand` Split into new columns, and expand issue names.
#'
#' For split and split_expand, values in cells become y ("yes") or n ("no")
#'
#' @references
#'   <https://gbif.github.io/gbif-api/apidocs/org/gbif/api/vocabulary/NameUsageIssue.html>
#'
#' Note that you can also query based on issues, e.g.,
#' `name_lookup(issue='RANK_INVALID')`. However, I imagine
#' it's more likely that you want to search for species based on a
#' taxonomic group or checklist dataset, not based on issues, so it makes sense
#' to pull data down, then clean as needed using this function.
#'

name_issues <- function(.data, ..., mutate = NULL) {

  assert(.data, c("gbif", "gbif_data", "data.frame", "tbl_df"))

  check_issues(type = "name", ...)

  handle_issues(.data, ..., mutate = mutate)

}
