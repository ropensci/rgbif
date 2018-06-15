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
#' function. You can specify them in one of three ways:
#'
#' - Pass them to `occ_download` as parameters
#' - Use R options: As options either in the current R session using
#' the [options()] function, or by setting them in your `.Rprofile` file, after
#' which point they'll be read in automatically
#' - Use environment variables: As env vars either in the current R session using
#' the [Sys.setenv()] function, or by setting them in your
#' `.Renviron`/`.bash_profile` or similar files, after which point they'll be read
#' in automatically
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
#' - [occ_download_cancel_staged()] - Cancels any jobs with status `RUNNING`
#' or `PREPARING`
#' - [occ_download_get()] - Retrieve a download
#' - [occ_download_import()] - Import a download from local file system
#' - [occ_download_datasets()] - List datasets for a download
#' - [occ_download_dataset_activity()] - Lists the downloads activity
#' of a dataset
#'
#' @section Query length:
#' GBIF has a limit of 12,000 characters for a download query. This means
#' that you can have a pretty long query, but at some point it may lead to an
#' error on GBIF's side and you'll have to split your query into a few.
#'
#' @name downloads
NULL
