#' Download requests in a queue
#'
#' @export
#' @param ... any number of [occ_download()] requests
#' @param .list any number of [occ_download_prep()] requests
#' @param status_ping (integer) seconds between pings checking status of
#' the download request. generally larger numbers for larger requests.
#' default: 10 (i.e., 10 seconds). must be 10 or greater
#' @return a list of `occ_download` class objects, see [occ_download_get()]
#' to fetch data
#' @details This function is a convenience wrapper around [occ_download()],
#' allowing the user to kick off any number of requests, while abiding by
#' GBIF rules of 3 concurrent requests per user.
#' @note see [downloads] for an overview of GBIF downloads methods
#'
#' @section How it works:
#' It works by using lazy evaluation to collect your requests into a queue.
#' Then it kicks of the first 3 requests. Then in a while loop, we check
#' status of those requests, and when any request finishes, we kick off the
#' next, and so on. So in theory, there may not always strictly be 3 running
#' concurrently, but the function will usually provide for 3 running
#' concurrently.
#' 
#' @section Beware:
#' This function is still in development. There's a lot of complexity
#' to this problem. We'll be rolling out fixes and improvements in future
#' versions of the package, so expect to have to adjust your code 
#' with new versions.
#' 
#' @examples \dontrun{
#' # passing occ_download() requests via ...
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
#' 
#' # using pre-prepared requests via .list
#' keys <- c(7905507, 5384395, 8911082)
#' queries <- list()
#' for (i in seq_along(keys)) {
#'   queries[[i]] <- occ_download_prep(
#'     paste0("taxonKey = ", keys[i]),
#'     "basisOfRecord = HUMAN_OBSERVATION,OBSERVATION",
#'     "hasCoordinate = true",
#'     "hasGeospatialIssue = false",
#'     "year = 1993"
#'   )
#' }
#' out <- occ_download_queue(.list = queries)
#' out
#' 
#' # another pre-prepared example
#' yrs <- 1930:1934
#' length(yrs)
#' queries <- list()
#' for (i in seq_along(yrs)) {
#'   queries[[i]] <- occ_download_prep(
#'     "taxonKey = 2877951",
#'     "basisOfRecord = HUMAN_OBSERVATION,OBSERVATION",
#'     "hasCoordinate = true",
#'     "hasGeospatialIssue = false",
#'     paste0("year = ", yrs[i])
#'   )
#' }
#' out <- occ_download_queue(.list = queries)
#' out
#' }
occ_download_queue <- function(..., .list = list(), status_ping = 10) {
  # number of max concurrent requests
  # hard-coded due to GBIF limits
  max_concurrent <- 3

  # status must be 10 sec or greater
  assert(status_ping, c('integer', 'numeric'))
  stopifnot(status_ping >= 10)

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
      Sys.sleep(status_ping)
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
        message(paste0(
          lapply(metas[statusbool], function(w) {
            sprintf("  %s: %s", w$key, tolower(w$status))
          }),
          collapse = "\n"
        ))

        # stash result 
        results <- c(results, res[statusbool])
        # drop those done from `res` pool
        res <- res[!statusbool]

        # kick offf new job(s)
        if (que$jobs() > 0) {
          # take minimum of max concurrent - number still running OR number 
          #  jobs remaining - we don't want to start 2 jobs if there's 
          #  only 1 left to start
          jobs_to_start <- min(max_concurrent - length(res), que$jobs())
          # kick off N=jobs_to_start jobs
          for (i in seq_len(jobs_to_start)) {
            ## get job
            x <- que$next_()
            ## remove from queue
            que$remove(x[[1]])
            ## run job
            message(sprintf("  running %s of %s", 
              length(que$reqs) - length(que$queue), length(que$reqs)))
            res_single <- x[[1]]$run()
            ## stash into `res` pool
            res <- c(res, stats::setNames(list(res_single), names(x)))
          }
        }
      }
      Sys.sleep(status_ping)
    }
  }
  return(results)
}
