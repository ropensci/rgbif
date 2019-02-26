context("occ_count")

test_that("occ_count", {
  vcr::use_cassette("occ_count", {
    a <- occ_count(basisOfRecord='OBSERVATION')
    b <- occ_count(georeferenced=TRUE)
    c <- occ_count(year=2012)
    d <- occ_count(type='schema')
    e <- occ_count(type='countries')
    f <- occ_count(type='year', from=2000, to=2012)
  }, preserve_exact_body_bytes = TRUE)
  
  # returns the correct class
  expect_is(a, "numeric")
  expect_is(b, "numeric")
  expect_is(c, "numeric")
  expect_is(d, "list")
  expect_is(e, "list")
  expect_is(f, "list")

  # returns the correct value
  expect_equal(names(d[[1]]$dimensions[[1]]), c("key","type"))
  expect_equal(names(e)[1], "UNITED_STATES")

  # returns the correct dimensions
  expect_equal(length(a), 1)
  expect_equal(length(b), 1)
  expect_equal(length(c), 1)
  expect_gt(length(d), 30)
  expect_gt(length(e), 200)
})


test_that("occ_count fails well", {
  vcr::use_cassette("occ_count_fails_well", {

    # these two params not allowed together
    expect_error(
      occ_count(basisOfRecord='OBSERVATION', year=2012),
      "The provided address is not calculated in the cube"
    )

    # these two params not allowed together
    expect_error(
      occ_count(basisOfRecord='OBSERVATION', typeStatus='ALLOTYPE'),
      "The provided address is not calculated in the cube"
    )

  })
})
