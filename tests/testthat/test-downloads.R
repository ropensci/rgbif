context("occ_download_queue")
test_that("occ_download_queue fails well", {
  skip_on_cran()

  expect_error(occ_download_queue(status_ping = "foobar"), 
    "status_ping must be of class")
})


context("GbifQueue")
test_that("GbifQueue fails well", {
  skip_on_cran()

  empty <- GbifQueue$new()

  expect_is(empty, "GbifQueue")
  expect_equal(length(empty$reqs), 0)
  expect_equal(empty$jobs(), 0)
  expect_equal(empty$next_(), empty$last_())
  expect_error(empty$add_all(), "no jobs to add")
  expect_error(empty$add(), "argument \"x\" is missing")
})

test_that("GbifQueue works with occ_download inputs", {
  skip_on_cran()

  x <- GbifQueue$new(
    occ_download('taxonKey = 3119195', "year = 1976"),
    occ_download('taxonKey = 3119195', "year = 2001"),
    occ_download('taxonKey = 3119195', "year = 2001", "month <= 8")
  )
  
  expect_is(x, "GbifQueue")
  expect_is(x$reqs, "list")
  expect_equal(length(x$reqs), 3)
  expect_is(x$add_all, "function")

  # length 0 before adding any jobs
  expect_equal(x$jobs(), 0)

  # length 3 after adding all
  x$add_all()
  expect_equal(x$jobs(), 3)

  # length 2 after removal
  x$remove(x$reqs[[1]])
  expect_equal(x$jobs(), 2)
})

test_that("GbifQueue works with occ_download_prep inputs", {
  skip_on_cran()

  z <- occ_download_prep(
    "basisOfRecord = HUMAN_OBSERVATION,OBSERVATION",
    "hasCoordinate = true",
    "hasGeospatialIssue = false",
    "year = 1993",
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )
  zz <- occ_download_prep(
    "basisOfRecord = HUMAN_OBSERVATION",
    "hasGeospatialIssue = true",
    "year = 2003",
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )
  x <- GbifQueue$new(.list = list(z, zz))

  expect_is(x, "GbifQueue")
  expect_is(x$reqs, "list")
  expect_equal(length(x$reqs), 2)
  expect_is(x$add_all, "function")

  # length 0 before adding any jobs
  expect_equal(x$jobs(), 0)

  # length 2 after adding all
  x$add_all()
  expect_equal(x$jobs(), 2)

  # length 1 after removal
  x$remove(x$reqs[[1]])
  expect_equal(x$jobs(), 1)
})


context("DownReq")
test_that("DownReq fails well", {
  skip_on_cran()

  expect_error(DownReq$new(), 
    "argument \"x\" is missing")
})

test_that("DownReq works with occ_download_prep inputs", {
  skip_on_cran()

  res <- DownReq$new(occ_download_prep("basisOfRecord = LITERATURE",
    user = "foo", pwd = "bar", email = "foo@bar.com"))

  expect_is(res, "DownReq")
  expect_is(res$run, "function")
  expect_null(res$result)
  expect_equal(res$type, "pre")
  expect_is(res$status, "function")
  expect_error(res$status(), "run\\(\\) result is `NULL`, not checking status")
})
