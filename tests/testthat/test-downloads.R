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
    occ_download(pred('taxonKey', 3119195), pred("year", 1976)),
    occ_download(pred('taxonKey', 3119195), pred("year", 2001)),
    occ_download(pred('taxonKey', 3119195), pred("year", 2001),
      pred_lte("month", 8))
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
    pred_in(key="basisOfRecord", value=c("HUMAN_OBSERVATION", "OBSERVATION")),
    pred("hasCoordinate", TRUE),
    pred("hasGeospatialIssue", FALSE),
    pred("year", 1993),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )
  zz <- occ_download_prep(
    pred("basisOfRecord", "HUMAN_OBSERVATION"),
    pred("hasGeospatialIssue", TRUE),
    pred("year", 2003),
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

  res <- DownReq$new(occ_download_prep(pred("basisOfRecord", "LITERATURE"),
    user = "foo", pwd = "bar", email = "foo@bar.com"))

  expect_is(res, "DownReq")
  expect_is(res$run, "function")
  expect_null(res$result)
  expect_equal(res$type, "pre")
  expect_is(res$status, "function")
  expect_error(res$status(), "run\\(\\) result is `NULL`, not checking status")
})

test_that("occ_download fails well when user does not input predicates", {
  skip_on_cran()

  expect_error(
    occ_download(taxonKey = 5039705, hasCoordinate = TRUE,
      basisOfRecord = "Preserved_Specimen"),
    "all inputs must be"
  )
  expect_error(
    occ_download('taxonKey = 5039705'),
    "all inputs must be"
  )
})

## type "in" works
test_that("type in works", {
  skip_on_cran()

  z <- occ_download_prep(pred_in("taxonKey", c(2480946, 5229208)),
    format = "SIMPLE_CSV")

  expect_is(z, "occ_download_prep")
  # list has names
  expect_named(z$request$predicate)
  # right type
  expect_equal(unclass(z$request$predicate$type), "in")
  # a vector of length two for each thing passed in
  expect_equal(z$request$predicate$values, c("2480946", "5229208"))
})

