context("occ_download_queue")

# set to dev GBIF API base url
Sys.setenv(RGBIF_BASE_URL = "https://api.gbif-uat.org/v1")

# get original env vars/R options
keys <- c("GBIF_USER", "GBIF_PWD", "GBIF_EMAIL")
lkeys <- tolower(keys)
env_vars <- as.list(Sys.getenv(keys))
r_opts <- stats::setNames(lapply(lkeys, getOption), lkeys)

# Long running test block, skip except locally
test_that("occ_download_queue: real request works", {
  skip_on_cran()
  skip_on_ci()

  vcr::use_cassette("occ_download_queue", {
    tt <- occ_download_queue(
      occ_download(pred("country", "NZ"), pred("year", 1993), pred("month", 1)),
      occ_download(pred("catalogNumber", "Bird.27847588"), pred("year", 1971), pred("month", 4)),
      occ_download(pred("taxonKey", 2435240), pred("year", 1974), pred("month", 2))
    )
  }, match_requests_on = c("method", "uri", "body"))

  expect_is(tt, "list")
  for (i in tt) expect_is(i, "occ_download")
  for (i in tt) expect_is(unclass(i), "character")
  for (i in tt) expect_equal(attr(i, "user"), Sys.getenv("GBIF_USER"))
  for (i in tt) expect_equal(attr(i, "email"), Sys.getenv("GBIF_EMAIL"))

  # all succeeded
  for (i in tt) expect_equal(occ_download_meta(i)$status, "SUCCEEDED")
})

test_that("occ_download_queue fails well", {
  skip_on_cran()
  skip_on_ci()

  # no requests submitted
  expect_error(occ_download_queue(), "no requests submitted")

  # status_ping must be 10 or greater
  expect_error(
    occ_download_queue(occ_download(pred("country", "NZ"), pred("year", 1999), pred("month", 3)),
      status_ping = 3),
    "is not TRUE"
  )

  # not all creds available
  options(gbif_user = NULL, gbif_pwd = NULL, gbif_email = NULL)
  Sys.unsetenv("GBIF_USER"); Sys.unsetenv("GBIF_PWD"); Sys.unsetenv("GBIF_EMAIL")
  expect_error(
    suppressMessages(occ_download_queue(
      occ_download(pred("country", "NZ"), pred("year", 1999), pred("month", 3))
    )),
    "supply a username"
  )
  ## set username, run again
  Sys.setenv(GBIF_USER = "foobar")
  expect_error(
    suppressMessages(occ_download_queue(
      occ_download(pred("country", "NZ"), pred("year", 1999), pred("month", 3))
    )),
    "supply a password"
  )
  ## set password, run again
  Sys.setenv(GBIF_PWD = "helloworld")
  expect_error(
    suppressMessages(occ_download_queue(
      occ_download(pred("country", "NZ"), pred("year", 1999), pred("month", 3))
    )),
    "supply an email"
  )
})

test_that("occ_download_queue fails well", {
  skip_on_cran()

  expect_error(occ_download_queue(status_ping = "foobar"), 
    "status_ping must be of class")
})

# cleanup url change
Sys.unsetenv("RGBIF_BASE_URL")

# set env vars/R options back to original
invisible(do.call(Sys.setenv, env_vars))
invisible(do.call(options, r_opts))
