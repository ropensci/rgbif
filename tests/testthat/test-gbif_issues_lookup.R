context("gbif_issues_lookup")

test_that("check expected return from gbif_issues_lookup", {
  skip_on_cran()

  #
  aa <- gbif_issues_lookup(issue = 'CONTINENT_COUNTRY_MISMATCH')
  bb <- gbif_issues_lookup(issue = 'MULTIMEDIA_DATE_INVALID')
  cc <- gbif_issues_lookup(issue = 'ZERO_COORDINATE')
  dd <- gbif_issues_lookup(issue = 'BACKBONE_MATCH_NONE')
  ee <- gbif_issues_lookup(issue = 'RANK_INVALID')
  ff <- gbif_issues_lookup(code = 'cdiv')
  gg <- gbif_issues_lookup(code = 'bbmn')
  hh <- gbif_issues_lookup(code = 'rankinv')
  ii <- gbif_issues_lookup(issue = 'COORDINATE_PRECISION_INVALID')
  jj <- gbif_issues_lookup(issue = 'COORDINATE_UNCERTAINTY_METERS_INVALID')

  expect_is(aa, "data.frame")
  expect_is(bb, "data.frame")
  expect_is(cc, "data.frame")
  expect_is(dd, "data.frame")
  expect_is(ee, "data.frame")
  expect_is(ff, "data.frame")
  expect_is(gg, "data.frame")
  expect_is(hh, "data.frame")

  # returns the correct dimensions
  expect_equal(NCOL(aa), 4)
  expect_equal(NCOL(bb), 4)
  expect_equal(NCOL(cc), 4)
  expect_equal(NCOL(dd), 4)
  expect_equal(NCOL(ee), 4)
  expect_equal(NCOL(ff), 4)
  expect_equal(NCOL(gg), 4)
  expect_equal(NCOL(hh), 4)
})

test_that("gbif_issues_lookup fails correctly", {
  skip_on_cran()

  expect_error(gbif_issues_lookup(),
               "issue and code both NULL."
  )
  expect_error(
    gbif_issues_lookup(issue = 'BACKBONE_MATCH_NONE',
                       code = 'bbmn'),
    paste("Only one issue or one code allowed. Got: issue",
          "'BACKBONE_MATCH_NONE' and code 'bbmn' at the same time.")
  )
  expect_error(gbif_issues_lookup(issue = "bad_issue_name"),
               paste0("Issue 'bad_issue_name' doesn't exist. ",
                      "Type gbif_issues() for table with all possible issues."),
               fixed = TRUE
  )
  expect_error(gbif_issues_lookup(code = "bad"),
               paste("Issue code 'bad' doesn't exist.",
                     "Type gbif_issues() for table",
                     "with all possible issue codes."),
               fixed = TRUE
  )
})
