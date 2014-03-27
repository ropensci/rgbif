context("name_backbone")

tt <- name_backbone(name='Helianthus annuus', rank='species')
uu <- name_backbone(name='Helianthus annuus', rank='species', verbose = TRUE)

test_that("name_backbone returns the correct class", {
  expect_is(tt, "list")
  expect_is(uu$alternatives$phylumKey, "numeric")
  expect_is(uu$alternatives$canonicalName, "character")
})