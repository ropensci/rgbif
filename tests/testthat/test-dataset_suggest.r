context("dataset_suggest")

test_that("type query returns the correct class", {
  vcr::use_cassette("dataset_suggest", {
    tt <- dataset_suggest(query="Amazon", type="OCCURRENCE")
  })

  expect_is(tt, "data.frame")
  expect_is(tt, "tbl_df")
  expect_is(tt[1,1], "tbl_df")
  expect_is(tt[1,1]$key, "character")
})


# Fulltext search for all datasets having the word "amsterdam" somewhere in
# its metadata (title, description, etc).
test_that("search query returns the correct class", {
  vcr::use_cassette("dataset_suggest_query", {
    tt <- dataset_suggest(query="amsterdam")
  }, preserve_exact_body_bytes = TRUE)

  expect_is(tt, "data.frame")
  expect_is(tt, "tbl_df")
  expect_is(tt$title, "character")
  expect_is(tt$title[[1]], "character")
})

# Limited search
test_that("limited search returns the correct class", {
  vcr::use_cassette("dataset_suggest_limit", {
    tt <- dataset_suggest(type="OCCURRENCE", limit=2)
  })

  expect_is(tt, "data.frame")
  expect_is(tt, "tbl_df")
  expect_is(tt[1,1], "tbl_df")
  expect_is(tt[1,1]$key, "character")
})

# Return just descriptions
test_that("limited fields query returns the correct class", {
  vcr::use_cassette("dataset_suggest_description", {
    tt <- dataset_suggest(type="OCCURRENCE", description=TRUE)
  }, preserve_exact_body_bytes = TRUE)

  expect_is(tt, "list")
  expect_is(tt[[1]], "character")
})

# many args
test_that("args that support many repeated uses in one request", {
  vcr::use_cassette("dataset_suggest_repeated", {
    aa <- dataset_suggest(type = c("metadata", "checklist"))
  }, preserve_exact_body_bytes = TRUE)

  expect_is(aa, "tbl_df")
  expect_named(aa, c('key', 'type', 'title'))
  expect_true(any(tolower(unique(aa$type)) %in% c("checklist", "metadata")))
})
