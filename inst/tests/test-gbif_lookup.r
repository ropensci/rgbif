context("gbif_lookup")

tt <- gbif_lookup(name='Helianthus annuus', kingdom='plants')

test_that("gbif_lookup returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt$usageKey, "numeric")
  expect_is(tt$family, "character")
})

test_that("gbif_lookup returns the correct value", {
  expect_equal(tt$family, "Asteraceae")
  expect_equal(tt$speciesKey, 3119195)
})