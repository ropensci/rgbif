context("occ_get")

test_that("returns the correct class", {
  vcr::use_cassette("occ_get", {
    tt <- occ_get(key = 855998194)

    aa <- occ_get_verbatim(key = 855998194)
    bb <- occ_get_verbatim(key = 855998194, fields = "all")
    cc <- occ_get_verbatim(key = c(855998194, 620594291),
      fields = c("scientificName", "decimalLatitude", "basisOfRecord"))
    dd <- occ_get(key = 855998194, fields = "all")
  }, preserve_exact_body_bytes = TRUE)

  expect_is(tt, "list")
  # not named
  expect_named(tt, NULL)
  expect_named(tt[[1]], c("hierarchy", "media", "data"))
  expect_is(tt[[1]]$data, "data.frame")
  expect_is(tt[[1]]$data$key, "character")
  expect_is(tt[[1]]$data$scientificName, "character")
  expect_lt(NCOL(tt[[1]]$data), 10)

  expect_is(aa, "data.frame")
  expect_is(aa$key, "character")
  expect_is(aa$scientificName, "character")

  expect_is(bb, "data.frame")
  expect_is(bb$key, "character")
  expect_is(bb$datasetKey, "character")
  expect_is(bb$gbifID, "character")

  expect_is(cc, "data.frame")
  expect_equal(NCOL(cc), 3)

  expect_is(dd, "list")
  expect_named(dd, NULL)
  expect_named(dd[[1]], c("hierarchy", "media", "data"))
  expect_is(dd[[1]]$data, "data.frame")
  expect_gt(NCOL(dd[[1]]$data), 60)
})

test_that("name_usage fails correctly", {
  skip_on_cran()
  expect_error(occ_get(key = 766766824, curlopts = list(timeout_ms = 1)))
})

test_that("works w/: fields all, & return extensions data", {
  keys <- c(1315970632, 1261282041, 1807810811, 1807914841)

  vcr::use_cassette("occ_get_other", {
    aa <- occ_get_verbatim(keys[1], fields = "all")
    bb <- occ_get_verbatim(keys[2], fields = "all")
    cc <- occ_get_verbatim(keys[3], fields = "all")
    dd <- occ_get_verbatim(keys[4], fields = "all")
  }, preserve_exact_body_bytes = TRUE)

  # extensions: Identification non-empty, Multimedia empty array
  expect_is(aa, "data.frame")
  expect_equal(NROW(aa), 1)
  expect_true(any(grepl("extensions", names(aa))))
  expect_false(any(grepl("Multimedia", names(aa))))

  # extensions: Identification missing, Multimedia doesn't exist
  expect_is(bb, "data.frame")
  expect_equal(NROW(bb), 1)
  expect_false(any(grepl("extensions", names(bb))))
  expect_false(any(grepl("Multimedia", names(bb))))

  # extensions: Identification missing, Multimedia non-empty
  expect_is(cc, "data.frame")
  expect_equal(NROW(cc), 1)
  expect_true(any(grepl("extensions", names(cc))))
  expect_false(any(grepl("Multimedia", names(aa))))

  # extensions: empty hash
  expect_is(dd, "data.frame")
  expect_equal(NROW(dd), 1)
  expect_false(any(grepl("extensions", names(dd))))
})
