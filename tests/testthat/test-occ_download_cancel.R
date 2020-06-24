test_that("occ_download_cancel", {
  skip_on_cran()

  vcr::use_cassette("occ_download_cancel_prep", {
    zzz <- occ_download(pred("taxonKey", 9206251),
      pred_in("country", c("US", "CA")), pred_gte("year", 1979))
  }, match_requests_on = c("method", "uri", "body"))

  Sys.sleep(1)

  vcr::use_cassette("occ_download_cancel", {
    expect_message((out=occ_download_cancel(zzz)),
      "Download sucessfully deleted")
  }, match_requests_on = c("method", "uri", "body"))
  expect_null(out)
})

test_that("occ_download_cancel fails well", {
  skip_on_cran()
  # key missing
  expect_error(occ_download_cancel())
  # key wrong type
  expect_error(occ_download_cancel(5))
})

test_that("occ_download_cancel_staged", {
  skip_on_cran()
  expect_message((res=occ_download_cancel_staged()), "no staged downloads")
})
