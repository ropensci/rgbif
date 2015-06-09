#' Downloads interface
#' 
#' GBIF provides two ways to get occurrence data: through the 
#' \code{/occurrence/search} route (see \code{\link{occ_search}}), 
#' or via the \code{/occurrence/download} route (many functions, see below). 
#' \code{\link{occ_search}} is more appropriate for smaller data, while 
#' \code{occ_download*()} functions are more appropriate for larger data requests.
#' 
#' @section BEWARE: 
#' You can not perform that many downloads, so plan wisely. 
#' See \emph{Rate limiting} below.
#' 
#' @section Rate limiting:
#' If you try to launch too many downloads, you will receive an 420 
#' "Enhance Your Calm" response. If there is less then 100 in total 
#' across all GBIF users, then you can have 3 running at a time. If 
#' there are more than that, then each user is limited to 1 only. 
#' These numbers are subject to change.
#' 
#' @section Functions:
#' \itemize{
#'  \item \code{\link{occ_download}} - Start a download
#'  \item \code{\link{occ_download_meta}} - Get metadata progress on a single download
#'  \item \code{\link{occ_download_list}} - List your downloads
#'  \item \code{\link{occ_download_cancel}} - Cancel a download
#'  \item \code{\link{occ_download_get}} - Retrieve a download
#'  \item \code{\link{occ_download_import}} - Import a download from local file system
#' }
#' 
#' @name downloads
NULL
