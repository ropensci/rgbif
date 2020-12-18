test_that("occ_download_wait: real request works", {
  skip_on_cran()
  skip_on_ci()

  vcr::use_cassette("occ_download_wait_request", {
    downl_req <- occ_download(pred("taxonKey", 9206251),
      pred_in("country", c("US", "CA")), pred_gte("year", 1975))
    res <- occ_download_wait(downl_req, status_ping = 3)
  })

  expect_is(res, "occ_download_meta")
  expect_is(unclass(res), "list")
  expect_match(res$key, "[0-9]+-[0-9]+")
  expect_equal(res$status, "SUCCEEDED")
})
