context("dataset_export")

skip_on_cran()
skip_on_ci()

test_that("dataset_export works as expected", {
  total_ds <- dataset_search()$meta$count
  
  xx <- dataset_export(type = "METADATA")
  expect_equal(ncol(xx), 17)
  expect_lt(nrow(xx), total_ds)
  expect_equal(names(xx)[1], "datasetKey")
  expect_is(xx,"tbl_df")
  
  aa <- dataset_export(subtype = "TAXONOMIC_AUTHORITY")
  expect_equal(ncol(aa), 17)
  expect_lt(nrow(aa), total_ds)
  expect_equal(names(aa)[1], "datasetKey")
  expect_is(aa,"tbl_df")
  
  ll <- dataset_export(license = "CC0_1_0",subtype = "TAXONOMIC_AUTHORITY")
  expect_equal(ncol(ll), 17)
  expect_lt(nrow(ll), total_ds)
  expect_equal(names(ll)[1], "datasetKey")
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
  
  cat_r <- dataset_export(category = "eDNA")
  expect_equal(ncol(cat_r), 17)
  expect_lt(nrow(cat_r), total_ds)
  expect_equal(names(cat_r)[1], "datasetKey")
  expect_is(cat_r,"tbl_df")
  
  cont_r <- dataset_export(continent = "EUROPE")
  expect_equal(ncol(cont_r), 17)
  expect_lt(nrow(cont_r), total_ds)
  expect_equal(names(cont_r)[1], "datasetKey")
  expect_is(cont_r,"tbl_df")
  
  tk_r <- dataset_export(taxonKey = 212)
  expect_equal(ncol(tk_r), 17)
  expect_lt(nrow(tk_r), total_ds)
  expect_equal(names(tk_r)[1], "datasetKey")
  expect_is(tk_r,"tbl_df")
  
  rc_r <- dataset_export(recordCount = "10000,100000")
  expect_equal(ncol(rc_r), 17)
  expect_lt(nrow(rc_r), total_ds)
  expect_equal(names(rc_r)[1], "datasetKey")
  expect_is(rc_r,"tbl_df")
  
  md_r <- dataset_export(modifiedDate = "2020-01-01,2021-01-01")
  expect_equal(ncol(md_r), 17)
  expect_lt(nrow(md_r), total_ds)
  expect_equal(names(md_r)[1], "datasetKey")
  expect_is(md_r,"tbl_df")
  
  cd_r <- dataset_export(createdDate = "2015-01-01,2016-01-01")
  expect_equal(ncol(cd_r), 17)
  expect_lt(nrow(cd_r), total_ds)
  expect_equal(names(cd_r)[1], "datasetKey")
  expect_is(cd_r,"tbl_df")
  
  ik_r <- dataset_export(installationKey = "d209e552-7e6e-4840-b13c-c0596ef36e55")
  expect_equal(ncol(ik_r), 17)
  expect_lt(nrow(ik_r), total_ds)
  expect_equal(names(ik_r)[1], "datasetKey")
  expect_is(ik_r,"tbl_df")
  
  et_r <- dataset_export(endpointType = "DWC_ARCHIVE")
  expect_equal(ncol(et_r), 17)
  expect_lt(nrow(et_r), total_ds)
  expect_equal(names(et_r)[1], "datasetKey")
  expect_is(et_r,"tbl_df")
  
  cu_r <- dataset_export(contactUserId = 123)
  expect_equal(ncol(cu_r), 17)
  expect_equal(names(cu_r)[1], "datasetKey")
  expect_is(cu_r,"tbl_df")
  
  ce_r <- dataset_export(contactEmail = "helpdesk@gbif.org")
  expect_equal(ncol(ce_r), 17)
  expect_equal(names(ce_r)[1], "datasetKey")
  expect_is(ce_r,"tbl_df")
  
})
