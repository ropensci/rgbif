context("oai")

test_that("gbif_oai_identify", {
  skip_on_cran()

  tt <- gbif_oai_identify()

  expect_is(tt, "list")
  expect_is(tt$repositoryName, "character")
  expect_equal(tt$repositoryName, "GBIF Registry")
})

test_that("gbif_oai_list_metadataformats", {
  skip_on_cran()

  tt <- gbif_oai_list_metadataformats()

  expect_is(tt, "data.frame")
  expect_is(tt$metadataPrefix, "character")
  expect_named(tt, c('metadataPrefix', 'schema', 'metadataNamespace'))
})

test_that("gbif_oai_list_sets", {
  skip_on_cran()

  tt <- gbif_oai_list_sets()

  expect_is(tt, "data.frame")
  expect_is(tt$setSpec, "character")
  expect_named(tt, c('setSpec', 'setName'))
})

test_that("gbif_oai_list_identifiers", {
  skip_on_cran()

  today <- format(Sys.Date(), "%Y-%m-%d")
  tt <- gbif_oai_list_identifiers(from = today)

  expect_is(tt, "data.frame")
  expect_is(tt$setSpec, "character")
})

test_that("gbif_oai_list_records", {
  skip_on_cran()

  today <- format(Sys.Date(), "%Y-%m-%d")
  tt <- gbif_oai_list_records(from = today)

  expect_is(tt, "data.frame")
  expect_is(tt$datestamp, "character")
  expect_is(tt$title, "character")
})


test_that("gbif_oai_get_records", {
  skip_on_cran()

  tt <- gbif_oai_get_records("9c4e36c1-d3f9-49ce-8ec1-8c434fa9e6eb")

  expect_is(tt, "data.frame")
  expect_is(tt$identifier, "character")
  expect_equal(tt$identifier, "9c4e36c1-d3f9-49ce-8ec1-8c434fa9e6eb")
  expect_is(tt$title, "character")
  expect_equal(tt$title, "Freshwater fishes of Serbia and Montenegro")
})
