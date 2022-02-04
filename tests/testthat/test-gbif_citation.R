test_that("gbif_citation w/ occ_search", {
  vcr::use_cassette("gbif_citation", {
    res1 <- occ_search(taxonKey=9206251, limit=2)
    aa <- expect_warning(gbif_citation(res1),"gbif_citation\\(\\) for occ_search\\(\\)")
  }, preserve_exact_body_bytes = TRUE)
  expect_is(aa, "list")
  expect_is(aa[[1]], "gbif_citation")
  expect_named(aa[[1]], c('citation', 'rights'))
  expect_is(aa[[1]]$citation, 'list')
  expect_is(aa[[1]]$rights, "character")
})

test_that("gbif_citation w/ occ_data", {
  vcr::use_cassette("gbif_citation_occ_data", {
    res1 <- occ_data(taxonKey=9206251, limit=2)
    aa <- expect_warning(gbif_citation(res1),"gbif_citation\\(\\) for occ_search\\(\\)")
  }, preserve_exact_body_bytes = TRUE)
  expect_is(aa, "list")
  expect_is(aa[[1]], "gbif_citation")
  expect_named(aa[[1]], c('citation', 'rights'))
  expect_is(aa[[1]]$citation, 'list')
  expect_is(aa[[1]]$rights, "character")
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

test_that("gbif_citation w/ datasetkey", {
  vcr::use_cassette("gbif_citation_datasetkey", {
    vv <- gbif_citation("b124e1e0-4755-430f-9eab-894f25a9b59c")
  }, preserve_exact_body_bytes = TRUE)
  expect_equal(class(vv$citation),"list")
  expect_equal(class(vv$citation$title),"character")
  expect_equal(class(vv$citation$text),"character")
  expect_equal(class(vv$citation$accessed),"character")
  expect_equal(class(vv$citation$citation),"character")
  expect_equal(class(vv$rights),"character")
})

test_that("gbif_citation fails correctly", {
  expect_error(gbif_citation(), "no applicable method")
  expect_error(gbif_citation(matrix()), "no applicable method")
})



