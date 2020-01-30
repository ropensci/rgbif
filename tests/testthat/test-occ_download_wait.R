context("occ_download_wait")

# FIXME: this is not a great test, use vcr to cache a occ_download request

test_that("occ_download_wait: real request works", {
  skip_on_cran()
  skip_on_travis()

  # prepare the download to save to tests/testthat
  # occ_download_wait_obj <- occ_download(pred("taxonKey", 9206251),
  #   pred_in("country", c("US", "MX")), pred_gte("year", 1982))
  # save(occ_download_wait_obj,
  #   file = "tests/testthat/occ_download_wait_obj.rda", version = 2)
  load("occ_download_wait_obj.rda")

  vcr::use_cassette("occ_download_wait_request", {
    res <- occ_download_wait(occ_download_wait_obj)
  })

  expect_is(res, "occ_download_meta")
})
