context("dataset_search")

test_that("dataset_search works as expected", {
  vcr::use_cassette("dataset_search", {
    total_ds <- dataset_search(limit=0)$meta$count
  
    t <- dataset_search(type = "OCCURRENCE",limit=5)
    tt <- dataset_search(type = "OCCURRENCE;CHECKLIST",limit=5)
    
    expect_is(t, "list")
    expect_named(t, c('meta', 'data', 'facets'))
    expect_is(t$data, "tbl_df")
    expect_is(t$data$title, "character")
    expect_lt(t$meta$count,total_ds)
    expect_lte(nrow(t$data),5)
    
    expect_is(tt, "list")
    expect_named(tt, c('meta', 'data', 'facets'))
    expect_is(tt$data, "tbl_df")
    expect_is(tt$data$title, "character")
    expect_lt(tt$meta$count,total_ds)
    expect_lt(t$meta$count,tt$meta$count)
    expect_lte(nrow(tt$data),5)
    expect_true(all(tt$data$type == "OCCURRENCE" |
                      tt$data$type == "CHECKLIST"))
    
    k <- dataset_search(keyword = "bird",limit=5)
    kk <- dataset_search(keyword = "bird;insect",limit=5)
    
    expect_is(k, "list")
    expect_is(k$data, "tbl_df")
    expect_is(k$data$title, "character")
    expect_lt(k$meta$count,total_ds)
    
    expect_is(kk, "list")
    expect_is(kk$data, "tbl_df")
    expect_is(kk$data$title, "character")
    expect_lt(kk$meta$count,total_ds)
    expect_lt(k$meta$count,kk$meta$count)
    
    s <- dataset_search(subtype = "TAXONOMIC_AUTHORITY",limit=5)
    ss <- dataset_search(subtype = "TAXONOMIC_AUTHORITY;GLOBAL_SPECIES_DATASET",
                         limit=5)
    
    expect_is(s, "list")
    expect_is(s$data, "tbl_df")
    expect_is(s$data$title, "character")
    expect_lte(s$meta$count,total_ds)
    expect_lte(nrow(s$data),5)
    
    expect_is(ss, "list")
    expect_is(ss$data, "tbl_df")
    expect_is(ss$data$title, "character")
    expect_lt(ss$meta$count,total_ds)
    expect_lte(s$meta$count,ss$meta$count)
    expect_lte(nrow(ss$data),5)
    expect_true(all(ss$data$subType == "TAXONOMIC_AUTHORITY" |
                      ss$data$subType == "GLOBAL_SPECIES_DATASET"))
    
    l <- dataset_search(license = "CC0_1_0",limit=5)
    ll <- dataset_search(license = "CC0_1_0;CC_BY_4_0",limit=5)
    
    expect_is(l, "list")
    expect_is(l$data, "tbl_df")
    expect_is(l$data$title, "character")
    expect_lte(l$meta$count,total_ds)
    expect_lte(nrow(l$data),5)
    
    expect_is(ll, "list")
    expect_is(ll$data, "tbl_df")
    expect_is(ll$data$title, "character")
    expect_lt(ll$meta$count,total_ds)
    expect_lt(l$meta$count,ll$meta$count)
    expect_lte(nrow(ll$data),5)

    q <- dataset_search(query = "frog",limit=5)
    
    expect_is(q, "list")
    expect_is(q$data, "tbl_df")
    expect_is(q$data$title, "character")
    expect_lte(q$meta$count,total_ds)
    expect_lte(nrow(q$data),5)
  
    p <- dataset_search(publishingCountry = "UA",limit=5)
    pp <- dataset_search(publishingCountry = "UA;US",limit=5)
    
    expect_is(p, "list")
    expect_is(p$data, "tbl_df")
    expect_is(p$data$title, "character")
    expect_lte(p$meta$count,total_ds)
    expect_lte(nrow(p$data),5)
    expect_true(all(p$data$publishingCountry == "UA"))
    
    expect_is(pp, "list")
    expect_is(pp$data, "tbl_df")
    expect_is(pp$data$title, "character")
    expect_lt(pp$meta$count,total_ds)
    expect_lt(p$meta$count,pp$meta$count)
    expect_lte(nrow(pp$data),5)
    expect_true(all(pp$data$publishingCountry == "UA" | 
                  pp$data$publishingCountry == "US"))
    
    b <- dataset_search(subtype="TAXONOMIC_AUTHORITY",limit=5)
    bb <- dataset_search(subtype="TAXONOMIC_AUTHORITY;OBSERVATION",limit=5)
    
    expect_is(b, "list")
    expect_is(b$data, "tbl_df")
    expect_is(b$data$title, "character")
    expect_lte(b$meta$count,total_ds)
    expect_lte(nrow(b$data),5)
    expect_true(all(b$data$subType == "TAXONOMIC_AUTHORITY"))
    
    expect_is(bb, "list")
    expect_is(bb$data, "tbl_df")
    expect_is(bb$data$title, "character")
    expect_lt(bb$meta$count,total_ds)
    expect_lt(b$meta$count,bb$meta$count)
    expect_lte(nrow(bb$data),5)
    expect_true(all(bb$data$subType == "TAXONOMIC_AUTHORITY" | 
                      bb$data$subType == "OBSERVATION"))
    
    
    o <- dataset_search(publishingOrg = "e2e717bf-551a-4917-bdc9-4fa0f342c530",
                   limit=5)
    oo <- dataset_search(publishingOrg = 
          "e2e717bf-551a-4917-bdc9-4fa0f342c530;28eb1a3f-1c15-4a95-931a-4af90ecb574d",limit=5)
    
    expect_is(o, "list")
    expect_is(o$data, "tbl_df")
    expect_is(o$data$title, "character")
    expect_lte(o$meta$count,total_ds)
    expect_lte(nrow(o$data),5)
    expect_true(all(o$data$publishingOrganizationKey == "e2e717bf-551a-4917-bdc9-4fa0f342c530"))
    
    expect_is(oo, "list")
    expect_is(oo$data, "tbl_df")
    expect_is(oo$data$title, "character")
    expect_lt(oo$meta$count,total_ds)
    expect_lt(o$meta$count,oo$meta$count)
    expect_lte(nrow(oo$data),5)
    expect_true(all(oo$data$publishingOrganizationKey == "e2e717bf-551a-4917-bdc9-4fa0f342c530" | 
                      oo$data$publishingOrganizationKey == "28eb1a3f-1c15-4a95-931a-4af90ecb574d"))
    
    
    h <- dataset_search(hostingOrg = "7ce8aef0-9e92-11dc-8738-b8a03c50a862",
                        limit=5)
    hh <- dataset_search(hostingOrg = 
                        "7ce8aef0-9e92-11dc-8738-b8a03c50a862;fbca90e3-8aed-48b1-84e3-369afbd000ce",
                        limit=5)
    
    expect_is(h, "list")
    expect_is(h$data, "tbl_df")
    expect_is(h$data$title, "character")
    expect_lte(h$meta$count,total_ds)
    expect_lte(nrow(h$data),5)
    expect_true(all(h$data$hostingOrganizationKey == "7ce8aef0-9e92-11dc-8738-b8a03c50a862"))
    
    expect_is(hh, "list")
    expect_is(hh$data, "tbl_df")
    expect_is(hh$data$title, "character")
    expect_lt(hh$meta$count,total_ds)
    expect_lt(h$meta$count,hh$meta$count)
    expect_lte(nrow(hh$data),5)
    expect_true(all(hh$data$hostingOrganizationKey == "7ce8aef0-9e92-11dc-8738-b8a03c50a862" | 
                      hh$data$hostingOrganizationKey == "fbca90e3-8aed-48b1-84e3-369afbd000ce"))
    
    
    n <- dataset_search(endorsingNodeKey = "d205def7-82c3-472a-be4b-31d11dcd51fd",
                        limit=5)
    nn <- dataset_search(endorsingNodeKey = 
                           "d205def7-82c3-472a-be4b-31d11dcd51fd;efb9c00e-f802-45dd-8826-a52ec45b89ff",
                         limit=5)
    
    expect_is(n, "list")
    expect_is(n$data, "tbl_df")
    expect_is(n$data$title, "character")
    expect_lte(n$meta$count,total_ds)
    expect_lte(nrow(n$data),5)
    expect_true(all(n$data$endorsingNodeKey == "d205def7-82c3-472a-be4b-31d11dcd51fd"))
    
    expect_is(nn, "list")
    expect_is(nn$data, "tbl_df")
    expect_is(nn$data$title, "character")
    expect_lt(nn$meta$count,total_ds)
    expect_lt(n$meta$count,nn$meta$count)
    expect_lte(nrow(nn$data),5)
    expect_true(all(nn$data$endorsingNodeKey == "d205def7-82c3-472a-be4b-31d11dcd51fd" | 
                      nn$data$endorsingNodeKey == "efb9c00e-f802-45dd-8826-a52ec45b89ff"))
    
    
    d <- dataset_search(decade=1890,limit=5)
    dd <- dataset_search(decade="1890;1990",limit=5)
    ddd <- dataset_search(decade="1890,1990",limit=5)
    
    expect_is(d, "list")
    expect_is(d$data, "tbl_df")
    expect_is(d$data$title, "character")
    expect_lte(d$meta$count,total_ds)
    expect_lte(nrow(d$data),5)
    
    expect_is(dd, "list")
    expect_is(dd$data, "tbl_df")
    expect_is(dd$data$title, "character")
    expect_lte(dd$meta$count,total_ds)
    expect_lte(d$meta$count,dd$meta$count)
    expect_lte(nrow(dd$data),5)
    
    expect_is(ddd, "list")
    expect_is(ddd$data, "tbl_df")
    expect_is(ddd$data$title, "character")
    expect_lte(ddd$meta$count,total_ds)
    expect_lte(dd$meta$count,ddd$meta$count)
    expect_lte(nrow(ddd$data),5)
    
    p <- dataset_search(projectId = "GRIIS", limit=5)
    pp <- dataset_search(projectId = "GRIIS;BID-AF2020-140-REG", limit=5)
    
    expect_is(p, "list")
    expect_is(p$data, "tbl_df")
    expect_is(p$data$title, "character")
    expect_lte(p$meta$count,total_ds)
    expect_lte(nrow(p$data),5)
    expect_true(all(p$data$projectIdentifier == "GRIIS"))
    
    expect_is(pp, "list")
    expect_is(pp$data, "tbl_df")
    expect_is(pp$data$title, "character")
    expect_lt(pp$meta$count,total_ds)
    expect_lt(p$meta$count,pp$meta$count)
    expect_lte(nrow(pp$data),5)
    expect_true(all(pp$data$projectIdentifier == "GRIIS" | 
                      pp$data$projectIdentifier == "BID-AF2020-140-REG"))
    
    
    c <- dataset_search(hostingCountry = "NO", limit=5)
    cc <- dataset_search(hostingCountry = "NO;SE", limit=5)
    
    expect_is(c, "list")
    expect_is(c$data, "tbl_df")
    expect_is(c$data$title, "character")
    expect_lte(c$meta$count,total_ds)
    expect_lte(nrow(c$data),5)
    expect_true(all(c$data$hostingCountry == "NO"))
    
    expect_is(cc, "list")
    expect_is(cc$data, "tbl_df")
    expect_is(cc$data$title, "character")
    expect_lt(cc$meta$count,total_ds)
    expect_lt(c$meta$count,cc$meta$count)
    expect_lte(nrow(cc$data),5)
    expect_true(all(cc$data$hostingCountry == "NO" | 
                      cc$data$hostingCountry == "SE"))
    
    
    y <- dataset_search(networkKey = "99d66b6c-9087-452f-a9d4-f15f2c2d0e7e",limit=5)
    yy <- dataset_search(networkKey = 
                        "99d66b6c-9087-452f-a9d4-f15f2c2d0e7e;2b7c7b4f-4d4f-40d3-94de-c28b6fa054a6",
                        limit=5)
    
    expect_is(y, "list")
    expect_is(y$data, "tbl_df")
    expect_is(y$data$title, "character")
    expect_lte(y$meta$count,total_ds)
    expect_lte(nrow(y$data),5)
    expect_true(all(grepl("99d66b6c-9087-452f-a9d4-f15f2c2d0e7e",y$data$networkKeys)))
    
    expect_is(yy, "list")
    expect_is(yy$data, "tbl_df")
    expect_is(yy$data$title, "character")
    expect_lt(yy$meta$count,total_ds)
    expect_lte(y$meta$count,yy$meta$count)
    expect_lte(nrow(yy$data),5)
    expect_true(all(grepl(
      "99d66b6c-9087-452f-a9d4-f15f2c2d0e7e|2b7c7b4f-4d4f-40d3-94de-c28b6fa054a6",
                          yy$data$networkKeys)))
    
    i <- dataset_search(doi="10.15468/aomfnb",limit=5)
    ii <- dataset_search(doi="10.15468/aomfnb;10.15468/igasai")
    
    expect_is(i, "list")
    expect_is(i$data, "tbl_df")
    expect_is(i$data$title, "character")
    expect_lte(i$meta$count,total_ds)
    expect_lte(nrow(i$data),5)
    expect_true(all(i$data$doi=="10.15468/aomfnb"))

    expect_is(ii, "list")
    expect_is(ii$data, "tbl_df")
    expect_is(ii$data$title, "character")
    expect_lt(ii$meta$count,total_ds)
    expect_lte(i$meta$count,ii$meta$count)
    expect_lte(nrow(ii$data),5)
    expect_true(all(ii$data$doi=="10.15468/aomfnb"| 
                    ii$data$doi=="10.15468/igasai"))
    
    
    iii <- dataset_search(installationKey = "998fa743-e3d2-41bd-8cd3-754e22581224",limit=5)
    
    expect_is(iii, "list")
    expect_is(iii$data, "tbl_df")
    expect_is(iii$data$title, "character")
    expect_equal(iii$data$publishingOrganizationTitle[1], "University of Minnesota Bell Museum")
    expect_equal(nrow(iii$data), 5)
    
    }, preserve_exact_body_bytes = TRUE)

})

test_that("dataset_search facets work as expected", {
  vcr::use_cassette("dataset_search_facet", {
  
  d <- dataset_search(facet="doi",limit=0,facetLimit=5)
  expect_is(d, "list")
  expect_named(d, c('meta', 'data', 'facets'))
  expect_is(d$facets$doi,"data.frame")
  expect_equal(colnames(d$facets$doi),c("name","count"))
  expect_lte(nrow(d$facets$doi),5)
  
  t <- dataset_search(facet="type",limit=0,facetLimit=5)
  expect_is(t, "list")
  expect_named(t, c('meta', 'data', 'facets'))
  expect_is(t$facets$type,"data.frame")
  expect_equal(colnames(t$facets$type),c("name","count"))
  expect_lte(nrow(t$facets$type),5)
  
  p <- dataset_search(facet="publishingCountry",limit=0,facetLimit=5)
  expect_is(p, "list")
  expect_named(p, c('meta', 'data', 'facets'))
  expect_is(p$facets$publishingCountry,"data.frame")
  expect_equal(colnames(p$facets$publishingCountry),c("name","count"))
  expect_lte(nrow(p$facets$publishingCountry),5)
  
  m <- dataset_search(facet="license",limit=0,facetLimit=5, facetMincount=10000)
  expect_is(m, "list")
  expect_named(m, c('meta', 'data', 'facets'))
  expect_is(m$facets$license,"data.frame")
  expect_equal(colnames(m$facets$license),c("name","count"))
  expect_lte(nrow(m$facets$license),5)
  expect_true(all(m$facets$license$count >= 10000))
  }, preserve_exact_body_bytes = TRUE)
  
  })
  

