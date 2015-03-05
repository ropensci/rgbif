context("name_backbone")

tt <- name_backbone(name='Helianthus annuus', rank='species')
uu <- name_backbone(name='Helianthus annuus', rank='species', verbose = TRUE)

test_that("name_backbone returns the correct class", {
  expect_is(tt, "list")
  expect_is(uu$alternatives$phylumKey, "integer")
  expect_is(uu$alternatives$canonicalName, "character")
})

test_that("Throws error because a name is required in the function call", {
  expect_error(name_backbone(kingdom='plants'), "argument \"name\" is missing")
})
