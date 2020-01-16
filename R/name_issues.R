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
#' <https://gbif.github.io/gbif-api/apidocs/org/gbif/api/vocabulary/NameUsageIssue.html>
#'
#' @examples \dontrun{
#' # what do issues mean, can print whole table
#' head(gbif_issues())
#' # or just name related issues
#' gbif_issues()[which(gbif_issues()$type %in% c("name")),]
#' # or search for matches
#' gbif_issues()[gbif_issues()$code %in% c('bbmn','clasna','scina'),]
#' # compare out data to after name_issues use
#' (aa <- name_usage(name = "Lupus"))
#' aa %>% name_issues("clasna")
#'
#' ## or parse issues in various ways
#' ### remove data rows with certain issue classes
#' aa %>% name_issues(-clasna, -scina)
#'
#' ### expand issues to more descriptive names
#' aa %>% name_issues(mutate = "expand")
#'
#' ### split and expand
#' aa %>% name_issues(mutate = "split_expand")
#'
#' ### split, expand, and remove an issue class
#' aa %>% name_issues(-bbmn, mutate = "split_expand")
#'
#' ## Or you can use name_issues without %>%
#' name_issues(aa, -bbmn, mutate = "split_expand")
#' }

name_issues <- function(.data, ..., mutate = NULL) {

  assert(.data, c("gbif", "gbif_data", "data.frame", "tbl_df"))

  check_issues(type = "name", ...)

  handle_issues(.data, is_occ = FALSE, ..., mutate = mutate)

}
