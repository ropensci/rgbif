context("name_suggest")

test_that("name_suggest returns the correct", {
  vcr::use_cassette("name_suggest", {
    a <- name_suggest(q='Puma concolor')
    b <- name_suggest(q='Puma', limit=2)
    d <- name_suggest(q='Puma', fields=c('key', 'higherClassificationMap'))
  }, preserve_exact_body_bytes = TRUE)

  # class
  expect_is(a, "gbif")
  expect_is(a$data, "data.frame")
  expect_is(a$data, "tbl")
  expect_is(a$hierarchy, "list")
  expect_equal(length(a$hierarchy), 0)
  
  expect_is(b, "gbif")
  expect_is(b$data, "data.frame")
  expect_is(b$data, "tbl")
  expect_is(b$hierarchy, "list")
  expect_equal(length(b$hierarchy), 0)

  expect_is(d, "gbif")
  expect_is(d$data, "data.frame")
  expect_is(d$data, "tbl")
  expect_is(d$hierarchy, "list")
  expect_gt(length(d$hierarchy), 0)
  
  expect_is(a$data$key, "integer")
  expect_is(b$data$canonicalName, "character")

  # name_suggest returns the correct dimensions
  expect_equal(NCOL(a$data), 3)
  expect_equal(NCOL(b$data), 3)
  expect_equal(NCOL(d$data), 1)
  expect_equal(names(b$data), c("key","canonicalName", "rank"))

  # value
  expect_match(b$data$canonicalName[1], "Puma")
  expect_true(tolower(a$data$rank[2]) %in% tolower(taxrank()))
  expect_true(tolower(b$data$rank[1]) %in% tolower(taxrank()))
})

# many args
test_that("args that support many repeated uses in one request", {
  vcr::use_cassette("name_suggest_many_args", {
    aa <- name_suggest(rank = c("family", "genus"))
  })

  expect_is(aa, "gbif")
  expect_is(aa$data, "data.frame")
  expect_is(aa$data, "tbl")
  expect_is(aa$data, "tbl_df")
  expect_equal(tolower(unique(aa$data$rank)), "family")
})
