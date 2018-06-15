#' GBIF download queue
#'
#' @export
#' @keywords internal
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
      # if (length(ldots) > && length(.list) > 0) {
      #   stop("pass in only ")
      # }
      self$reqs <- lapply(ldots, DownReq$new)
      self$reqs <- stats::setNames(self$reqs, seq_along(self$reqs))
    },

    add = function(x) {
      self$queue <- c(self$queue,
                         stats::setNames(list(x), digest::digest(x$req$expr)))
    },

    add_all = function() {
      if (length(self$reqs) == 0) stop("no jobs to add")
      invisible(lapply(self$reqs, function(z) self$add(z)))
    },

    remove = function(x) {
      self$queue[digest::digest(x$req$expr)] <- NULL
    },

    queue = list(),
    jobs = function() length(self$queue)
  )
)

#' Download request
#'
#' @export
#' @keywords internal
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
#' res <- DownReq$new(occ_download('taxonKey = 3119195', "year = 1991"))
#' res
#' res$req
#' res$run()
#' # (requests <- GbifQueue$new())
#' # res$run(keep_track = TRUE)
#' # requests
#' res$status()
#' }
DownReq <- R6::R6Class(
  'DownReq',
  public = list(
    req = NULL,
    result = NULL,

    initialize = function(x) {
      self$req <- x
    },

    print = function(x, ...) {
      cat("<GBIF download single queue> ", sep = "\n")
      print(self$req$expr)
      invisible(self)
    },

    run = function() {
      tmp <- tryCatch(lazyeval::lazy_eval(self$req), error = function(e) e)
      self$result <- if (inherits(tmp, "error")) NULL else tmp
    },

    status = function() {
      if (is.null(self$result)) stop("run() result is `NULL`, not checking status")
      tmp <- occ_download_meta(self$result)
      return(tmp)
    }
  )
)
