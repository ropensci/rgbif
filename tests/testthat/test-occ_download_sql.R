
test_that("occ_download_sql : real requests work", {
  skip_on_cran()
  skip_on_ci()
  
  vcr::use_cassette("occ_download_sql_1", {
    qqq <- occ_download_sql("SELECT gbifid,countryCode FROM occurrence WHERE genusKey = 2435098")
  }, match_requests_on = c("method", "uri", "body"))
  expect_is(qqq, "occ_download_sql")
  expect_equal(attr(qqq, "status"), "PREPARING")
  expect_equal(attr(qqq, "format"), "SQL_TSV_ZIP")

})

test_that("occ_download_sql : fails well", {
  skip_on_cran()
  skip_on_ci()

  expect_error(occ_download_sql("dog"))
  expect_error(occ_download_sql("SELECT * FROM occurrence"))
  expect_error(occ_download_sql("SELECT dog FROM occurrence"))
})







