#' @title Download occurrence data using a SQL query
#'
#' @param q sql query
#' @param format only "SQL_TSV_ZIP" is supported right now
#' @param user your GBIF user name
#' @param pwd your GBIF password
#' @param email your email address
#' @param curlopts list of curl options
#'
#' @return an object of class 'occ_download_sql'
#' 
#' @export
#'
#' @examples /dontrun{
#' 
#' }
#' 
occ_download_sql <- function(q = NULL, 
                             format = "SQL_TSV_ZIP",
                             user = NULL, 
                             pwd = NULL, 
                             email = NULL, 
                             curlopts = list()) {
  
  z <- occ_download_sql_prep(q=q,
                             format=format,
                             user=user,
                             pwd=pwd,
                             email=email,
                             curlopts=curlopts)
  
  out <- rg_POST(z$url, req = z$request, user = z$user, pwd = z$pwd, curlopts=curlopts)
  md <- occ_download_meta(out) # get meta_data for printing
  citation <- gbif_citation(md)$download # get citation
  
  structure(out, 
            class = "occ_download_sql", 
            user = z$user, 
            email = z$email,
            format = z$format,
            status = md$status,
            created = md$created,
            downloadLink = md$downloadLink,
            doi = md$doi,
            citation = citation
  )
  
}

#' @export
occ_download_sql_validate <- function(req = NULL, user = NULL, pwd = NULL) {
  stopifnot(is.list(req))
  url <- "https://api.gbif.org/v1/occurrence/download/request/validate"
  user <- check_user(user)
  pwd <- check_pwd(pwd)
  out <- rg_POST(url=url, req=req, user=user, pwd=pwd, curlopts=list())
  out
}

#' @export
occ_download_sql_prep <- function(q=NULL, 
                                  format = "SQL_TSV_ZIP",
                                  user = NULL, 
                                  pwd = NULL, 
                                  email = NULL,
                                  validate = TRUE,
                                  curlopts = list()) {
  
  url <- paste0(gbif_base(), '/occurrence/download/request')
  assert(q,"character")
  assert(format,"character")
  if(!format == "SQL_TSV_ZIP") stop("Only format='SQL_TSV_ZIP' is supported at this time.")
  
  user <- check_user(user)
  pwd <- check_pwd(pwd)
  email <- check_email(email)

  req <- list(
    sendNotification = TRUE,
    notificationAddresses = email,
    format = unbox(format),
    sql = unbox(q)
  )
  
  if(validate) occ_download_sql_validate(req = req, user = user, pwd = pwd)
  
  structure(list(
    url = url,
    request = req,
    json_request = jsonlite::prettify(check_inputs(req),indent = 1),
    user = user,
    pwd = pwd,
    email = email,
    format = format,
    curlopts = curlopts),
    class = "occ_download_sql_prep")

}

#' @export
print.occ_download_sql <- function(x) {
  stopifnot(inherits(x, 'occ_download_sql'))
  cat_n("<<gbif download sql>>")
  cat_n("  Your download is being processed by GBIF:")
  cat_n("  https://www.gbif.org/occurrence/download/",x)
  cat_n("  Check status with")
  cat_n("  occ_download_wait('",x,"')")
  cat_n("  After it finishes, use")
  cat_n("  d <- occ_download_get('",x,"') %>%") 
  cat_n("    occ_download_import()")
  cat_n("  to retrieve your download.")
  cat_n("Download Info:")
  cat_n("  Username: ", attr(x, "user"))
  cat_n("  E-mail: ", attr(x, "email"))
  cat_n("  Format: ", attr(x, "format"))
  cat_n("  Download key: ", x)
  cat_n("  Created: ",attr(x, "created"))
  cat_n("Citation Info:  ")
  cat_n("  Please always cite the download DOI when using this data.")
  cat_n("  https://www.gbif.org/citation-guidelines")
  cat_n("  DOI: ", attr(x,"doi"))
  cat_n("  Citation:")
  cat_n("  ", attr(x,"citation"))
}

#' @export
print.occ_download_sql_prep <- function(x) {
  stopifnot(inherits(x, 'occ_download_sql_prep'))
  cat_n("<<Occurrence Download SQL Prep>>")
  cat_n("Format: ", x$format)
  cat_n("Email: ", x$email)
  cat_n("Request: ", x$json_request)
}
