library("vcr")
# Exclude sensitive data
invisible(vcr::vcr_configure(
  dir = "../fixtures",
  write_disk_path = "../files",
  filter_sensitive_data = list(
    "<gbif_user>" = Sys.getenv("GBIF_USER"),
    "<gbif_pwd>" = Sys.getenv("GBIF_PWD"),
    "<gbif_email>" = Sys.getenv("GBIF_EMAIL"),
    "<geonames_user>" = Sys.getenv("GEONAMES_USER")
  )
))

# Exclude irrelevant HTTP request headers
invisible(vcr::vcr_configure(
  dir = "../fixtures",
  write_disk_path = "../files",
  filter_request_headers = c("User-Agent", "X-USER-AGENT")
))

# Exclude irrelevant HTTP response headers
invisible(vcr::vcr_configure(
  dir = "../fixtures",
  write_disk_path = "../files",
  filter_response_headers = c("server", "date", "vary", "x-content-type-options", "x-xss-protection", "pragma", "expires", "x-frame-options", "content-length", "cache-control", "x-varnish", "age", "via", "connection", "access-control-allow-origin", "access-control-allow-methods", "transfer-encoding", "accept-ranges")
))