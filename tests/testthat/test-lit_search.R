context("lit_search")

test_that("lit_search works as expected", {
    skip_on_ci()
    skip_on_cran()
    
    oo <- lit_search()
    pp <- lit_search(limit=10000)
    nn <- lit_search(datasetKey="50c9509d-22c7-4a22-a47d-8c48425ef4a7")
    ee <- lit_search(limit=3)
    ss <- lit_search(q="dog",limit=3,flatten=TRUE)
    # many arguments 
    aa <- lit_search(datasetKey="50c9509d-22c7-4a22-a47d-8c48425ef4a7",
                     peerReview=TRUE,
                     year=2020,
                     literatureType="JOURNAL",
                     limit=3,
                     flatten=TRUE)
    
    
    # not flat 
    ww <- lit_search(q="dog",limit=3,flatten=FALSE)
    # large start works as expected 
    # multiple values 
    mm1 <- lit_search(relevance=c("GBIF_USED","GBIF_CITED"),limit=10)
    mm2 <- lit_search(relevance=c("GBIF_USED","GBIF_CITED"),
                      topics=c("EVOLUTION","PHYLOGENETICS"),
                      limit=10)
    # year ranges work
    yy <- lit_search(year="2011,2020",limit=5)
    
    # exit early if we know there will be no results with fake datasetkey
    hh <- lit_search(datasetKey="592d81d0-5e2a-41f3-b75b-d96a7d997a0c")
  
  expect_length(oo,2)
  expect_is(oo$data,"data.frame")
  expect_is(oo$meta,"list")
  # flatten=TRUE should have no lists
  expect_true(!all(sapply(oo$data,class) == "list"))
  expect_true(nrow(oo$data) == 1000)
  
  expect_length(pp,2)
  expect_is(pp$data,"data.frame")
  expect_is(pp$meta,"list")
  # flatten=TRUE should have no lists
  expect_true(!all(sapply(pp$data,class) == "list"))
  expect_true(nrow(pp$data) == 10000)
  
  expect_length(nn,2)
  expect_is(nn$data,"data.frame")
  expect_is(nn$meta,"list")
  # flatten=TRUE should have no lists
  expect_true(!all(sapply(nn$data,class) == "list"))
  expect_true(nrow(nn$data) == nn$meta$count)
  
  expect_length(ee,2)
  expect_is(ee$data,"data.frame")
  expect_is(ee$meta,"list")
  # flatten=TRUE should have no lists
  expect_true(!all(sapply(ee$data,class) == "list"))
  expect_true(nrow(ee$data) <= 3)

  expect_length(ss,2)
  expect_is(ss$data,"data.frame")
  expect_is(ss$meta,"list")
  # flatten=TRUE should have no lists
  expect_true(!all(sapply(ss$data,class) == "list"))
  
  expect_length(aa,2)
  expect_is(aa$data,"data.frame")
  expect_is(aa$meta,"list")
  # flatten=TRUE should have no lists
  expect_true(!all(sapply(aa$data,class) == "list"))
  
  # flatten=FALSE should have lists
  expect_true(any(sapply(ww$data,class) == "list"))
  
  # many values for arguments
  expect_length(mm1,2)
  expect_is(mm1$data,"data.frame")
  expect_is(mm1$meta,"list")
  # flatten=TRUE should have no lists
  expect_true(!all(sapply(mm1$data,class) == "list"))
  expect_true(all(mm1$data$relevance %in% c("GBIF_USED","GBIF_CITED")))

  expect_length(mm2,2)
  expect_is(mm2$data,"data.frame")
  expect_is(mm2$meta,"list")
  # flatten=TRUE should have no lists
  expect_true(!all(sapply(mm2$data,class) == "list"))
  expect_true(all(grepl("GBIF_USED|GBIF_CITED",mm2$data$relevance)))
  expect_true(all(grepl("EVOLUTION|PHYLOGENETICS",mm2$data$topics)))
  
  # year ranges
  expect_length(yy,2)
  expect_is(yy$data,"data.frame")
  expect_is(yy$meta,"list")
  expect_true(all(yy$data$year >= 2011 & yy$data$year <= 2020))
  
  # exit early for no results
  expect_length(hh,2)
  expect_is(hh$data,"data.frame")
  expect_is(hh$meta,"list")
  expect_equal(nrow(hh$data),0)
  
  # bad inputs
  expect_error(lit_search(datasetKey="dog"),"'datasetKey' should be a GBIF dataset uuid.")
  expect_error(lit_search(publishingOrg="dog"),"'publishingOrg' should be a GBIF publisher uuid.")
  expect_error(lit_search(downloadKey="dog"),"'downloadKey' should be a GBIF downloadkey.")
  expect_error(lit_search(q=2), "q must be of class character")
  expect_error(lit_search(peerReview="frog"), "peerReview must be of class logical")
  
  expect_message(lit_search(limit=10001),"Not returning all records. Max records is 10,000.")
  expect_message(lit_search(),"No filters used, but 'limit=NULL' returning just the first 1000 results. If you actually just want the first 10,000 records, use 'limit=10000'.")
  
})

test_that("lit_count works as expected", {
  skip_on_ci()
  skip_on_cran()
  
  ii <- lit_count(datasetKey="50c9509d-22c7-4a22-a47d-8c48425ef4a7")
  ee <- lit_count()
  # many values 
  mm <- lit_count(datasetKey=c("9ca92552-f23a-41a8-a140-01abaa31c931",
                               "50c9509d-22c7-4a22-a47d-8c48425ef4a7"))
  expect_is(ii,"integer")
  expect_true(ii > 3000) # don't expect citations to go down
  
  expect_is(ee,"integer")
  expect_true(ee > 30000) # don't expect citations to go down
  
  # many values work 
  expect_is(mm,"integer")
  expect_true(mm > ii) # more datasets = more citations
  
  # bad inputs
  expect_error(lit_count(dog="1"), "Please use accepted argument from lit_search\\(\\) \\:q, countriesOfResearcher, countriesOfResearcher, countriesOfCoverage, literatureType, relevance, year, topics, datasetKey, publishingOrg, peerReview, openAccess, downloadKey, doi, journalSource, journalPublisher")
  
})


