#' @title GbifQueue
#' @description GBIF download queue
#' @export
#' @keywords internal
#' @examples \dontrun{
#' if (interactive()) { # dont run in automated example runs, too costly
#' x <- GbifQueue$new(
#'   occ_download(pred('taxonKey', 3119195), pred("year", 1976)),
#'   occ_download(pred('taxonKey', 3119195), pred("year", 2001)),
#'   occ_download(pred('taxonKey', 3119195), pred("year", 2001), pred_lte("month", 8)),
#'   occ_download(pred('taxonKey', 3119195), pred("year", 2004)),
#'   occ_download(pred('taxonKey', 3119195), pred("year", 2005))
#' )
#' x
#' x$reqs
#' x$add_all()
#' x
#' x$jobs()
#' x
#' x$remove(x$reqs[[1]])
#' x
#' x$reqs[[1]]$run()
#' x$reqs[[1]]$result
#'
#' # pre-prepared download request
#' z <- occ_download_prep(
#'   pred_in("basisOfRecord", c("HUMAN_OBSERVATION","OBSERVATION")),
#'   pred("hasCoordinate", TRUE),
#'   pred("hasGeospatialIssue", FALSE),
#'   pred("year", 1993),
#'   user = "foo", pwd = "bar", email = "foo@bar.com"
#' )
#' out <- GbifQueue$new(.list = list(z))
#' out
#' out$reqs
#' }}
GbifQueue <- R6::R6Class(
  'GbifQueue',
  public = list(
    #' @field reqs (list) a named list of objects of class [occ_download()]
    reqs = NULL,
    #' @field queue (list) holds the queued jobs
    queue = list(),

    #' @description print method for the `GbifQueue` class
    #' @param x self
    #' @param ... ignored
    print = function(x, ...) {
      cat("<GBIF download many queue> ", sep = "\n")
      cat(paste0("  requests (N): ", length(self$reqs)), sep = "\n")
      cat(paste0("  requests in queue (N): ", length(self$queue)), sep = "\n")
      invisible(self)
    },

    #' @description Create a new `GbifQueue` object
    #' @param ... any number of [occ_download()] requests
    #' @param .list any number of [occ_download()] requests as `lazy`
    #' objects, called with e.g., `lazyeval::lazy()`
    #' @return A new `GbifQueue` object
    initialize = function(..., .list = list()) {
      ldots <- lazyeval::lazy_dots(...)
      ldots <- c(ldots, .list)
      for (i in ldots) {
        if (!inherits(i, "lazy") && !inherits(i, "occ_download_prep")) {
          stop("'x' must be of class lazy or occ_download_prep")
        }
      }
      self$reqs <- lapply(ldots, DownReq$new)
      self$reqs <- stats::setNames(self$reqs, seq_along(self$reqs))
    },

    #' @description Add single jobs to the queue
    #' @param x an [occ_download()] object
    #' @return nothing returned; adds job (`x`) to the queue
    add = function(x) {
      self$queue <- c(self$queue,
        stats::setNames(list(x), digest::digest(x$req$req)))
    },

    #' @description Add all jobs to the queue
    #' @return nothing returned
    add_all = function() {
      if (length(self$reqs) == 0) stop("no jobs to add")
      invisible(lapply(self$reqs, function(z) self$add(z)))
    },

    #' @description Remove a job from the queue
    #' @param x an [occ_download()] object
    #' @return nothing returned
    remove = function(x) {
      self$queue[digest::digest(x$req$req)] <- NULL
    },

    #' @description Get the next job in the `queue`. if no more jobs,
    #' returns empty list
    #' @return next job or empty list
    next_ = function() {
      if (length(self$queue) > 0) {
        self$queue[1]
      } else {
        return(list())
      }
    },

    #' @description Get the last job in the `queue`. if no more jobs,
    #' returns empty list
    #' @return last job or empty list
    last_ = function() {
      if (length(self$queue) > 0) {
        self$queue[length(self$queue)]
      } else {
        return(list())
      }
    },

    #' @description Get number of jobs in the `queue`
    #' @return (integer) number of jobs
    jobs = function() length(self$queue)
  )
)

#' @title DownReq
#' @description handles single requests for [GbifQueue]
#' @export
#' @keywords internal
#' @examples \dontrun{
#' res <- DownReq$new(occ_download_prep(pred("basisOfRecord", "LITERATURE"), 
#'   pred("year", "1956")
#' ))
#' res
#' # res$run()
#' # res
#' # res$status()
#' # res$result
#' }
DownReq <- R6::R6Class(
  'DownReq',
  public = list(
    #' @field req (list) internal holder for the request
    req = NULL,
    #' @field type (list) type, one of "lazy" (to be lazy evaluated) or "pre"
    #' (run with `occ_download_exec` internal fxn)
    type = NULL,
    #' @field result (list) holds the result of the http request
    result = NULL,

    #' @description Create a new `DownReq` object
    #' @param x either a lazy object with an object of class `occ_download`, or an
    #' object of class `occ_download_prep`
    #' @return A new `DownReq` object
    initialize = function(x) {
      if (!inherits(x, "lazy") && !inherits(x, "occ_download_prep")) {
        stop("'x' must be of class lazy or occ_download_prep")
      }
      self$req <- x
      if (inherits(self$req, "lazy")) self$type <- "lazy"
      if (inherits(self$req, "occ_download_prep")) self$type <- "pre"
    },

    #' @description print method for the `DownReq` class
    #' @param x self
    #' @param ... ignored
    print = function(x, ...) {
      cat("<GBIF download single queue> ", sep = "\n")
      print(if (self$type == "lazy") self$req$expr else self$req)
      invisible(self)
    },

    #' @description execute http request
    #' @return nothing, puts the http response in `$result`
    run = function() {
      if (self$type == "lazy") {
        tmp <- tryCatch(lazyeval::lazy_eval(self$req), error = function(e) e)
      } else {
        tmp <- tryCatch(occ_download_exec(self$req), error = function(e) e)
      }
      if (!inherits(tmp, "error")) self$result <- tmp
      if (inherits(tmp, "error")) {
        self$result <- if (grepl("supply", tmp$message)) {
          tmp$message
        } else {
          NULL
        }
      }
      self$result
    },

    #' @description check http request status
    #' @return output of [occ_download_meta()]
    status = function() {
      if (is.null(self$result)) {
        stop("run() result is `NULL`, not checking status", call. = FALSE)
      }
      if (is.character(self$result) && !inherits(self$result, "occ_download")) {
        stop("run() failed: ", self$result, call. = FALSE)
      }
      tmp <- occ_download_meta(self$result)
      return(tmp)
    }
  )
)
