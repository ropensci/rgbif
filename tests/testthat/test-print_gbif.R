context("print_gbif")

test_that("print_gbif w/ occ_search", {
  skip_on_cran()
  # occ_search_eg1 <- occ_search(taxonKey=3118771, limit=20)
  # save(occ_search_eg1, file="tests/testthat/occ_search_eg1.rda", version=2)

  load("occ_search_eg1.rda")
  expect_is(occ_search_eg1, "gbif")
  expect_is(print.gbif, "function")

  expect_output(print(occ_search_eg1), "Records found")
  expect_output(print(occ_search_eg1), "Records returned")
  expect_output(print(occ_search_eg1), "No. unique hierarchies")
  expect_output(print(occ_search_eg1), "No. media records")
  expect_output(print(occ_search_eg1), "No. facets")
  expect_output(print(occ_search_eg1), "Args")
  expect_output(print(occ_search_eg1), "# A tibble")
  expect_output(print(occ_search_eg1), "more variables")
})

test_that("print_gbif w/ name_lookup", {
  skip_on_cran()
  # name_lookup_eg1 <- name_lookup(query='mammalia', limit = 20)
  # save(name_lookup_eg1, file="tests/testthat/name_lookup_eg1.rda", version=2)

  load("name_lookup_eg1.rda")
  expect_is(name_lookup_eg1, "gbif")

  expect_output(print(name_lookup_eg1), "Records found")
  expect_output(print(name_lookup_eg1), "Records returned")
  expect_output(print(name_lookup_eg1), "No. unique hierarchies")
  expect_output(print(name_lookup_eg1), "No. facets")
  expect_output(print(name_lookup_eg1), "Args")
  expect_output(print(name_lookup_eg1), "# A tibble")
  expect_output(print(name_lookup_eg1), "more variables")
})
