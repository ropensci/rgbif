context("oai")

test_that("gbif_oai_identify", {
  vcr::use_cassette("gbif_oai_identify", {
    tt <- gbif_oai_identify()
  })

  expect_is(tt, "list")
  expect_is(tt$repositoryName, "character")
  expect_equal(tt$repositoryName, "GBIF Registry")
})

test_that("gbif_oai_list_metadataformats", {
  vcr::use_cassette("gbif_oai_list_metadataformats", {
    tt <- gbif_oai_list_metadataformats()
  })

  expect_is(tt, "data.frame")
  expect_is(tt$metadataPrefix, "character")
  expect_named(tt, c('metadataPrefix', 'schema', 'metadataNamespace'))
})

test_that("gbif_oai_list_sets", {
  vcr::use_cassette("gbif_oai_list_sets", {
    tt <- gbif_oai_list_sets()
  })

  expect_is(tt, "data.frame")
  expect_is(tt$setSpec, "character")
  expect_named(tt, c('setSpec', 'setName'))
})

# comment out - always seems to fail for some reason
test_that("gbif_oai_list_identifiers", {
  vcr::use_cassette("gbif_oai_list_identifiers", {
    # today <- format(Sys.Date() - 100, "%Y-%m-%d")
    tt <- gbif_oai_list_identifiers(from = "2017-01-15", until = "2017-01-30")
  })

  expect_is(tt, "data.frame")
  expect_is(tt$setSpec, "character")
})

# test_that("gbif_oai_list_records", {
#   skip_on_cran()
#   vcr::use_cassette("gbif_oai_list_records", {
#     today <- format(Sys.Date(), "%Y-%m-%d")
#     tt <- gbif_oai_list_records(from = today)
    
#     expect_is(tt, "data.frame")
#     expect_is(tt$datestamp, "character")
#     expect_is(tt$title, "character")
#   })
# })


test_that("gbif_oai_get_records", {
  vcr::use_cassette("gbif_oai_get_records", {
    tt <- gbif_oai_get_records("9c4e36c1-d3f9-49ce-8ec1-8c434fa9e6eb")
  })

  expect_is(tt, "list")
  expect_is(tt[[1]], "list")
  expect_is(tt[[1]]$header, "data.frame")
  expect_is(tt[[1]]$metadata, "data.frame")
  expect_equal(length(tt), 1)
  expect_is(tt[[1]]$header$identifier, "character")
  expect_equal(tt[[1]]$header$identifier, "9c4e36c1-d3f9-49ce-8ec1-8c434fa9e6eb")
  expect_is(tt[[1]]$metadata$title, "character")
  expect_equal(tt[[1]]$metadata$title, "Freshwater fishes of Serbia and Montenegro")
})
