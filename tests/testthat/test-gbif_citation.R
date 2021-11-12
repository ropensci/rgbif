
test_that("gbif_citation w/ occ_search", {
  vcr::use_cassette("gbif_citation", {
    res1 <- occ_search(taxonKey=9206251, limit=2)
  }, preserve_exact_body_bytes = TRUE)
  expect_output(gbif_citation(res1), "gbif_citation\\(\\) for occ_search\\(\\)")
})

test_that("gbif_citation w/ occ_data", {
  vcr::use_cassette("gbif_citation_occ_data", {
    res1 <- occ_data(taxonKey=9206251, limit=2)
  }, preserve_exact_body_bytes = TRUE)
  expect_output(gbif_citation(res1), "gbif_citation\\(\\) for occ_search\\(\\)")
})

test_that("gbif_citation w/ occ_download_meta", {
  vcr::use_cassette("gbif_citation_occ_download_meta", {
    res <- occ_download_meta("0000122-171020152545675")
    cc <- gbif_citation(res)
  }, preserve_exact_body_bytes = TRUE)
  expect_equal(class(cc$download),"character")
  expect_equal(cc$download, "GBIF Occurrence Download https://doi.org/10.15468/dl.yghxj7 Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2017-10-20")
})

test_that("gbif_citation fails correctly", {
  expect_error(gbif_citation(), "no applicable method")
  expect_error(gbif_citation(matrix()), "no applicable method")
})



