context("count_facet")

a <- count_facet(by='country', countries=3, removezeros = TRUE)
b <- count_facet(by='country', countries='AR', removezeros = TRUE)

# by country name
countries <- isocodes$code[1:10]
c <- count_facet(by='country', countries=countries, removezeros = TRUE)

# get occurrences by georeferenced state
d <- count_facet(by='georeferenced')

test_that("returns the correct class", {
  expect_is(a, "data.frame")
  expect_is(b, "data.frame")
  expect_is(c, "data.frame")
  expect_is(d, "data.frame")
  expect_is(a$country, "character")
})

test_that("returns the correct dimensions", {
  expect_equal(NCOL(a), 2)
  expect_equal(NCOL(b), 2)
  expect_equal(NCOL(c), 2)
  expect_equal(NCOL(d), 2)
})

test_that("returns the correct values", {
  expect_equal(c$country, c("AD", "AE", "AF", "AG", "AI", "AL", "AM", "AO", "AQ", "AR"))
})

test_that("fails correctly", {
  # throws error, you can't use basisOfRecord and keys in the same call
  expect_error(count_facet(c(2489670, 5231042, 2481447), by="basisOfRecord"), 
               "you can't pass in both keys and have by='basisOfRecord'")
})
