context("occ_download_list")

# get original env vars/R options
keys <- c("GBIF_USER", "GBIF_PWD", "GBIF_EMAIL")
lkeys <- tolower(keys)
env_vars <- as.list(Sys.getenv(keys))
r_opts <- stats::setNames(lapply(lkeys, getOption), lkeys)

test_that("occ_download_list", {
  skip_on_cran()
  skip_on_ci()

  vcr::use_cassette("occ_download_list", {
    tt <- occ_download_list()
  })

  expect_is(tt, "list")
  expect_is(tt$meta, "data.frame")
  expect_equal(sort(names(tt$meta)), 
    c("count", "endofrecords", "limit", "offset"))
  expect_is(tt$results$key, "character")
  expect_type(tt$results$size, "double")
  expect_equal(NROW(tt$meta), 1)
  expect_gt(NROW(tt$result), 3)
})

test_that("occ_download_list fails well", {
  skip_on_cran()

  # not all creds available
  options(gbif_user = NULL, gbif_pwd = NULL, gbif_email = NULL)
  Sys.unsetenv("GBIF_USER"); Sys.unsetenv("GBIF_PWD"); Sys.unsetenv("GBIF_EMAIL")
  expect_error(occ_download_list(), "supply a username")
  
  ## set username, run again
  Sys.setenv(GBIF_USER = "foobar")
  expect_error(occ_download_list(), "supply a password", class = "error")

  ## set username, run again
  Sys.setenv(GBIF_PWD = "cheese")
  vcr::use_cassette("occ_download_list_unauthorized", {
    expect_error(occ_download_list(), "Unauthorized", class = "error")
  })
})

# set env vars/R options back to original
invisible(do.call(Sys.setenv, env_vars))
invisible(do.call(options, r_opts))

test_that("occ_download_list fails well", {
  skip_on_cran()

  # type checking
  expect_error(occ_download_list(limit = "x"),
    "limit must be of class integer, numeric")
  expect_error(occ_download_list(start = "x"),
    "start must be of class integer, numeric")
})
