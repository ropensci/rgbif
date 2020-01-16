getsize <- function(x) {
  round(x/10 ^ 6, 2)
}

prep_output <- function(x) {
  list(
    meta = data.frame(offset = x$offset, limit = x$limit,
      endofrecords = x$endOfRecords, count = x$count,
      stringsAsFactors = FALSE),
    results = tibble::as_tibble(x$results)
  )
}
