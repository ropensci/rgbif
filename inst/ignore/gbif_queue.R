library(rgbif)
library(lazyeval)

reqs <- gbif_queue(
  occ_download('taxonKey = 3119195', "year = 1976"),
  occ_download('taxonKey = 3119195', "year = 2001"),
  occ_download('taxonKey = 3119195', "year = 2001", "month <= 8"),
  occ_download('taxonKey = 5229208', "year = 2011"),
  occ_download('taxonKey = 2480946', "year = 2015"),
  occ_download("country = NZ", "year = 1999", "month = 3"),
  occ_download("catalogNumber = Bird.27847588", "year = 1998", "month = 2")
)

gbif_queue <- function(...) {
  reqs <- lazyeval::lazy_dots(...)
  results <- list()
  groups <- split(reqs, ceiling(seq_along(reqs)/3))

  for (i in seq_along(groups)) {
    cat("running group of three: ", i)
    res <- lapply(groups[[i]], function(w) {
      tmp <- tryCatch(lazyeval::lazy_eval(w), error = function(e) e)
      if (inherits(tmp, "error")) {
        "http request error"
      } else {
        tmp
      }
    })

    # filter out errors
    res_noerrors <- Filter(function(x) inherits(x, "occ_download"), res)
    still_running <- TRUE
    while (still_running) {
      metas <- lapply(res_noerrors, occ_download_meta)
      status <- vapply(metas, "[[", "", "status", USE.NAMES = FALSE)
      still_running <- !all(tolower(status) %in% c('succeeded', 'killed'))
      Sys.sleep(2)
    }
    results[[i]] <- res
  }

  results <- unlist(results, recursive = FALSE)

  return(results)
}

