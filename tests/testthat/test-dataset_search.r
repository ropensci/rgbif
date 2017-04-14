context("dataset_search")

test_that("type query returns the correct class", {
  skip_on_cran()

  tt <- dataset_search(type="OCCURRENCE")
  expect_is(tt, "list")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data, "tbl_df")
  expect_is(tt$descriptions, "list")
  expect_is(tt$data[1,1], "tbl_df")
  expect_is(tt$data[1,1]$datasetTitle, "character")
})

# Gets all datasets tagged with keyword "france".
test_that("keyword query returns the correct", {
  skip_on_cran()

  tt <- dataset_search(keyword = "france")

  # class
  expect_is(tt, "list")
  expect_is(tt$data, "tbl_df")
  expect_is(tt$data[1,1], "tbl_df")
  expect_is(tt$data[1,1]$datasetTitle, "character")

  # value
  expect_equal(as.character(tt$data$publishingCountry[1]), "FR")
  expect_equal(as.character(tt$data[1,4]), "Tela Botanica")
})

# Fulltext search for all datasets having the word "amsterdam" somewhere in
# its metadata (title, description, etc).
test_that("search query returns the correct class", {
  skip_on_cran()

  tt <- dataset_search(query="amsterdam")
  expect_is(tt, "list")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data, "tbl_df")
  expect_is(tt$meta, "data.frame")
  expect_is(tt$descriptions, "list")
  expect_that(is.null(tt$facets), is_true())
  expect_is(tt$data[1,1], "tbl_df")
  expect_is(tt$data[1,1]$datasetTitle, "character")
})

# Limited search
test_that("limited search returns the correct", {
  skip_on_cran()

  tt <- dataset_search(type="OCCURRENCE", limit=2)

  # class
  expect_is(tt$data, "data.frame")
  expect_is(tt$data, "tbl_df")
  expect_is(tt$data[1,1], "tbl_df")
  expect_is(tt$data[1,1]$datasetTitle, "character")

  # dims
  expect_equal(dim(tt$data), c(2,8))
})

# Return just descriptions
test_that("limited fields query returns the correct class", {
  skip_on_cran()

  tt <- dataset_search(type="OCCURRENCE", return="descriptions")
  expect_is(tt, "list")
})


# Return just descriptions
test_that("args that support many repeated uses in one request", {
  skip_on_cran()

  aa <- dataset_search(type = c("metadata", "checklist"))
  bb <- dataset_search(publishingCountry = c("DE", "NZ"))

  expect_is(aa, "list")
  expect_named(aa, c('meta', 'data', 'facets', 'descriptions'))
  expect_is(aa$data, "tbl_df")
  expect_equal(tolower(unique(aa$data$type)), c("checklist", "metadata"))

  expect_is(bb, "list")
  expect_named(bb, c('meta', 'data', 'facets', 'descriptions'))
  expect_is(bb$data, "tbl_df")
  expect_equal(tolower(unique(bb$data$publishingCountry)), c("de", "nz"))
})
