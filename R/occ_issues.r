#' Parse and examine further GBIF issues on a dataset
#'
#' @export
#'
#' @param .data Output from a call to [occ_search()], [occ_data()], or
#' [occ_download_import()], but only if `return="all"`, or `return="data"`,
#' otherwise function stops with error. The data from `occ_download_import`
#' is just a regular data.frame so you can pass in a data.frame to this
#' function, but if it doesn't have certain columns it will fail.
#' @param ... Named parameters to only get back (e.g., cdround), or to
#' remove (e.g. -cdround).
#' @param mutate (character) One of:
#'
#' - `split` Split issues into new columns
#' - `split_expand` Split into new columns, and expand issue names
#' - `expand` Expand issue abbreviated codes into descriptive names.
#' for downloads datasets, this is not super useful since the
#' issues come to you as expanded already.
#'
#' For split and split_expand, values in cells become y ("yes") or n ("no")
#'
#' @references
#' <http://gbif.github.io/gbif-api/apidocs/org/gbif/api/vocabulary/OccurrenceIssue.html>
#'
#' @details See also the vignette **Cleaning data using GBIF issues**
#'
#' Note that you can also query based on issues, e.g.,
#' `occ_search(taxonKey=1, issue='DEPTH_UNLIKELY')`. However, I imagine
#' it's more likely that you want to search for occurrences based on a
#' taxonomic name, or geographic area, not based on issues, so it makes sense
#' to pull data down, then clean as needed using this function.
#'
#' This function only affects the `data` element in the `gbif` class that is
#' returned from a call to [occ_search()]. Maybe in a future version
#' we will remove the associated records from the `hierarchy` and `media`
#' elements as they are remove from the `data` element.
#'
#' You'll notice that we sort columns to make it easier to glimpse the important
#' parts of your data, namely taxonomic name, taxon key, latitude and longitude,
#' and the issues. The columns are unchanged otherwise.
#'
#' @examples \dontrun{
#' ## what do issues mean, can print whole table, or search for matches
#' head(gbif_issues())
#' iss <- c('cdround','cudc','gass84','txmathi')
#' gbif_issues()[ gbif_issues()$code %in% iss, ]
#'
#' # compare out data to after occ_issues use
#' (out <- occ_search(limit=100))
#' out %>% occ_issues(cdround)
#'
#' # occ_data
#' (out <- occ_data(limit=100))
#' out %>% occ_issues(cdround)
#'
#' # Parsing output by issue
#' (res <- occ_data(
#'   geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))',
#'   limit = 600))
#'
#' ## or parse issues in various ways
#' ### inlude only rows with cdround issue
#' gg <- res %>% occ_issues(cdround)
#' NROW(res$data)
#' NROW(gg$data)
#' head(res$data)[,c(1:5)]
#' head(gg$data)[,c(1:5)]
#'
#' ### remove data rows with certain issue classes
#' res %>% occ_issues(-cdround, -cudc)
#'
#' ### split issues into separate columns
#' res %>% occ_issues(mutate = "split")
#' res %>% occ_issues(-cudc, -mdatunl, mutate = "split")
#' res %>% occ_issues(gass84, mutate = "split")
#'
#' ### expand issues to more descriptive names
#' res %>% occ_issues(mutate = "expand")
#'
#' ### split and expand
#' res %>% occ_issues(mutate = "split_expand")
#'
#' ### split, expand, and remove an issue class
#' res %>% occ_issues(-cdround, mutate = "split_expand")
#'
#' ## Or you can use occ_issues without the pipe
#' occ_issues(res, -cdround, mutate = "split_expand")
#'
#' # from GBIF downloaded data via occ_download and friends
#' res <- occ_download_get(key="0000066-140928181241064", overwrite=TRUE)
#' x <- occ_download_import(res)
#' occ_issues(x, -txmathi)
#' occ_issues(x, txmathi)
#' occ_issues(x, gass84)
#' occ_issues(x, zerocd)
#' occ_issues(x, gass84, txmathi)
#' occ_issues(x, mutate = "split")
#' occ_issues(x, -gass84, mutate = "split")
#' occ_issues(x, mutate = "expand")
#' occ_issues(x, mutate = "split_expand")
#'
#' # occ_search/occ_data with many inputs - give slightly different output
#' # format than normal 2482598, 2498387
#' xyz <- occ_data(taxonKey = c(9362842, 2492483, 2435099), limit = 300)
#' xyz
#' length(xyz) # length 3
#' names(xyz) # matches taxonKey values passed in
#' occ_issues(xyz, -gass84)
#' occ_issues(xyz, -cdround)
#' occ_issues(xyz, -cdround, -gass84)
#' }

occ_issues <- function(.data, ..., mutate = NULL) {
  assert(.data, c("gbif", "gbif_data", "data.frame", "tbl_df"))

  if ("data" %in% names(.data)) {
    tmp <- .data$data
  } else {
    many <- FALSE
    if (attr(.data, "type") %||% "" == "many") {
      many <- TRUE
      tmp <- data.table::setDF(
        data.table::rbindlist(lapply(.data, "[[", "data"),
          fill = TRUE, use.names = TRUE, idcol = "ind"))
    } else {
      tmp <- .data
    }
  }

  # handle downloads data
  is_dload <- FALSE
  if (
    all(
      c("issue", "gbifID", "accessRights", "accrualMethod") %in% names(tmp)
    ) &&
    !"issues" %in% names(tmp)
  ) {
    is_dload <- TRUE

    # convert long issue names to short ones
    issstr <- tmp[names(tmp) %in% "issue"][[1]]
    tmp$issues <- unlist(lapply(issstr, function(z) {
      if (identical(z, "")) return (character(1))
      paste(gbifissues[ grepl(gsub(";", "|", z), gbifissues$issue), "code" ],
        collapse = ",")
    }))
  }

  if (!length(dots(...)) == 0) {
    filters <- parse_input(...)
    if (length(filters$neg) > 0) {
      tmp <- tmp[ !grepl(paste(filters$neg, collapse = "|"), tmp$issues), ]
    }
    if (length(filters$pos) > 0) {
      tmp <- tmp[ grepl(paste(filters$pos, collapse = "|"), tmp$issues), ]
    }
  }

  if (!is.null(mutate)) {
    if (mutate == "split") {
      tmp <- split_iss(tmp, is_dload)
    } else if (mutate == "split_expand") {
      tmp <- mutate_iss(tmp)
      tmp <- split_iss(tmp, is_dload)
    } else if (mutate == "expand") {
      tmp <- mutate_iss(tmp)
    }
  }

  if ("data" %in% names(.data)) {
    .data$data <- tmp
    return( .data )
  } else if (many) {
    tmpsplit <- split(tmp, tmp$ind)
    for (i in seq_along(names(.data))) {
      df <- tibble::as_tibble(tmpsplit[[ names(.data)[i] ]])
      if (NROW(df) > 0) df$ind <- NULL
      .data[[ names(.data)[i] ]]$data <- df
    }
    return(.data)
  } else {
    return( tmp )
  }
}

mutate_iss <- function(w) {
  w$issues <- sapply(strsplit(w$issues, split = ","), function(z) {
    paste(gbifissues[ gbifissues$code %in% z, "issue" ], collapse = ",")
  })
  return( w )
}

split_iss <- function(m, is_dload) {
  unq <- unique(unlist(strsplit(m$issues, split = ",")))
  df <- data.table::setDF(
    data.table::rbindlist(
      lapply(strsplit(m$issues, split = ","), function(b) {
        v <- unq %in% b
        data.frame(rbind(ifelse(v, "y", "n")), stringsAsFactors = FALSE)
      })
    )
  )
  names(df) <- unq
  m$issues <- NULL
  first_search <- c("name", "key", "decimalLatitude", "decimalLongitude")
  first_dload <- c("scientificName", "taxonKey", "decimalLatitude",
    "decimalLongitude")
  first <- if (is_dload) first_dload else first_search
  tibble::as_tibble(data.frame(m[, first], df, m[, !names(m) %in% first],
    stringsAsFactors = FALSE))
}

parse_input <- function(...) {
  x <- as.character(dots(...))
  neg <- gsub("-", "", x[grepl("-", x)])
  pos <- x[!grepl("-", x)]
  list(neg = neg, pos = pos)
}

dots <- function(...){
  eval(substitute(alist(...)))
}
