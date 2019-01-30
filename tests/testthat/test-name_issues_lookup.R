context("name_issues_lookup")

test_that("name_issues_lookup", {
  skip_on_cran()

  aa <- name_issues_lookup(issue = 'BACKBONE_MATCH_NONE')
  bb <- name_issues_lookup(issue = 'RANK_INVALID')
  cc <- name_issues_lookup(code = 'bbmn')
  dd <- name_issues_lookup(code = 'rankinv')

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

  expect_error(name_issues_lookup(),
               "Invalid pattern argument: issue and code both NULL."
  )
  expect_error(name_issues_lookup(issue = "bad_issue_name"))
  expect_error(
    name_issues_lookup(issue = 'BACKBONE_MATCH_NONE',
                      code = 'bbmn'),
    paste("Only one issue or one code allowed. Got: issue",
          "'BACKBONE_MATCH_NONE' and code 'bbmn' at the same time.")
  )
  expect_error(
    name_issues_lookup(issue = 'CONTINENT_COUNTRY_MISMATCH'),
    paste("Issue 'CONTINENT_COUNTRY_MISMATCH' is not related to names.",
          "Try occ_issues_lookup(issue = 'CONTINENT_COUNTRY_MISMATCH')."),
    fixed = TRUE
  )
  expect_error(
    name_issues_lookup(code = 'cdiv'),
    paste("Code 'cdiv' is not related to names.",
          "Try occ_issues_lookup(code = 'cdiv')."),
    fixed = TRUE
  )
})
