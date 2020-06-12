gbif_dl_env <- new.env()

#' Fetch all downloads for a user
#' @inheritParams occ_download
#' @keywords internal
#' @noRd
#' @examples \dontrun{
#' x <- dl_user()
#' x
#' }
dl_user <- function(user = NULL, pwd = NULL, curlopts = list()) {
  fst <- ocl_help(user, pwd, limit = 300, curlopts = curlopts,
    flatten = TRUE)
  out <- list(fst$results)
  if (fst$count > NROW(fst$results)) {
    numfnd <- fst$count
    numret <- sum(vapply(out, NROW, 1))
    it <- 1
    while (numret < numfnd) {
      it <- it + 1
      fst <- ocl_help(user = user, pwd = pwd, limit = 300,
        start = numret, curlopts = curlopts, flatten = TRUE)
      out[[it]] <- fst$results
      numret <- sum(NROW(fst$results), numret)
    }
  }
  tibble::as_tibble(setdfrbind(out))
}

#' Fetch all user download predicates
#' @param user_df output from [dl_user()]
#' @keywords internal
#' @noRd
#' @examples \dontrun{
#' x <- dl_user()
#' res <- dl_predicates(user_df = x)
#' res
#' }
dl_predicates <- function(user_df) {
  user_df$pred_str <- NA_character_
  for (i in seq_len(NROW(user_df))) {
    # cat(i, sep = "\n")
    rw <- user_df[i,]
    if (!is.null(rw$request.predicate.predicates[[1]])) {
      user_df[i,"pred_str"] <- as.character(check_inputs(list(
        creator = unbox(rw$request.creator),
        notification_address = unlist(rw$request.notificationAddresses),
        format = unbox(rw$request.format),
        predicate = list(
          type = unbox(rw$request.predicate.type),
          predicates = unname(apply(rw$request.predicate.predicates[[1]], 1, function(z) {
            if ("predicates" %in% names(z) && !is.null(z[["predicates"]])) {
              rc(unname(
                apply(z[["predicates"]], 1, function(w) lapply(as.list(w), unbox2))
              ))
            } else {
              rc(lapply(as.list(z), unbox2))
            }
          }))
        )
      )))
    } else {
      user_df[i,"pred_str"] <- as.character(check_inputs(list(
        creator = unbox(rw$request.creator),
        notification_address = unlist(rw$request.notificationAddresses),
        format = unbox(rw$request.format),
        predicate = list(
          type = unbox(rw$request.predicate.type),
          key = unbox(rw$request.predicate.key),
          value = unbox(rw$request.predicate.value)
        )
      )))
    }
  }
  return(user_df)
}

unbox2 <- function(x) {
  if (length(x) > 1) x <- paste0(as.character(x), collapse = ",")
  jsonlite::unbox(x)
}

#' Does a download exist already on the GBIF's user account remotely?
#' @param pred a download request predicate, the output from
#' [occ_download_prep()]
#' @param preds output from [dl_predicates()]
#' @return boolean
#' @details we convert predicates to JSON, then compare JSON blobs to one
#' another
#' @noRd
#' @examples \dontrun{
#' preds <- dl_predicates(dl_user())
#' 
#' dprep <- occ_download_prep("catalogNumber = Bird.27847588", "year = 1978",
#'   "month = 5")
#' dprep <- occ_download_prep(pred("catalogNumber", "Bird.27847588"), pred("year", 1978))
#' dl_exists(pred = dprep, preds)
#' 
#' dprep <- occ_download_prep(pred("catalogNumber", "Bird.27847588"))
#' dl_exists(pred = dprep, preds)
#' }
dl_exists <- function(pred, preds) {
  any(unclass(check_inputs(pred$request)) == preds$pred_str)
}

#' Match user supplied predicate to their GBIF downloads
#' @keywords internal
#' @param pred () a predicate, object of class `occ_download_prep`, output
#' from [occ_download_prep()]
#' @param preds (data.frame) output from [dl_predicates()]
#' @param age (integer) number of days after which you want a new
#' download. default: 30
#' @return if no matches list, with `match=FALSE`. if any matches returns 
#' list with `match=TRUE`, and key, created, and totalRecords fields. If a
#' match was found but it was created more than 
#' @note
#' - remove any with job status: "PREPARING", "KILLED", "CANCELLED",
#' "FILE_ERASED" (leaving only "SUCCEEDED")
#' - check for any matches. if any matches, then:
#'   - sort by most recent request
#'   - if the query age created is less than the `age` parameter, return `TRUE`
#'   and the download key
#' @noRd
#' @examples \dontrun{
#' preds <- dl_predicates(dl_user())
#' preds
#' 
#' # not matched
#' dprep <- occ_download_prep(pred("catalogNumber", "Bird.27847588"),
#'   pred("year", 1978))
#' dl_match(pred = dprep, preds)
#' 
#' # match but expired
#' dprep <- occ_download_prep(pred("catalogNumber", "Bird.27847588"))
#' dl_match(pred = dprep, preds)
#' 
#' # match, and not expired
#' dprep <- occ_download_prep(pred_within("POLYGON((-14 42, 9 38, -7 26, -14 42))"),
#'   pred_gte("elevation", 5000))
#' dl_match(pred = dprep, preds, age = 90)
#' }
dl_match <- function(pred, preds, age = 30) {
  x <- DownloadMatch$new(pred, preds, age)
  x$check_matches()
  return(x)
}

#' @title DownloadMatch
#' @description download match handler
#' @keywords internal
#' @noRd
DownloadMatch <- R6::R6Class(
  'DownloadMatch',
  public = list(
    #' @field pred a predicate
    pred = NULL,
    #' @field preds (data.frame) preds
    preds = NULL,
    #' @field age (integer) age
    age = 30,
    #' @field output (list) the output
    output = list(),
    #' @field most_recent (character) most recent matching date
    most_recent = "",

    #' @description print method for the `DownloadMatch` class
    #' @param x self
    #' @param ... ignored
    print = function(x, ...) {
      cat("<download match> ", sep = "\n")
      cat(paste0("  match?: ", self$output$match), sep = "\n")
      cat(paste0("  expired?: ", self$output$expired), sep = "\n")
      cat(paste0("  key: ", self$output$key), sep = "\n")
      cat(paste0("  created: ", self$output$created), sep = "\n")
      cat(paste0("  n records: ", self$output$totalRecords), sep = "\n")
      invisible(self)
    },

    #' @description Create a new `DownloadMatch` object
    #' @param pred () a predicate, object of class `occ_download_prep`, output
    #' from [occ_download_prep()]
    #' @param preds (data.frame) output from [dl_predicates()]
    #' @param age (integer) number of days after which you want a new
    #' download. default: 30
    #' @return A new `DownloadMatch` object
    initialize = function(pred, preds, age = 30) {
      self$pred <- pred
      self$preds <- preds
      self$age <- age
    },

    #' @description Check for matches
    #' @return nothing returned; adds job (`x`) to the queue
    check_matches = function() {
      assert(self$age, c("integer", "numeric"))
      self$preds <- self$preds[tolower(self$preds$status) == "succeeded", ]
      mtchs <- unclass(check_inputs(self$pred$request)) == self$preds$pred_str
      if (!any(mtchs)) {
        self$output <- self$pred_match()
      } else {
        md <- self$preds[mtchs,]
        md <- md[order(md$created, decreasing = TRUE), ]
        to_day <- Sys.Date()
        oldest <- to_day - self$age
        self$most_recent <- md$created[1]
        if (md$created[1] < oldest) {
          self$output <- self$pred_match(TRUE, md$key[1], md$created[1],
            md$totalRecords[1], expired = TRUE)
        } else {
          self$output <- self$pred_match(TRUE, md$key[1], md$created[1],
            md$totalRecords[1], expired = FALSE)
        }
      }
    },

    #' @description create output list
    #' @param match (logical) a boolean, `TRUE` if a match found
    #' @param key (character) the download key, `NA_character_` if no
    #' match found
    #' @param created (character) date created
    #' @param n (integer) number of records found
    #' @param expired (logical) a boolean, if older than the age given
    #' @return a list
    pred_match = function(match = FALSE, key = NULL, created = NULL,
      n = NULL, expired = FALSE) {
      list(
        match = match, 
        key = key, 
        created = created,
        totalRecords = n,
        expired = expired
      )
    }
  ),

  active = list(
    #' @field message - make an output message
    message = function() {
      str <- "no match found"
      if (self$output$match && !self$output$expired) {
        str <- sprintf("match found (key: %s, created: %s, records: %s)",
          self$output$key, self$output$created, self$output$totalRecords)
      }
      if (self$output$match && self$output$expired) {
        str <- paste0("match found, but expired. most recent query from ",
          self$most_recent)
      }
      message(str)
    },
    #' @field matched - match boolean
    matched = function() self$output$match,
    #' @field expired - expired boolean
    expired = function() self$output$expired,
    #' @field key - download key
    key = function() self$output$key
  )
)

dl_user_preds <- function(user, pwd, refresh = FALSE) {
  assert(refresh, "logical")
  if (refresh) gbif_dl_env$user_download_predicates <- NULL
  if (is.null(gbif_dl_env$user_download_predicates)) {
    x <- dl_predicates(dl_user(user, pwd))
    gbif_dl_env$user_download_predicates <- x
  }
  return(gbif_dl_env$user_download_predicates)
}
