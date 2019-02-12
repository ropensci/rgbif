library("vcr")
invisible(vcr::vcr_configure(
  dir = "../fixtures",
  filter_sensitive_data = list(
    "<gbif_user>" = Sys.getenv("GBIF_USER"),
    "<gbif_pwd>" = Sys.getenv("GBIF_PWD"),
    "<gbif_email>" = Sys.getenv("GBIF_EMAIL"),
    "<geonames_user>" = Sys.getenv("GEONAMES_USER")
  )
))
