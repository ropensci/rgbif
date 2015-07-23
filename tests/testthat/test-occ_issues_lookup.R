context("occ_issues_lookup")

test_that("occ_issues_lookup", {
  skip_on_cran()

  aa <- occ_issues_lookup(issue = 'CONTINENT_COUNTRY_MISMATCH')
  bb <- occ_issues_lookup(issue = 'MULTIMEDIA_DATE_INVALID')
  cc <- occ_issues_lookup(issue = 'ZERO_COORDINATE')
  dd <- occ_issues_lookup(code = 'cdiv')

  expect_is(aa, "data.frame")
  expect_is(bb, "data.frame")
  expect_is(cc, "data.frame")
  expect_is(dd, "data.frame")

  # returns the correct dimensions
  expect_equal(NCOL(aa), 3)
  expect_equal(NCOL(bb), 3)
  expect_equal(NCOL(cc), 3)
  expect_equal(NCOL(dd), 3)
})

test_that("fails correctly", {
  skip_on_cran()

  expect_error(occ_issues_lookup(), "invalid 'pattern' argument")
})
