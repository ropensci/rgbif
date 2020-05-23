test_that("occ_download_prep", {
  skip_on_cran()

  z <- occ_download_prep(
    pred_in(key="basisOfRecord", value=c("HUMAN_OBSERVATION", "OBSERVATION")),
    pred("hasCoordinate", TRUE),
    pred("hasGeospatialIssue", FALSE),
    pred("year", 1993),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z, "occ_download_prep")
  expect_is(z$url, "character")
  expect_is(z$user, "character")
  expect_equal(z$user, "foo")
  expect_is(z$pwd, "character")
  expect_equal(z$pwd, "bar")
  expect_is(z$email, "character")
  expect_equal(z$email, "foo@bar.com")
  expect_is(z$format, "character")
  expect_equal(z$format, "DWCA")
  expect_is(z$curlopts, "list")
  
  # request list
  expect_is(z$request, "list")
  expect_is(z$request$creator, "scalar")
  expect_equal(z$request$creator[1], "foo")
  expect_is(z$request$predicate, "list")
  expect_is(z$request$predicate$type, "scalar")
  expect_is(z$request$predicate$predicates, "list")
  expect_is(z$request$predicate$predicates[[1]], "list")
  expect_named(z$request$predicate$predicates[[1]],
    c("type", "key", "values"))
})

test_that("occ_download_prep print method", {
  skip_on_cran()

  wkt <- randgeo::wkt_polygon(num_vertices = 30)
  z <- occ_download_prep(
    pred_in(key="basisOfRecord", value=c("HUMAN_OBSERVATION", "OBSERVATION")),
    pred("hasCoordinate", TRUE),
    pred_within(wkt),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  w <- capture.output(print(z))
  w <- w[length(w)]
  expect_true(nchar(w) < 150)
})
