# invisible(vcr::vcr_configure(
#   dir = "tests/fixtures",
#   filter_sensitive_data = list(
#     "<gbif_user>" = Sys.getenv("GBIF_USER"),
#     "<gbif_pwd>" = Sys.getenv("GBIF_PWD"),
#     "<gbif_email>" = Sys.getenv("GBIF_EMAIL"),
#     "<geonames_user>" = Sys.getenv("GEONAMES_USER")
#   )
# ))
# vcr_configuration()

test_that("occ_download: real requests work", {
  skip_on_cran()

  vcr::use_cassette("occ_download_1", {
    zzz <- occ_download(pred("taxonKey", 9206251),
      pred_in("country", c("US", "CA")), pred_gte("year", 1979))
  }, match_requests_on = c("method", "uri", "body"))
  
  expect_is(zzz, "occ_download")
  expect_is(unclass(zzz), "character")
  expect_match(unclass(zzz)[1], "[0-9]+-[0-9]+")
  expect_equal(attr(zzz, "user"), "sckott")
  expect_equal(attr(zzz, "email"), "myrmecocystus@gmail.com")
  expect_equal(attr(zzz, "format"), "DWCA")

  vcr::use_cassette("occ_download_2", {
    x <- occ_download(
      pred_and(
        pred_within("POLYGON((-14 42, 9 38, -7 26, -14 42))"),
        pred_gte("elevation", 5000)
      )
    )
  }, match_requests_on = c("method", "uri", "body"))
  
  expect_is(x, "occ_download")
  expect_is(unclass(x), "character")
  expect_match(unclass(x)[1], "[0-9]+-[0-9]+")
  expect_equal(attr(x, "user"), "sckott")
  expect_equal(attr(x, "email"), "myrmecocystus@gmail.com")
  expect_equal(attr(x, "format"), "DWCA")

  vcr::use_cassette("occ_download_3", {
    z <- occ_download(pred_gte("decimalLatitude", 75), format = "SPECIES_LIST")
  }, match_requests_on = c("method", "uri", "body"))

  expect_is(z, "occ_download")
  expect_is(unclass(z), "character")
  expect_match(unclass(z)[1], "[0-9]+-[0-9]+")
  expect_equal(attr(z, "user"), "sckott")
  expect_equal(attr(z, "email"), "myrmecocystus@gmail.com")
  expect_equal(attr(z, "format"), "SPECIES_LIST")
})
