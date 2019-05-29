test_that("gbif_citation", {
  vcr::use_cassette("gbif_citation", {
    res1 <- occ_search(taxonKey=9206251, limit=2)
    aa <- gbif_citation(res1)
  })
  
  expect_is(aa, "list")
  expect_is(aa[[1]], "gbif_citation")
  
  expect_named(aa[[1]], c('citation', 'rights'))
  
  expect_is(aa[[1]]$citation, 'list')
  expect_null(aa[[1]]$rights)
})

test_that("gbif_citation fails correctly", {
  expect_error(gbif_citation(), "no applicable method")
  expect_error(gbif_citation(matrix()), "no applicable method")

  # key field not included - errors
  vcr::use_cassette("gbif_citation_error", {
    res3 <- occ_search(taxonKey=9206251,
      fields=c('scientificName','basisOfRecord','protocol'), limit=20)
  })
  expect_error(suppressWarnings(gbif_citation(res3)),
    "No 'datasetKey' or 'key' fields found")
})
