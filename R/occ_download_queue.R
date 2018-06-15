#' Download requests in a queue
#'
#' @export
#' @param ... any number of [occ_download()] requests
#' @return a list of `occ_download` class objects, see [occ_download_get()]
#' to fetch data
#' @details This function is a convenience wrapper around [occ_download()],
#' allowing the user to kick off any number of requests, while abiding by
#' GBIF rules of 3 concurrent requests per user.
#'
#' @section How it works:
#' It works by using lazy evaluation to collect your requests into a queue.
#' Then it kicks of the first 3 requests. Then in a while loop, we check
#' status of those requests, and when any request finishes, we kick off the
#' next, and so on. So in theory, there may not always strictly be 3 running
#' concurrently, but the function will usually provide for 3 running
#' concurrently.
#' @examples \dontrun{
#' out <- occ_download_queue(
#'   occ_download('taxonKey = 3119195', "year = 1976"),
#'   occ_download('taxonKey = 3119195', "year = 2001"),
#'   occ_download('taxonKey = 3119195', "year = 2001", "month <= 8"),
#'   occ_download('taxonKey = 5229208', "year = 2011"),
#'   occ_download('taxonKey = 2480946', "year = 2015"),
#'   occ_download("country = NZ", "year = 1999", "month = 3"),
#'   occ_download("catalogNumber = Bird.27847588", "year = 1998", "month = 2")
#' )
#'
#' # supports <= 3 requests too
#' out <- occ_download_queue(
#'   occ_download("country = NZ", "year = 1999", "month = 3"),
#'   occ_download("catalogNumber = Bird.27847588", "year = 1998", "month = 2")
#' )
#' }
occ_download_queue <- function(..., .list = list()) {
  # number of max concurrent requests, has to be hard-coded due to GBIF limits
  max_concurrent <- 3
  # set sleep time (seconds) to be used for while loops
  sleep <- 2

  # collect requests
  que <- GbifQueue$new(..., .list = .list)

  # stop if no requests submitted
  if (length(que$reqs) == 0) stop("no requests submitted")

  # initialize bucket to collect data
  results <- list()

  # add all jobs to the queue
  que$add_all()

  # start the 1st `max_concurrent` jobs
  message("kicking off first 3 requests")
  res <- invisible(lapply(
    rgbif_compact(que$queue[seq_len(max_concurrent)]), function(x) {
    # remove from queue
    que$remove(x)
    # run job
    x$run()
  }))
  res <- Filter(function(x) inherits(x, "occ_download"), res)

  # handle if 3 requests or less
  if (que$jobs() == 0) {
    message("<= 3 requests, waiting for completion")
    still_running <- TRUE
    while (still_running) {
      metas <- lapply(res, occ_download_meta)
      status <- vapply(metas, "[[", "", "status", USE.NAMES = FALSE)
      still_running <- !all(tolower(status) %in% c('succeeded', 'killed'))
      Sys.sleep(sleep)
    }
    results <- res
  } else {
    message("> 3 requests, waiting for completion")
    # cycle through until all jobs run and complete
    while (que$jobs() > 0 || length(res) > 0) {
      metas <- lapply(res, occ_download_meta)
      status <- vapply(metas, "[[", "", "status", USE.NAMES = FALSE)
      statusbool <- tolower(status) %in% c('succeeded', 'killed')

      if (any(statusbool)) {
        # stash result and drop those done from `res` pool
        results <- c(results, res[statusbool])
        res <- res[!statusbool]

        # kick offf new job
        if (que$jobs() > 0) {
          ## get job
          x <- que$queue[1]
          ## remove from queue
          que$remove(x[[1]])
          ## run job
          res_single <- x[[1]]$run()
          ## stash into `res` pool
          res <- c(res, stats::setNames(list(res_single), names(x)))
        }
      }
      Sys.sleep(sleep)
    }
  }
  return(results)
}
