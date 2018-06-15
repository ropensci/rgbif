context("name_usage")

test_that("name_usage return parameter works", {
  skip_on_cran()

  meta <- name_usage(return = "meta")
  dat <- name_usage(return = "data")
  all <- name_usage(return = "all")

  # meta
  expect_is(meta, "data.frame")
  expect_is(meta, "tbl_df")
  expect_named(meta, c('offset', 'limit', 'endOfRecords'))
  expect_equal(meta$limit, 100)

  # data
  expect_is(dat, "data.frame")
  expect_is(dat, "tbl_df")
  expect_true(any(grepl("datasetKey", names(dat))))
  expect_equal(NROW(dat), 100)

  # both meta and data
  expect_is(all, "list")
  expect_named(all, c('meta', 'data'))
  expect_is(all$meta, "data.frame")
  expect_is(all$meta, "tbl_df")
  expect_named(all$meta, c('offset', 'limit', 'endOfRecords'))
  expect_equal(all$meta$limit, 100)
  expect_is(all$data, "data.frame")
  expect_is(all$data, "tbl_df")
  expect_true(any(grepl("datasetKey", names(all$data))))
  expect_equal(NROW(all$data), 100)
})

test_that("name_usage works", {
  skip_on_cran()

  tt <- name_usage(key = 1)
  uu <- name_usage(key = 5231190, data = 'references')

  expect_is(tt, "list")
  expect_is(tt$data$key, "integer")
  expect_is(tt$data$kingdom, "character")

  expect_is(uu, "list")
  expect_is(uu$data, "data.frame")
  expect_is(uu$data$sourceTaxonKey, "integer")
  expect_is(uu$data$citation, "character")

  # name_usage returns the correct value
  expect_equal(tt$data$kingdom, "Animalia")

  # name_usage returns the correct dimensions
  expect_equal(length(tt), 2)
  expect_equal(NROW(tt$data), 1)

  expect_equal(length(uu), 2)
  expect_equal(NCOL(uu$meta), 3)
  expect_equal(NCOL(uu$data), 5)
})

test_that("name_usage name route works", {
  skip_on_cran()
  rte1 <- name_usage(key = 5231190, data = 'name')
  rte1a <- name_usage(key = 5127291, data = 'name')
  expect_is(rte1, "list")
  expect_is(rte1a, "list")
  expect_true(NROW(rte1$meta) == 0)
  expect_true(NROW(rte1a$meta) == 0)
  expect_is(rte1$data, "data.frame")
  expect_is(rte1a$data, "data.frame")
})

test_that("name_usage parents route works", {
  skip_on_cran()
  rte2 <- name_usage(key = 5231190, data = 'parents')
  rte2a <- name_usage(key = 5135783, data = 'parents')
  expect_is(rte2, "list")
  expect_is(rte2a, "list")
  expect_true(NROW(rte2$meta) == 0)
  expect_true(NROW(rte2a$meta) == 0)
  expect_is(rte2$data, "data.frame")
  expect_is(rte2a$data, "data.frame")
})

test_that("name_usage children route works", {
  skip_on_cran()
  rte3 <- name_usage(key = 5231190, data = 'children')
  rte3a <- name_usage(key = 5135790, data = 'children')
  expect_is(rte3, "list")
  expect_is(rte3a, "list")
  expect_is(rte3$meta, "data.frame")
  expect_is(rte3a$meta, "data.frame")
  expect_is(rte3$data, "data.frame")
  expect_is(rte3a$data, "data.frame")
})

test_that("name_usage related route works", {
  skip_on_cran()
  rte4 <- name_usage(key = 5231190, data = 'related')
  rte4a <- name_usage(key = 5135787, data = 'related')
  expect_is(rte4, "list")
  expect_is(rte4a, "list")
  expect_is(rte4$meta, "data.frame")
  expect_is(rte4a$meta, "data.frame")
  expect_is(rte4$data, "data.frame")
  expect_is(rte4a$data, "data.frame")
})

test_that("name_usage synonyms route works", {
  skip_on_cran()
  rte5 <- name_usage(key = 5231190, data = 'synonyms')
  rte5a <- name_usage(key = 5135790, data = 'synonyms')
  expect_is(rte5, "list")
  expect_is(rte5a, "list")
  expect_is(rte5$meta, "data.frame")
  expect_is(rte5a$meta, "data.frame")
  expect_equal(NROW(rte5$data), 1)
  expect_is(rte5a$data, "data.frame")
})

test_that("name_usage descriptions route works", {
  skip_on_cran()
  rte6 <- name_usage(key = 5231190, data = 'descriptions')
  rte6a <- name_usage(key = 5127299, data = 'descriptions')
  expect_is(rte6, "list")
  expect_is(rte6a, "list")
  expect_is(rte6$meta, "data.frame")
  expect_is(rte6a$meta, "data.frame")
  expect_is(rte6$data, "data.frame")
  expect_is(rte6a$data, "data.frame")
})

test_that("name_usage distributions route works", {
  skip_on_cran()
  rte7 <- name_usage(key = 5231190, data = 'distributions')
  rte7a <- name_usage(key = 5231190, data = 'distributions')
  expect_is(rte7, "list")
  expect_is(rte7a, "list")
  expect_is(rte7$meta, "data.frame")
  expect_is(rte7a$meta, "data.frame")
  expect_is(rte7$data, "data.frame")
  expect_is(rte7a$data, "data.frame")
})

test_that("name_usage media route works", {
  skip_on_cran()
  rte8 <- name_usage(key = 5231190, data = 'media')
  rte8a <- name_usage(key = 5231190, data = 'media')
  expect_is(rte8, "list")
  expect_is(rte8a, "list")
  expect_is(rte8$meta, "data.frame")
  expect_is(rte8a$meta, "data.frame")
  expect_is(rte8$data, "data.frame")
  expect_is(rte8a$data, "data.frame")
})

test_that("name_usage references route works", {
  skip_on_cran()
  rte9 <- name_usage(key = 5231190, data = 'references')
  rte9a <- name_usage(key = 5231190, data = 'references')
  expect_is(rte9, "list")
  expect_is(rte9a, "list")
  expect_is(rte9$meta, "data.frame")
  expect_is(rte9a$meta, "data.frame")
  expect_is(rte9$data, "data.frame")
  expect_is(rte9a$data, "data.frame")
})

test_that("name_usage speciesProfiles route works", {
  skip_on_cran()
  rte10 <- name_usage(key = 5231190, data = 'speciesProfiles')
  rte10a <- name_usage(key = 5136020, data = 'speciesProfiles')
  expect_is(rte10, "list")
  expect_is(rte10a, "list")
  expect_is(rte10$meta, "data.frame")
  expect_is(rte10a$meta, "data.frame")
  expect_is(rte10$data, "data.frame")
  expect_is(rte10a$data, "data.frame")
})

test_that("name_usage vernacularNames route works", {
  skip_on_cran()
  rte11 <- name_usage(key = 5231190, data = 'vernacularNames')
  rte11a <- name_usage(key = 5136034, data = 'vernacularNames')
  expect_is(rte11, "list")
  expect_is(rte11a, "list")
  expect_is(rte11$meta, "data.frame")
  expect_is(rte11a$meta, "data.frame")
  expect_is(rte11$data, "data.frame")
  expect_is(rte11a$data, "data.frame")
})

test_that("name_usage typeSpecimens route works", {
  skip_on_cran()
  rte12 <- name_usage(key = 5231190, data = 'typeSpecimens')
  rte12a <- name_usage(key = 5097652, data = 'typeSpecimens')
  expect_is(rte12, "list")
  expect_is(rte12a, "list")
  expect_is(rte12$meta, "data.frame")
  expect_is(rte12a$meta, "data.frame")
  expect_equal(NROW(rte12$data), 0)
  # this used to be up, seems to be down now, comment on 2015-12-04
  expect_equal(NROW(rte12a$data), 0)
})

test_that("name_usage fails correctly", {
  skip_on_cran()
  ### verbatim not working right now for some unknown reason
  expect_error(name_usage(key = 3119195, data = 'verbatim'))
  # Select many options, doesn't work
  expect_error(name_usage(key = 3119195, data = c('media', 'synonyms')))
})


# fails with more than 1 value
test_that("fails with more than 1", {
  skip_on_cran()

  keys <- c("73605f3a-af85-4ade-bbc5-522bfb90d847",
    "d7c60346-44b6-400d-ba27-8d3fbeffc8a5")
  expect_error(name_usage(datasetKey = keys),
    "length\\(datasetKey\\) == 1 is not TRUE")

  expect_error(name_usage(language = c('spanish', 'german')),
    "length\\(language\\) == 1 is not TRUE")

  expect_error(name_usage(name = c('Quercus', 'Puma')),
    "length\\(name\\) == 1 is not TRUE")

  expect_error(name_usage(rank = c('GENUS', 'SPECIES')),
    "length\\(rank\\) == 1 is not TRUE")
})


# paging
# Commented:it takes too much time.
# Uncomment after introducing test caching with vcr package)
# test_that("paging: class data and meta not modified by paging", {
#   skip_on_cran()
#
#   bb1 <- name_usage(datasetKey = "9ff7d317-609b-4c08-bd86-3bc404b77c42",
#                    limit = 1)
#   bb2 <- name_usage(datasetKey = "9ff7d317-609b-4c08-bd86-3bc404b77c42",
#                     limit = 1789)
#   expect_true(all(class(bb1) == class(bb2)))
#   expect_true(all(class(bb1$meta) == class(bb2$meta)))
#   expect_true(all(class(bb1$data) == class(bb2$data)))
# })
#
# test_that("paging: name_usage returns all records from dataset: limit > n_records", {
#   skip_on_cran()
#
#   cc <- name_usage(datasetKey = "9ff7d317-609b-4c08-bd86-3bc404b77c42",
#                  limit = 5000)
#   expect_equal(cc$meta$offset, 2000)
#   expect_lt(cc$meta$limit, 1000)
#   expect_gt(nrow(cc$data), 2000)
# })
#
# test_that("paging: name_usage returns as many records as asked via limit", {
#   skip_on_cran()
#
#   dd <- name_usage(datasetKey = "9ff7d317-609b-4c08-bd86-3bc404b77c42",
#                    limit = 1329)
#   expect_equal(dd$meta$offset, 1000)
#   expect_equal(dd$meta$limit, 329)
#   expect_equal(nrow(dd$data), 1329)
#
#   ee <- name_usage(datasetKey = "9ff7d317-609b-4c08-bd86-3bc404b77c42",
#                    limit = 1001)
#   expect_equal(ee$meta$offset, 1000)
#   expect_equal(ee$meta$limit, 1)
#   expect_equal(nrow(ee$data), 1001)
# })
