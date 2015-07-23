context("gbif_names")

test_that("gbif_names", {
  skip_on_cran()

  aa <- gbif_names(name_lookup(query='snake', hl=TRUE), browse=FALSE)
  expect_is(aa, "character")
  expect_match(aa, "/var/folders")
  expect_match(aa, "index.html")

  out <- name_lookup(query='canada', hl=TRUE, limit=5)
  bb <- gbif_names(out, browse = FALSE)
  cc <- gbif_names(name_lookup(query='snake', hl=TRUE), browse = FALSE)
  dd <- gbif_names(name_lookup(query='bird', hl=TRUE), browse = FALSE)

  expect_is(bb, "character")
  expect_is(cc, "character")
  expect_is(dd, "character")
  expect_equal(length(bb), 1)
  expect_equal(length(cc), 1)
  expect_equal(length(dd), 1)
  expect_match(bb, "index.html")
  expect_match(cc, "index.html")
  expect_match(dd, "index.html")
})

test_that("fails correctly", {
  skip_on_cran()

  nms <- name_lookup(query='snake', hl=TRUE)
  res <- gbif_names(nms, browse=FALSE)

  # input of wrong class fails well
  expect_error(gbif_names("adf", browse = FALSE), "input should be of class list")
  expect_error(gbif_names(77, browse = FALSE), "input should be of class list")
  # output fails well
  expect_error(gbif_names(nms, 6, browse = FALSE), "invalid 'file' argument")
})
