#' Fetch all downloads for a user
#' @export
#' @inheritParams occ_download
#' @keywords internal
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
#' @export
#' @param user_df output from [dl_user()]
#' @keywords internal
#' @examples \dontrun{
#' x <- dl_user()
#' dl_predicates(user_df = x)
#' }
dl_predicates <- function(user_df) {
  # reqs <- user_df$request
  out <- list()
  for (i in seq_len(NROW(user_df))) {
    # cat(i, sep = "\n")
    rw <- user_df[i,]
    if (!is.null(rw$request.predicate.predicates[[1]])) {
      out[[i]] <- list(
        creator = unbox(rw$request.creator),
        notification_address = unlist(rw$request.notificationAddresses),
        format = unbox(rw$request.format),
        predicate = list(
          type = unbox(rw$request.predicate.type),
          predicates = unname(apply(rw$request.predicate.predicates[[1]], 1, function(z) {
            if ("predicates" %in% names(z) && !is.null(z[["predicates"]])) {
              unname(
                apply(z[["predicates"]], 1, function(w) lapply(as.list(w), unbox2))
              )
            } else {
              lapply(as.list(z), unbox2)
            }
          }))
        )
      )
    } else {
      out[[i]] <- list(
        creator = unbox(rw$request.creator),
        notification_address = unlist(rw$request.notificationAddresses),
        format = unbox(rw$request.format),
        predicate = list(
          type = unbox(rw$request.predicate.type),
          key = unbox(rw$request.predicate.key),
          value = unbox(rw$request.predicate.value)
        )
      )
    }
  }
  out
}

unbox2 <- function(x) {
  if (length(x) > 1) x <- paste0(as.character(x), collapse = ",")
  jsonlite::unbox(x)
}

#' Does a download exist already on the GBIF's user account remotely?
#' @export
#' @param pred a download request predicate, the output from
#' [occ_download_prep()]
#' @param preds output from [dl_predicates()]
#' @return boolean
#' @details we convert predicates to JSON, then compare JSON blobs to one
#' another
#' @keywords internal
#' @examples \dontrun{
#' preds <- dl_predicates(dl_user())
#' 
#' dprep <- occ_download_prep("catalogNumber = Bird.27847588", "year = 1978",
#'   "month = 5")
#' dl_exists(pred = dprep, preds)
#' 
#' dprep <- occ_download_prep("catalogNumber = Bird.27847588")
#' dl_exists(pred = dprep, preds)
#' }
dl_exists <- function(pred, preds) {
  preds_json <- vapply(preds, check_inputs, "")
  any(unclass(check_inputs(pred$request)) == preds_json)
}

dl_match <- function(pred, user_df, age = "1 day") {
  preds <- dl_predicates(user_df)
  preds_json <- vapply(preds, check_inputs, "")
  any(unclass(check_inputs(pred$request)) == preds_json)
}

