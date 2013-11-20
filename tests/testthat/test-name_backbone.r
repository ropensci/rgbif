context("name_backbone")

tt <- name_backbone(name='Helianthus annuus', kingdom='plants')

test_that("name_backbone returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt$usageKey, "numeric")
  expect_is(tt$family, "character")
})

test_that("name_backbone returns the correct value", {
  expect_equal(tt$family, "Asteraceae")
  expect_equal(tt$speciesKey, 3119195)
})