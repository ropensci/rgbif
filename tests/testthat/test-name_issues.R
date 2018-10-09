context("name_issues")

test_that("name_issues", {
  aa <- name_issues()
  
  expect_is(aa, "data.frame")
  expect_named(aa, c('code', 'issue', 'description'))
  expect_is(aa$code, 'character')
  expect_is(aa$issue, 'character')
  expect_is(aa$description, 'character')
})

test_that("fails correctly", {
  expect_error(name_issues(5), "unused argument")
})
