# context("networks")
# 
# tt <- networks()
# uu <- networks(uuid='16ab5405-6c94-4189-ac71-16ca3b753df7')
# vv <- networks(data='endpoint', uuid='16ab5405-6c94-4189-ac71-16ca3b753df7')
# 
# test_that("returns the correct class", {
#   expect_is(tt, "list")
#   expect_is(tt$limit, "numeric")
#   expect_is(tt$endOfRecords, "logical")
#   
#   expect_is(uu, "list")
#   expect_is(uu$country, "character")
# })
# 
# test_that("returns the correct value", {
#   expect_identical(tt$results[[1]]$tags, list())
#   expect_equal(uu$title, "Dryad")
#   expect_equal(vv[[1]]$key, 15428)
#   expect_equal(vv[[1]]$modifiedBy, "registry-migration.gbif.org")
# })
# 
# test_that("returns the correct dimensions", {
#   expect_equal(length(tt), 5)
#   expect_equal(length(tt$results), 13)
#   expect_equal(length(vv), 1)
#   expect_equal(length(vv[[1]]), 9)
# })