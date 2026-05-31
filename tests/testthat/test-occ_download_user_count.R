context("occ_download_user_count")

# get original env vars/R options
keys <- c("GBIF_USER", "GBIF_PWD", "GBIF_EMAIL")
lkeys <- tolower(keys)
env_vars <- as.list(Sys.getenv(keys))
r_opts <- stats::setNames(lapply(lkeys, getOption), lkeys)

test_that("occ_download_user_count", {
  skip_on_cran()

  vcr::use_cassette("occ_download_user_count", {
    tt <- occ_download_user_count()
  })

  expect_is(tt, "integer")
  expect_equal(length(tt), 1)
  expect_gt(tt, 0)
})

test_that("occ_download_user_count with from parameter", {
  skip_on_cran()

  vcr::use_cassette("occ_download_user_count_from", {
    tt <- occ_download_user_count(from = "2023-01-01")
  })

  expect_is(tt, "integer")
  expect_equal(length(tt), 1)
})

test_that("occ_download_user_count with status parameter", {
  skip_on_cran()

  vcr::use_cassette("occ_download_user_count_status", {
    tt <- occ_download_user_count(status = "SUCCEEDED")
  })

  expect_is(tt, "integer")
  expect_equal(length(tt), 1)
})

test_that("occ_download_user_count fails well", {
  skip_on_cran()

  # not all creds available
  options(gbif_user = NULL, gbif_pwd = NULL, gbif_email = NULL)
  Sys.unsetenv("GBIF_USER"); Sys.unsetenv("GBIF_PWD"); Sys.unsetenv("GBIF_EMAIL")
  expect_error(occ_download_user_count(), "supply a username")

  # wrong type for from
  Sys.setenv(GBIF_USER = "foobar")
  expect_error(occ_download_user_count(from = 123), "from must be of class character")
  expect_error(occ_download_user_count(status = 123), "status must be of class character")
})

# set env vars/R options back to original
invisible(do.call(Sys.setenv, env_vars))
invisible(do.call(options, r_opts))
