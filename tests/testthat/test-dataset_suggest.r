context("dataset_suggest")

test_that("dataset_suggest works as expected", {
  vcr::use_cassette("dataset_suggest", {

    t <- dataset_suggest(type = "OCCURRENCE",limit=5)
    tt <- dataset_suggest(type = "OCCURRENCE;CHECKLIST",limit=5)
    
    expect_named(t, c('key', 'type', 'title'))
    
    expect_is(t, "tbl_df")
    expect_is(t$title, "character")
    expect_lte(nrow(t),5)

    expect_named(tt, c('key', 'type', 'title'))
    expect_is(tt, "tbl_df")
    expect_is(tt$title, "character")
    expect_lte(nrow(tt),5)
    expect_true(all(tt$type == "OCCURRENCE" |
                      tt$type == "CHECKLIST"))

    k <- dataset_suggest(keyword = "bird",limit=5)
    kk <- dataset_suggest(keyword = "bird;insect",limit=5)

    expect_is(k, "tbl_df")
    expect_is(k$title, "character")

    expect_is(kk, "tbl_df")
    expect_is(kk$title, "character")

    s <- dataset_suggest(subtype = "TAXONOMIC_AUTHORITY",limit=5)
    ss <- dataset_suggest(subtype = "TAXONOMIC_AUTHORITY;GLOBAL_SPECIES_DATASET",
                         limit=5)
    
    expect_named(s, c('key', 'type', 'title'))
    expect_is(s, "tbl_df")
    expect_is(s$title, "character")
    expect_lte(nrow(s),5)
    
    expect_named(ss, c('key', 'type', 'title'))
    expect_is(ss, "tbl_df")
    expect_is(ss$title, "character")
    expect_lte(nrow(ss),5)

    l <- dataset_suggest(license = "CC0_1_0",limit=5)
    ll <- dataset_suggest(license = "CC0_1_0;CC_BY_4_0",limit=5)
    
    expect_named(l, c('key', 'type', 'title'))
    expect_is(l, "tbl_df")
    expect_is(l$title, "character")
    expect_lte(nrow(l),5)

    expect_is(ll, "tbl_df")
    expect_is(ll$title, "character")
    expect_lte(nrow(ll),5)

    q <- dataset_suggest(query = "frog",limit=5)
    
    expect_named(s, c('key', 'type', 'title'))
    expect_is(q, "tbl_df")
    expect_is(q$title, "character")
    expect_lte(nrow(q),5)

    p <- dataset_suggest(publishingCountry = "UA",limit=5)
    pp <- dataset_suggest(publishingCountry = "UA;US",limit=5)
    
    expect_named(p, c('key', 'type', 'title'))
    expect_is(p, "tbl_df")
    expect_is(p$title, "character")
    expect_lte(nrow(p),5)

    expect_named(pp, c('key', 'type', 'title'))
    expect_is(pp, "tbl_df")
    expect_is(pp$title, "character")
    expect_lte(nrow(pp),5)

    b <- dataset_suggest(subtype="TAXONOMIC_AUTHORITY",limit=5)
    bb <- dataset_suggest(subtype="TAXONOMIC_AUTHORITY;OBSERVATION",limit=5)
        
    expect_named(b, c('key', 'type', 'title'))
    expect_is(b, "tbl_df")
    expect_is(b$title, "character")
    expect_lte(nrow(b),5)
    
    expect_named(bb, c('key', 'type', 'title'))
    expect_is(bb, "tbl_df")
    expect_is(bb$title, "character")
    expect_lte(nrow(bb),5)
    
    o <- dataset_suggest(publishingOrg = "e2e717bf-551a-4917-bdc9-4fa0f342c530",
                        limit=5)
    oo <- dataset_suggest(publishingOrg =
                           "e2e717bf-551a-4917-bdc9-4fa0f342c530;28eb1a3f-1c15-4a95-931a-4af90ecb574d",limit=5)
    
    expect_named(o, c('key', 'type', 'title'))
    expect_is(o, "tbl_df")
    expect_is(o$title, "character")
    expect_lte(nrow(o),5)

    expect_named(oo, c('key', 'type', 'title'))
    expect_is(oo, "tbl_df")
    expect_is(oo$title, "character")
    expect_lte(nrow(oo),5)
    
     
    h <- dataset_suggest(hostingOrg = "7ce8aef0-9e92-11dc-8738-b8a03c50a862",
                        limit=5)
    hh <- dataset_suggest(hostingOrg =
                           "7ce8aef0-9e92-11dc-8738-b8a03c50a862;fbca90e3-8aed-48b1-84e3-369afbd000ce",
                         limit=5)
    
    expect_named(h, c('key', 'type', 'title'))
    expect_is(h, "tbl_df")
    expect_is(h$title, "character")
    expect_lte(nrow(h),5)
    
    expect_named(hh, c('key', 'type', 'title'))
    expect_is(hh, "tbl_df")
    expect_is(hh$title, "character")
    expect_lte(nrow(hh),5)

    n <- dataset_suggest(endorsingNodeKey = "d205def7-82c3-472a-be4b-31d11dcd51fd",
                        limit=5)
    nn <- dataset_suggest(endorsingNodeKey =
                           "d205def7-82c3-472a-be4b-31d11dcd51fd;efb9c00e-f802-45dd-8826-a52ec45b89ff",
                         limit=5)

    expect_named(n, c('key', 'type', 'title'))
    expect_is(n, "tbl_df")
    expect_is(n$title, "character")
    expect_lte(nrow(n),5)
    
    expect_named(nn, c('key', 'type', 'title'))
    expect_is(nn, "tbl_df")
    expect_is(nn$title, "character")
    expect_lte(nrow(nn),5)
    
    d <- dataset_suggest(decade=1890,limit=5)
    dd <- dataset_suggest(decade="1890;1990",limit=5)
    ddd <- dataset_suggest(decade="1890,1990",limit=5)
    
    expect_named(d, c('key', 'type', 'title'))
    expect_is(d, "tbl_df")
    expect_is(d$title, "character")
    expect_lte(nrow(d),5)
    
    expect_named(dd, c('key', 'type', 'title'))
    expect_is(dd, "tbl_df")
    expect_is(dd$title, "character")
    expect_lte(nrow(dd),5)
    
    expect_named(ddd, c('key', 'type', 'title'))
    expect_is(ddd, "tbl_df")
    expect_is(ddd$title, "character")
    expect_lte(nrow(ddd),5)

    p <- dataset_suggest(projectId = "GRIIS", limit=5)
    pp <- dataset_suggest(projectId = "GRIIS;BID-AF2020-140-REG", limit=5)
    
    expect_named(p, c('key', 'type', 'title'))
    expect_is(p, "tbl_df")
    expect_is(p$title, "character")
    expect_lte(nrow(p),5)
    
    expect_named(pp, c('key', 'type', 'title'))
    expect_is(pp, "tbl_df")
    expect_is(pp$title, "character")
    expect_lte(nrow(pp),5)

    c <- dataset_suggest(hostingCountry = "NO", limit=5)
    cc <- dataset_suggest(hostingCountry = "NO;SE", limit=5)

    expect_named(c, c('key', 'type', 'title'))
    expect_is(c, "tbl_df")
    expect_is(c$title, "character")
    expect_lte(nrow(c),5)
    
    expect_named(cc, c('key', 'type', 'title'))
    expect_is(cc, "tbl_df")
    expect_is(cc$title, "character")
    expect_lte(nrow(cc),5)

    y <- dataset_suggest(networkKey = "99d66b6c-9087-452f-a9d4-f15f2c2d0e7e",limit=5)
    yy <- dataset_suggest(networkKey =
                           "99d66b6c-9087-452f-a9d4-f15f2c2d0e7e;2b7c7b4f-4d4f-40d3-94de-c28b6fa054a6",
                         limit=5)
    
    expect_named(y, c('key', 'type', 'title'))
    expect_is(y, "tbl_df")
    expect_is(y$title, "character")
    expect_lte(nrow(y),5)

    expect_named(yy, c('key', 'type', 'title'))
    expect_is(yy, "tbl_df")
    expect_is(yy$title, "character")
    expect_lte(nrow(yy),5)

    # i <- dataset_suggest(doi="10.15468/aomfnb",limit=5)
    ii <- dataset_suggest(doi="10.15468/aomfnb;10.15468/igasai")

    # expect_named(i, c('key', 'type', 'title'))
    # expect_is(i, "tbl_df")
    # expect_is(i$title, "character")
    # expect_lte(nrow(i),5)

    expect_named(ii, c('key', 'type', 'title'))
    expect_is(ii, "tbl_df")
    expect_is(ii$title, "character")
    expect_lte(nrow(ii),5)

  }, preserve_exact_body_bytes = TRUE)
  
})

test_that("Return just descriptions", {
  vcr::use_cassette("dataset_suggest_description", {
    tt <- dataset_suggest(type="OCCURRENCE", description=TRUE)
  }, preserve_exact_body_bytes = TRUE)

  expect_is(tt, "list")
  expect_is(tt[[1]], "character")
})
