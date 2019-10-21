context("occ_download_queue")

# get original env vars/R options
keys <- c("GBIF_USER", "GBIF_PWD", "GBIF_EMAIL")
lkeys <- tolower(keys)
env_vars <- as.list(Sys.getenv(keys))
r_opts <- stats::setNames(lapply(lkeys, getOption), lkeys)

# FIXME: test this when request body matching works in vcr
test_that("occ_download_queue: real request works", {
  skip_on_cran()
  skip_on_travis()

  vcr::use_cassette("occ_download_queue", {
    tt <- occ_download_queue(
      occ_download("country = NZ", "year = 1993", "month = 1"),
      occ_download("catalogNumber = Bird.27847588", "year = 1971", "month = 4"),
      occ_download("taxonKey = 2435240", "year = 1974", "month = 2")
    )
  }, match_requests_on = c("method", "uri", "body"))

  expect_is(tt, "list")
  for (i in tt) expect_is(i, "occ_download")
  for (i in tt) expect_is(unclass(i), "character")
  for (i in tt) expect_equal(attr(i, "user"), "sckott")
  for (i in tt) expect_equal(attr(i, "email"), "myrmecocystus@gmail.com")

  # all succeeded
  for (i in tt) expect_equal(occ_download_meta(i)$status, "SUCCEEDED")
})

test_that("occ_download_queue fails well", {
  skip_on_cran()

  # no requests submitted
  expect_error(occ_download_queue(), "no requests submitted")

  # status_ping must be 10 or greater
  expect_error(
    occ_download_queue(occ_download("country = NZ", "year = 1999", "month = 3"),
      status_ping = 3),
    "is not TRUE"
  )

  # not all creds available
  options(gbif_user = NULL, gbif_pwd = NULL, gbif_email = NULL)
  Sys.unsetenv("GBIF_USER"); Sys.unsetenv("GBIF_PWD"); Sys.unsetenv("GBIF_EMAIL")
  expect_error(
    suppressMessages(occ_download_queue(
      occ_download("country = NZ", "year = 1999", "month = 3")
    )),
    "supply a username"
  )
  ## set username, run again
  Sys.setenv(GBIF_USER = "foobar")
  expect_error(
    suppressMessages(occ_download_queue(
      occ_download("country = NZ", "year = 1999", "month = 3")
    )),
    "supply a password"
  )
  ## set password, run again
  Sys.setenv(GBIF_PWD = "helloworld")
  expect_error(
    suppressMessages(occ_download_queue(
      occ_download("country = NZ", "year = 1999", "month = 3")
    )),
    "supply an email"
  )
})

# set env vars/R options back to original
invisible(do.call(Sys.setenv, env_vars))
invisible(do.call(options, r_opts))
