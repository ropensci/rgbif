# set up vcr
library("vcr")
invisible(vcr::vcr_configure(
    dir = "../fixtures",
    filter_sensitive_data = list(
        "<google_elevation_api_token>" = Sys.getenv("G_ELEVATION_API"),
        "<gbif_user>" = Sys.getenv("GBIF_USER"),
        "<gbif_pwd>" = Sys.getenv("GBIF_PWD"),
        "<gbif_email>" = Sys.getenv("GBIF_EMAIL")
    )
))
