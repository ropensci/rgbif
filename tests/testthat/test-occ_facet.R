context("occ_facet")

test_that("occ_facet works", {
  skip_on_cran()

  aa <- occ_facet(facet = "country")

  expect_is(aa, "list")
  expect_named(aa, "country")
  expect_named(aa$country, c('name', 'count'))

  # facetMincount
  bb <- occ_facet(facet = "country", facetMincount = 30000000L)

  expect_is(bb, "list")
  expect_named(bb, "country")
  expect_named(bb$country, c('name', 'count'))

  expect_lt(NROW(bb$country), NROW(aa$country))
})

test_that("occ_facet paging works", {
  skip_on_cran()

  aa <- occ_facet(
    facet = c("country", "basisOfRecord", "hasCoordinate"),
    country.facetLimit = 3,
    basisOfRecord.facetLimit = 6
  )

  expect_is(aa, "list")
  expect_equal(sort(names(aa)), c("basisOfRecord", "country", "hasCoordinate"))
  expect_named(aa$country, c('name', 'count'))
  expect_named(aa$basisOfRecord, c('name', 'count'))
  expect_named(aa$hasCoordinate, c('name', 'count'))
  expect_equal(NROW(aa$country), 3)
  expect_equal(NROW(aa$basisOfRecord), 6)
})

test_that("occ_facet fails well", {
  skip_on_cran()

  expect_error(
    occ_facet(),
    "argument \"facet\" is missing"
  )

  # unknown facet variable
  expect_equal(
    length(occ_facet(facet = "asdfasdf")),
    0
  )
})
