context("occ_download_queue")

# FIXME: bring back when using vcr
# test_that("returns the correct class", {
#   skip_on_cran()
#   skip_on_travis()
  
#   tt <- occ_download_queue(
#     occ_download("country = NZ", "year = 1999", "month = 3"),
#     occ_download("catalogNumber = Bird.27847588", "year = 1998", "month = 2"),
#     occ_download("taxonKey = 2435240", "year = 1991"),
#     occ_download("taxonKey = 2435240", "year = 1992")
#   )

#   expect_is(tt, "list")
#   for (i in tt) expect_is(i, "occ_download")
#   for (i in tt) expect_is(unclass(i), "character")
#   for (i in tt) expect_equal(attr(i, "user"), "sckott")
#   for (i in tt) expect_equal(attr(i, "email"), "myrmecocystus@gmail.com")

#   # all succeeded
#   for (i in tt) expect_equal(occ_download_meta(i)$status, "SUCCEEDED")  
# })

test_that("occ_download_queue fails well", {
  skip_on_cran()
  
  expect_error(occ_download_queue(), "no requests submitted")
})
