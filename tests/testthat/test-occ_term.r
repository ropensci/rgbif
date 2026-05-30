context("occ_term")

test_that("occ_term works", {
  vcr::use_cassette("occ_term", {
    aa <- occ_term()
  })

  expect_is(aa, "data.frame")
  expect_true(all(c("simpleName", "qualifiedName", "source") %in% names(aa)))
})
