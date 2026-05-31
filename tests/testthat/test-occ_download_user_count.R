context("occ_download_user_count")

test_that("occ_download_user_count", {
  skip_on_cran()

  vcr::use_cassette("occ_download_user_count", {
    tt <- occ_download_user_count(user = "jwaller")
  })

  expect_is(tt, "integer")
  expect_equal(length(tt), 1)
  expect_gt(tt, 0)
})

test_that("occ_download_user_count with from parameter", {
  skip_on_cran()

  vcr::use_cassette("occ_download_user_count_from", {
    tt <- occ_download_user_count(user = "jwaller", from = "2023-01-01")
  })

  expect_is(tt, "integer")
  expect_equal(length(tt), 1)
})

test_that("occ_download_user_count with status parameter", {
  skip_on_cran()

  vcr::use_cassette("occ_download_user_count_status", {
    tt <- occ_download_user_count(user = "jwaller", status = "SUCCEEDED")
  })

  expect_is(tt, "integer")
  expect_equal(length(tt), 1)
})

test_that("occ_download_user_count fails well", {
  skip_on_cran()

  options(gbif_user = NULL)
  Sys.unsetenv("GBIF_USER")
  expect_error(occ_download_user_count(), "supply a username")

  expect_error(occ_download_user_count(user = "jwaller", from = 123),
    "from must be of class character")
  expect_error(occ_download_user_count(user = "jwaller", status = 123),
    "status must be of class character")
})
