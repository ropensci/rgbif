#' Register a derived dataset for citation.
#'
#' @export
#'
#' @param citation_data (required) A data.frame with **two columns**. The first 
#' column should be GBIF **datasetkey uuids** and the second column should be 
#' **occurrence counts** from each of your datasets, representing the 
#' contribution of each dataset to your final derived dataset. 
#' @param title (required) The title for your derived dataset. 
#' @param description (required) A description of the dataset. Perhaps 
#' describing how it was created. 
#' @param source_url (required) A link to where the dataset is stored.
#' @param gbif_download_doi (optional) A DOI from an original GBIF download. 
#' @param user (required) Your GBIF username.
#' @param pwd (required) Your GBIF password.
#' @param curlopts a list of arguments to pass to curl.
#' 
#' @return A list. 
#' 
#' @section Usage:
#' Create a **citable DOI** for a dataset derived from GBIF mediated 
#' occurrences. 
#' 
#' **Use-case (1)** your dataset was obtained with `occ_search()` and 
#' never returned a **citable DOI**, but you want to cite the data in a 
#' research paper.  
#' 
#' **Use-case (2)** your dataset was obtained using `occ_download()` and you 
#' got a DOI, but the data underwent extensive filtering using 
#' `CoordinateCleaner` or some other cleaning pipeline. In this case be sure 
#' to fill in your original `gbif_download_doi`.
#' 
#' **Use-case (3)** your dataset was generated using a GBIF cloud export but 
#' you want a DOI to cite in your research paper. 
#' 
#' Use `derived_dataset` to create a custom citable meta-data description and 
#' most importantly a DOI link between an external archive (e.g. Zenodo) and the
#' datasets involved in your research or analysis.   
#' 
#' All fields (except `gbif_download_doi`) are required for the registration to 
#' work.   
#' 
#' We recommend that you run `derived_dataset_prep()` to check registration 
#' details before making it final with `derived_dataset()`. 
#' 
#' @section Authentication:
#' Some `rgbif` functions require your **GBIF credentials**. 
#' 
#' For the `user` and `pwd` parameters, you can set them in one of
#' three ways:
#'
#' 1. Set them in your `.Renviron`/`.bash_profile` (or similar) file with the
#' names `GBIF_USER`, `GBIF_PWD`, and `GBIF_EMAIL`
#' 2. Set them in your `.Rprofile` file with the names `gbif_user` and
#' `gbif_pwd`.
#' 3. Simply pass strings to each of the parameters in the function
#' call.
#'
#' We strongly recommend the **first option** - storing your details as
#' environment variables - as it's the most widely used way to store secrets. 
#' 
#' You can edit your `.Renviron` with `usethis::edit_r_environ()`. 
#' 
#' After editing, your `.Renviron` file should look something like this... 
#' 
#' GBIF_USER="jwaller"\cr
#' GBIF_PWD="fakepassword123"\cr
#' GBIF_EMAIL="jwaller@gbif.org"\cr
#'
#' See `?Startup` for help.
#'
#' @references 
#' <https://data-blog.gbif.org/post/derived-datasets/> 
#' <https://www.gbif.org/derived-dataset/about>
#'
#' @examples \dontrun{
#' data <- data.frame(
#'  datasetKey = c(
#'  "3ea36590-9b79-46a8-9300-c9ef0bfed7b8",
#'  "630eb55d-5169-4473-99d6-a93396aeae38",
#'  "806bf7d4-f762-11e1-a439-00145eb45e9a"),
#'  count = c(3, 1, 2781)
#'  )
#'
#'## If output looks ok, run derived_dataset to register the dataset
#'  derived_dataset_prep(
#'  citation_data = data,
#'  title = "Test for derived dataset",
#'  description = "This data was filtered using a fake protocol",
#'  source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY"
#'  )
#'
#'#  derived_dataset(
#'#  citation_data = data,
#'#  title = "Test for derived dataset",
#'#  description = "This data was filtered using a fake protocol",
#'#  source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY"
#'#  )
#'
#'## Example with occ_search and dplyr
#'# library(dplyr)
#' 
#'# citation_data <- occ_search(taxonKey=212, limit=20)$data %>%
#'#   group_by(datasetKey) %>% 
#'#   count()
#' 
#'# # You would still need to upload your data to Zenodo or something similar 
#'# derived_dataset_prep(
#'#   citation_data = citation_data,
#'#   title="Bird data downloaded for test",
#'#   description="This data was downloaded using rgbif::occ_search and was 
#'#   later uploaded to Zenodo.",
#'#   source_url="https://zenodo.org/record/4246090#.YPGS2OgzZPY",
#'#   gbif_download_doi = NULL,
#'# )
#' }
#' 
derived_dataset <- function(citation_data = NULL,
                            title = NULL,
                            description = NULL,
                            source_url = NULL,
                            gbif_download_doi = NULL,
                            user = NULL,
                            pwd = NULL,
                            curlopts = list()) {
  
  z <- derived_dataset_prep(citation_data = citation_data,
                            title=title,
                            description=description,
                            source_url=source_url,
                            gbif_download_doi = gbif_download_doi, 
                            user = user,
                            pwd = pwd,
                            curlopts = curlopts)

  out <- derived_dataset_POST(url = z$url,
                              req = jsonlite::toJSON(z$req,auto_unbox=TRUE),
                              user = z$user,
                              pwd = z$pwd,
                              curlopts = z$curlopts)
  structure(jsonlite::fromJSON(out), 
            class = "derived_dataset",
            user = z$user
            )
}

#' @export
#' @rdname derived_dataset
derived_dataset_prep <- function(citation_data = NULL, 
                                 title=NULL, 
                                 description=NULL,
                                 source_url=NULL,
                                 gbif_download_doi = NULL,
                                 user = NULL,
                                 pwd = NULL,
                                 curlopts = list()) {
  
  url <- paste0(gbif_base(), '/derivedDataset')
  user <- check_user(user)
  pwd <- check_pwd(pwd)
  citation_data <- check_citation_data(citation_data)
  title <- check_title(title)
  description <- check_description(description)
  source_url <- check_source_url(source_url)
  gbif_download_doi <- check_gbif_download_doi(gbif_download_doi)
  
  related_datasets <- stats::setNames(as.list(citation_data[,2]),citation_data[,1])
  
  if(!is.null(gbif_download_doi)) {
    req <- list(title=title,
                description=description,
                sourceUrl=source_url,
                originalDownloadDOI=gbif_download_doi,
                relatedDatasets=related_datasets)
  } else {
    req <- list(title=title,
                description=description,
                sourceUrl=source_url,
                relatedDatasets=related_datasets)
  }
  
  
  
  structure(list(url = url,
                 request = req,
                 title = title,
                 description=description,
                 source_url=source_url,
                 user = user,
                 pwd = pwd,
                 curlopts = curlopts),
            class = "derived_dataset_prep")

}

# helpers -------------------------------------------

check_citation_data = function(citation_data = NULL) {
  
  data <- citation_data
  
  if(is.null(data)) stop("Supply your datsetkey uuids with occurrence counts.")  
  if(is.vector(data))  stop("citation_data should be a data.frame not a vector.")
  
  # try to convert to data.frame
  if(!class(data)[1] == "data.frame") {
    tryCatch(
      expr = {
        data <- as.data.frame(data)
        # message("converted to data.frame")
      },
      error = function(e){
        stop("Error converting to data.frame. Please supply a data.frame to citation_data.")
      })    
  }
  if(nrow(data) == 0)
    stop("citation_data should not have zero rows. Check if your data.frame is empty.")
  if(ncol(data) < 2) 
    stop("Data should have two columns with dataset uuids and occurrence counts.")
  if(any(!stats::complete.cases(data))) {
    message("removing missing values")
    data = stats::na.omit(data)
  }
  if(!is.character(data[,1])) {
    message("Column 1 should be a character column of uuids. Converting Column 1 to character.")
    data[,1] = as.character(data[,1]) 
    }
  if(any(!sapply(data[,1],nchar) == 36))
    stop("GBIF dataset uuids have 36 characters and look something like this :  '3ea36590-9b79-46a8-9300-c9ef0bfed7b8' Put your uuids in the first column. Occurrence counts in the second column.")
  if(!is.numeric(data[,2])) 
    stop("Column 2 should be occurrence counts.")
  if(any(data[,2] <= 0)) 
    stop("Only positive occurrence counts should be in column 2 of citation data.")
  
  data
  }

check_title = function(title=NULL) {
  if(is.null(title)) 
    stop("GBIF requires you to fill in the title.")
  if(!is.character(title)) 
    stop("The title should be character string.")
  
  title
}

check_description = function(description=NULL) {
  
  if(is.null(description)) 
    stop("GBIF requires you to fill in the description.")
  if(!is.character(description)) 
    stop("The description should be character string.")
  
  description
}

check_source_url = function(source_url=NULL) {
  
  if(is.null(source_url)) stop("Please fill in the url where the derived dataset is stored (e.g.Zendo).")
  if(!is.character(source_url)) stop("The source_url should be character string.")
  
  source_url
}

check_gbif_download_doi = function(gbif_download_doi) {
  
  if(is.null(gbif_download_doi)) return(NULL)
  if(!is.character(gbif_download_doi)) {
    message("gbif_download_doi should be character string. Converting to character.")
    gbif_download_doi = as.character(gbif_download_doi)
    }
  if(grepl("https",gbif_download_doi)) 
    stop("remove 'https://doi.org/' from gbif_download_doi.")
  if(grepl("doi.org",gbif_download_doi)) 
    stop("remove 'https://doi.org/' from gbif_download_doi.")
  
  regex <- '^10\\.\\d{4,9}/[-._;()/:A-Z0-9]+$'
  
  if(!grepl(gbif_download_doi, pattern = regex, perl = TRUE, ignore.case = TRUE)) 
    message("For gbif_download_doi, DOI not valid, proceeding with potentially invalid DOI...")
  
  gbif_download_doi
}

derived_dataset_POST <- function(url, req, user, pwd, curlopts) {
  cli <- crul::HttpClient$new(url = url,opts = c(curlopts, httpauth = 1, userpwd = paste0(user, ":", pwd)),headers = c(rgbif_ual, `Content-Type` = "application/json", Accept = "application/json"))
  
  res <- cli$post(body = req)
  if (res$status_code > 203) stop(catch_err(res), call. = FALSE)
  res$raise_for_status()
  stopifnot(res$response_headers$`content-type` == 'application/json')
  res$parse("UTF-8")
}

#' @export
print.derived_dataset_prep <- function(x, ...) {
  cat_n("<<gbif derived dataset - prepared>>")
  cat_n("  Username: ", x$user)
  cat_n("  Title: '", x$request$title,"'")
  cat_n("  Description: '", x$request$description,"'")
  cat_n("  Source URL: ", x$request$sourceUrl)
  cat_n("  Original Download DOI: ", x$request$originalDownloadDOI)
  datasets = utils::head(names(x$request$relatedDatasets),5)
  counts = x$request$relatedDatasets
  cat_n("First 5 datasets of ",length(datasets)," :")
  for(i in 1:length(datasets)) 
  cat_n("  ",datasets[[i]]," : ",counts[[i]])
  
}
#' @export
print.derived_dataset <- function(x, ...) {
  stopifnot(inherits(x, 'derived_dataset'))
  cat_n("<<gbif derived dataset - created>>")
  cat_n("  Username: ", attr(x, "user"))
  cat_n("  Title: '", x$title,"'")
  cat_n("  Description: '", x$description,"'")
  cat_n("  Source URL: ", x$sourceUrl)
  if(!is.null(x$originalDownloadDOI))
    cat("  Original Download DOI: ", x$originalDownloadDOI)
  cat_n("  Citation: ", x$citation)	
  cat_n("  Derived Dataset DOI: ", x$doi)	
  cat_n("  See your registration here: https://www.gbif.org/derived-dataset")	
}
