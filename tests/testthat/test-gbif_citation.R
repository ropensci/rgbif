
test_that("gbif_citation w/ occ_search", {
  vcr::use_cassette("gbif_citation", {
    ss <- occ_search(taxonKey=9206251, limit=2)
  }, preserve_exact_body_bytes = TRUE)
  expect_warning(gbif_citation(ss)$download, "gbif_citation\\(\\) for occ_search\\(\\)")
})

test_that("gbif_citation w/ occ_data", {
  vcr::use_cassette("gbif_citation_occ_data", {
    dd <- occ_data(taxonKey=9206251, limit=2)
  }, preserve_exact_body_bytes = TRUE)
  expect_warning(gbif_citation(dd)$download, "gbif_citation\\(\\) for occ_search\\(\\)")
})

test_that("gbif_citation w/ occ_download_meta", {
  vcr::use_cassette("gbif_citation_occ_download_meta", {
    res <- occ_download_meta("0000122-171020152545675")
    cc <- gbif_citation(res)
  }, preserve_exact_body_bytes = TRUE)
  expect_equal(class(cc$download),"character")
  expect_equal(cc$download, "GBIF Occurrence Download https://doi.org/10.15468/dl.yghxj7 Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2017-10-20")
})

test_that("gbif_citation w/ downloadkey", {
  vcr::use_cassette("gbif_citation_downloadkey", {
    kk <- gbif_citation("0000122-171020152545675")
  }, preserve_exact_body_bytes = TRUE)
  expect_equal(class(kk$download),"character")
  expect_equal(kk$download, "GBIF Occurrence Download https://doi.org/10.15468/dl.yghxj7 Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2017-10-20")
})

test_that("gbif_citation fails correctly", {
  expect_error(gbif_citation(), "no applicable method")
  expect_error(gbif_citation(matrix()), "no applicable method")
})



