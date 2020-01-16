#' get all user downloads
#' @export
#' @keywords internal
#' @examples
#' x <- dl_user()
#' x
dl_user <- function(user = NULL, pwd = NULL, curlopts = list()) {
  fst <- ocl_help(user, pwd, limit = 300, curlopts = curlopts,
    flatten = TRUE)
  # FIXME: when https://github.com/gbif/occurrence/issues/98
  #  fixed, finish implementing this
  #  for now, just get first 300 results
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
  return(setdfrbind(out))
}

#' get all user download predicates
#' @export
#' @param user_df output from [dl_user()]
#' @keywords internal
#' @examples
#' x <- dl_user()
#' dl_predicates(user_df = x)
dl_predicates <- function(user_df) {
  reqs <- user_df$request
  out <- list()
  for (i in seq_len(NROW(reqs))) {
    rw <- reqs[i,]
    if (!is.null(rw$predicate$predicates[[1]])) {
      out[[i]] <- list(
        creator = unbox(rw$creator),
        notification_address = unlist(rw$notification_address),
        predicate = list(
          type = unbox(rw$predicate$type),
          predicates = unname(apply(rw$predicate$predicates[[1]], 1, function(z) {
            if ("predicates" %in% names(z) && !is.null(z[["predicates"]])) {
              unname(
                apply(z[["predicates"]], 1, function(w) lapply(as.list(w), unbox))
              )
            } else {
              lapply(as.list(z), unbox)
            }
          }))
        )
      )
    } else {
      out[[i]] <- list(
        creator = unbox(rw$creator),
        notification_address = unlist(rw$notification_address),
        predicate = list(
          type = unbox(rw$predicate$type),
          key = unbox(rw$predicate$key),
          value = unbox(rw$predicate$value)
        )
      )
    }
  }
  out
}

#' does a download exist already on the GBIF's user account remotely
#' @export
#' @param pred a download request predicate, the output from
#' [occ_download_prep()]
#' @param preds output from [dl_predicates()]
#' @keywords internal
#' @examples
#' dprep <- occ_download_prep("catalogNumber = Bird.27847588", "year = 1978",
#'   "month = 5")
#' preds <- dl_predicates(dl_user())
#' dl_exists(pred = dprep, preds)
dl_exists <- function(pred, preds) {
  preds_json <- vapply(preds, check_inputs, "")
  any(unclass(check_inputs(pred$request)) == preds_json)
}
