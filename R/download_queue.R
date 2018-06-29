#' GBIF download queue
#'
#' @export
#' @keywords internal
#' @param ... any number of [occ_download()] requests
#' @param .list any number of [occ_download()] requests as `lazy`
#' objects, called with e.g., `lazyeval::lazy()`
#' @details
#' **Methods**
#'   \describe{
#'     \item{`add(x)`}{
#'       Add single jobs to the queue
#'     }
#'     \item{`add_all()`}{
#'       Add all jobs to the queue
#'     }
#'     \item{`remove(x)`}{
#'       Remove a job from the queue
#'     }
#'     \item{`jobs()`}{
#'       Give number of jobs in the `queue`
#'     }
#'   }
#' @format NULL
#' @usage NULL
#' @examples
#' x <- GbifQueue$new(
#'   occ_download('taxonKey = 3119195', "year = 1976"),
#'   occ_download('taxonKey = 3119195', "year = 2001"),
#'   occ_download('taxonKey = 3119195', "year = 2001", "month <= 8"),
#'   occ_download('taxonKey = 3119195', "year = 2004"),
#'   occ_download('taxonKey = 3119195', "year = 2005")
#' )
#' que = x
#' x
#' x$reqs
#' x$add_all()
#' x$jobs()
#' x
#' x$remove(x$reqs[[1]])
#' x

GbifQueue <- R6::R6Class(
  'GbifQueue',
  public = list(
    reqs = NULL,

    print = function(x, ...) {
      cat("<GBIF download many queue> ", sep = "\n")
      cat(paste0("  requests (N): ", length(self$reqs)), sep = "\n")
      cat(paste0("  requests in queue (N): ", length(self$queue)), sep = "\n")
      invisible(self)
    },

    initialize = function(..., .list = list()) {
      ldots <- lazyeval::lazy_dots(...)
      ldots <- c(ldots, .list)
      self$reqs <- lapply(ldots, DownReq$new)
      self$reqs <- stats::setNames(self$reqs, seq_along(self$reqs))
    },

    add = function(x) {
      self$queue <- c(self$queue,
        stats::setNames(list(x), digest::digest(x$req$req)))
    },

    add_all = function() {
      if (length(self$reqs) == 0) stop("no jobs to add")
      invisible(lapply(self$reqs, function(z) self$add(z)))
    },

    remove = function(x) {
      self$queue[digest::digest(x$req$req)] <- NULL
    },

    next_ = function() {
      if (length(self$queue) > 0) {
        self$queue[1]
      } else {
        return(list())
      }
    },

    last_ = function() {
      if (length(self$queue) > 0) {
        self$queue[length(self$queue)]
      } else {
        return(list())
      }
    },

    queue = list(),
    jobs = function() length(self$queue)
  )
)

#' Download request
#'
#' @export
#' @keywords internal
#' @param x either a lazy object with an object of class `occ_download`, or an 
#' object of class `occ_download_prep`
#' @details
#' **Methods**
#'   \describe{
#'     \item{`new(...)`}{
#'       initialize request
#'     }
#'     \item{`run(...)`}{
#'       execute http request
#'     }
#'     \item{`status(...)`}{
#'       check http request status
#'     }
#'   }
#'
#' @format NULL
#' @usage NULL
#' @examples \dontrun{
#' # res <- DownReq$new(occ_download('taxonKey = 3119195', "year = 1991"))
#' # res
#' # res$req
#' # res$run()
#' # (requests <- GbifQueue$new())
#' # res$run(keep_track = TRUE)
#' # requests
#' # res$status()
#' 
#' # prepared query
#' res <- DownReq$new(occ_download_prep("basisOfRecord = LITERATURE"))
#' res
#' res$run()
#' res
#' res$status()
#' res$result
#' }
DownReq <- R6::R6Class(
  'DownReq',
  public = list(
    req = NULL,
    type = NULL,
    result = NULL,

    initialize = function(x) {
      self$req <- x
      if (inherits(self$req, "lazy")) self$type <- "lazy"
      if (inherits(self$req, "occ_download_prep")) self$type <- "pre"
    },

    print = function(x, ...) {
      cat("<GBIF download single queue> ", sep = "\n")
      print(if (self$type == "lazy") self$req$expr else self$req)
      invisible(self)
    },

    run = function() {
      if (self$type == "lazy") {
        tmp <- tryCatch(lazyeval::lazy_eval(self$req), error = function(e) e)
      } else {
        tmp <- tryCatch(occ_download_exec(self$req), error = function(e) e)
      }
      self$result <- if (inherits(tmp, "error")) NULL else tmp
    },

    status = function() {
      if (is.null(self$result)) stop("run() result is `NULL`, not checking status")
      tmp <- occ_download_meta(self$result)
      return(tmp)
    }
  )
)
