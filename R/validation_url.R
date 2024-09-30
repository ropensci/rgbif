validation_url <- function(url = NULL,
                           user = NULL,
                           pwd = NULL,
                           curlopts = list()
                           ) {
  z <- validation_url_prep(url = url,
                              user = user,
                              pwd = pwd,
                              curlopts = curlopts)
  
  out <- validation_POST(z$url, z$request, z$user, z$pwd, z$curlopts)
  
  structure(jsonlite::fromJSON(out), 
            class = "validation",
            user = z$user
  )
  
}

validation_url_prep <- function(url = NULL,
                                user = NULL,
                                pwd = NULL,
                                curlopts = list()
                                ) {
  url <- paste0(gbif_base(), '/validation/url')
  user <- check_user(user)
  pwd <- check_pwd(pwd)
  req <- list(fileUrl = url)  

  structure(list(url = url,
                 request = req,
                 user = user,
                 pwd = pwd,
                 curlopts = curlopts),
                 class = "validation_url_prep")

}


validation_POST <- function(url, req, user, pwd, curlopts) {
  cli <- crul::HttpClient$new(url = url,opts = c(curlopts, httpauth = 1, userpwd = paste0(user, ":", pwd)),headers = c(rgbif_ual, `Content-Type` = "application/json", Accept = "application/json"))
  
  res <- cli$post(body = req)
  if (res$status_code > 203) stop(catch_err(res), call. = FALSE)
  res$raise_for_status()
  stopifnot(res$response_headers$`content-type` == 'application/json')
  res$parse("UTF-8")
}


curl -X 'POST' \
'https://api.gbif.org/v1/validation/url?fileUrl=http%3A%2F%2Fipt1.cria.org.br%2Fipt%2Farchive.do%3Fr%3Dzuec-ech%26v%3D1.95' \
-u 'jwaller:#9SkdnAksiDkneksQosnVid88A' \
-H 'accept: application/json' \
-H 'Content-Type: multipart/form-data' 

