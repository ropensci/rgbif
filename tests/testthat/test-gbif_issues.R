context("gbif_issues")

test_that("gbif_issues", {
  aa <- gbif_issues()
  
  expect_is(aa, "data.frame")
  expect_named(aa, c('code', 'issue', 'description'))
  expect_is(aa$code, 'character')
  expect_is(aa$issue, 'character')
  expect_is(aa$description, 'character')
})

test_that("fails correctly", {
  expect_error(gbif_issues(5), "unused argument")
})
