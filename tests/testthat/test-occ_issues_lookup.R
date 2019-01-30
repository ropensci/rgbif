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
  expect_equal(NCOL(aa), 4)
  expect_equal(NCOL(bb), 4)
  expect_equal(NCOL(cc), 4)
  expect_equal(NCOL(dd), 4)
})

test_that("fails correctly", {
  skip_on_cran()

  expect_error(occ_issues_lookup(),
               "Invalid pattern argument: issue and code both NULL."
  )
  expect_error(occ_issues_lookup(issue = "bad_issue_name"))
  expect_error(
    occ_issues_lookup(issue = 'CONTINENT_COUNTRY_MISMATCH',
                                 code = 'cdiv'),
    paste("Only one issue or one code allowed. Got: issue",
          "'CONTINENT_COUNTRY_MISMATCH' and code 'cdiv' at the same time.")
  )
  expect_error(
    occ_issues_lookup(issue = 'BACKBONE_MATCH_NONE'),
    paste("Issue 'BACKBONE_MATCH_NONE' is not related to occurrences.",
          "Try name_issues_lookup(issue = 'BACKBONE_MATCH_NONE')."),
    fixed = TRUE
  )
  expect_error(
    occ_issues_lookup(code = 'bbmn'),
    paste("Code 'bbmn' is not related to occurrences.",
          "Try name_issues_lookup(code = 'bbmn')."),
    fixed = TRUE
  )
})
