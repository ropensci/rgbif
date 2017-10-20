#' Downloads interface
#'
#' GBIF provides two ways to get occurrence data: through the
#' `/occurrence/search` route (see [occ_search()]),
#' or via the `/occurrence/download` route (many functions, see below).
#' [occ_search()] is more appropriate for smaller data, while
#' `occ_download*()` functions are more appropriate for larger data requests.
#'
#' @section Settings:
#' You'll use [occ_download()] to kick off a download. You'll need to
#' give that function settings from your GBIF profile: your user name, your
#' password, and your email. These three settings are required to use the
#' function. You can pass these to the function call or set them as options
#' either in the current R
#' session using the [options()] function, or by setting them in your
#' `.Rprofile` file, after which point they'll be read in automatically, and
#' you won't need to pass them in to the function call. If yo set them in your
#' `.Rprofile` file, they won't be available until you restart the R session.
#'
#' @section BEWARE:
#' You can not perform that many downloads, so plan wisely.
#' See *Rate limiting* below.
#'
#' @section Rate limiting:
#' If you try to launch too many downloads, you will receive an 420
#' "Enhance Your Calm" response. If there is less then 100 in total
#' across all GBIF users, then you can have 3 running at a time. If
#' there are more than that, then each user is limited to 1 only.
#' These numbers are subject to change.
#'
#' @section Functions:
#'
#' - [occ_download()] - Start a download
#' - [occ_download_meta()] - Get metadata progress on a single download
#' - [occ_download_list()] - List your downloads
#' - [occ_download_cancel()] - Cancel a download
#' - [occ_download_get()] - Retrieve a download
#' - [occ_download_import()] - Import a download from local file system
#' - [occ_download_datasets()] - List datasets for a download
#' - [occ_download_dataset_activity()] - Lists the downloads activity
#' of a dataset
#'
#' @name downloads
NULL
