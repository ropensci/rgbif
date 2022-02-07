test_that("occ_download_wait: real request works", {
  skip_on_cran()
  skip_on_ci()

  vcr::use_cassette("occ_download_wait_request", {
    downl_req <- occ_download(pred("taxonKey", 9206251),
      pred_in("country", c("US", "CA")), pred_gte("year", 1975))
    ww <- occ_download_wait(downl_req, status_ping = 3)
  })
  
  # Test if works with occ_download object
  expect_is(ww, "occ_download_meta")
  expect_is(unclass(ww), "list")
  expect_match(ww$key, "[0-9]+-[0-9]+")
  expect_equal(ww$status, "SUCCEEDED")

})


test_that("occ_download_wait: character key works", {
  skip_on_cran()
  skip_on_ci()
  
  vcr::use_cassette("occ_download_wait_character", {
    cc <- occ_download_wait("0000066-140928181241064")
    })
  
  # Test if works with character key
  expect_is(cc, "occ_download_meta")
  expect_is(unclass(cc), "list")
  expect_match(cc$key, "[0-9]+-[0-9]+")
  expect_equal(cc$status, "SUCCEEDED")
  
  # expect error
  expect_error(occ_download_wait(1),"x should be a downloadkey or an occ_download object.")
  expect_error(occ_download_wait("dog"),"x should be a downloadkey or an occ_download object.")
  
})






