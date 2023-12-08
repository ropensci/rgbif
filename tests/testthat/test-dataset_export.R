context("dataset_export")

skip_on_cran()

test_that("dataset_export works as expected", {
  total_ds <- dataset_search()$meta$count
  
  xx <- dataset_export(type = "METADATA")
  expect_equal(ncol(xx), 17)
  expect_lt(nrow(xx), total_ds)
  expect_equal(names(xx)[1], "dataset_key")
  expect_is(xx,"tbl_df")
  
  aa <- dataset_export(subtype = "TAXONOMIC_AUTHORITY")
  expect_equal(ncol(aa), 17)
  expect_lt(nrow(aa), total_ds)
  expect_equal(names(aa)[1], "dataset_key")
  expect_is(aa,"tbl_df")
  
  ll <- dataset_export(license = "CC0_1_0",subtype = "TAXONOMIC_AUTHORITY")
  expect_equal(ncol(ll), 17)
  expect_lt(nrow(ll), total_ds)
  expect_equal(names(ll)[1], "dataset_key")
  expect_is(ll,"tbl_df")
  
  # test multiple values for hostingOrg
  h <- dataset_export(hostingOrg = 
                         "4c415e40-1e21-11de-9e40-a0d6ecebb8bf")
  expect_equal(ncol(h), 17)
  expect_lt(nrow(h), total_ds)
  expect_equal(names(h)[1], "datasetKey")
  expect_is(h,"tbl_df")
  
  hh <- dataset_export(hostingOrg = 
    "4c415e40-1e21-11de-9e40-a0d6ecebb8bf;e2e717bf-551a-4917-bdc9-4fa0f342c530")
  expect_equal(ncol(hh), 17)
  expect_lt(nrow(hh), total_ds)
  expect_lt(nrow(h), nrow(hh))
  expect_equal(names(hh)[1], "datasetKey")
  expect_is(hh,"tbl_df")
  
  # test decade ranges and multiple values 
  d <- dataset_export(decade=1800)
  expect_equal(ncol(d), 17)
  expect_lt(nrow(d), total_ds)
  expect_equal(names(d)[1], "datasetKey")
  expect_is(d,"tbl_df")
  
  dd <- dataset_export(decade="1800;1890")
  expect_equal(ncol(dd), 17)
  expect_lt(nrow(dd), total_ds)
  expect_lt(nrow(d), nrow(dd))
  expect_equal(names(dd)[1], "datasetKey")
  expect_is(dd,"tbl_df")
  
  ddd <- dataset_export(decade="1800,1890")
  expect_equal(ncol(ddd), 17)
  expect_lt(nrow(ddd), total_ds)
  expect_lt(nrow(dd), nrow(ddd))
  expect_equal(names(ddd)[1], "datasetKey")
  expect_is(ddd,"tbl_df")
  
  n <- dataset_export(endorsingNodeKey="cdc9736d-5ff7-4ece-9959-3c744360cdb3")
  expect_equal(ncol(n), 17)
  expect_lt(nrow(n), total_ds)
  expect_lt(nrow(n), nrow(ddd))
  expect_equal(names(ddd)[1], "datasetKey")
  expect_is(ddd,"tbl_df")
  
  nn <- dataset_export(endorsingNodeKey=
      "cdc9736d-5ff7-4ece-9959-3c744360cdb3;d205def7-82c3-472a-be4b-31d11dcd51fd")
  expect_equal(ncol(nn), 17)
  expect_lt(nrow(nn), total_ds)
  expect_lt(nrow(n), nrow(nn))
  expect_equal(names(nn)[1], "datasetKey")
  expect_is(nn,"tbl_df")
  
  p <- dataset_export(projectId="BID-AF2020-140-REG")
  expect_equal(ncol(p), 17)
  expect_lt(nrow(p), total_ds)
  expect_equal(names(p)[1], "datasetKey")
  expect_is(p,"tbl_df")
  
  pp <- dataset_export(projectId="BID-AF2020-140-REG;GRIIS")
  expect_equal(ncol(pp), 17)
  expect_lt(nrow(pp), total_ds)
  expect_lt(nrow(p), nrow(pp))
  expect_equal(names(pp)[1], "datasetKey")
  expect_is(pp,"tbl_df")
  
  i <- dataset_export(doi="10.15468/aomfnb")
  expect_equal(ncol(i), 17)
  expect_lt(nrow(i), total_ds)
  expect_equal(names(i)[1], "datasetKey")
  expect_is(i,"tbl_df")
  
  ii <- dataset_export(doi="10.15468/aomfnb;10.15468/igasai")
  expect_equal(ncol(ii), 17)
  expect_lt(nrow(ii), total_ds)
  expect_lt(nrow(i), nrow(ii))
  expect_equal(names(ii)[1], "datasetKey")
  expect_is(ii,"tbl_df")
  
})
