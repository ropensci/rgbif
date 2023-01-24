context("lit_search")

test_that("lit_search works as expected", {
  vcr::use_cassette("lit_search", {
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
    oo <- lit_search(start=9997,limit=2)
    # multiple values 
    mm1 <- lit_search(relevance=c("GBIF_USED","GBIF_CITED"),limit=10)
    mm2 <- lit_search(relevance=c("GBIF_USED","GBIF_CITED"),
                      topics=c("EVOLUTION","PHYLOGENETICS"),
                      limit=10)
    # year ranges work
    yy <- lit_search(year="2011,2020",limit=5)
    
  }, preserve_exact_body_bytes = TRUE)
  
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
  
  expect_length(oo,2)
  expect_is(oo$data,"data.frame")
  expect_is(oo$meta,"list")
  # flatten=TRUE should have no lists
  expect_true(!all(sapply(oo$data,class) == "list"))
  
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
  
  # bad inputs
  expect_error(lit_search(datasetKey="dog"),"'datasetKey' should be a GBIF dataset uuid.")
  expect_error(lit_search(publishingOrg="dog"),"'publishingOrg' should be a GBIF publisher uuid.")
  expect_error(lit_search(downloadKey="dog"),"'downloadKey' should be a GBIF downloadkey.")
  expect_error(lit_search(limit=2000),"Max 'limit' is 1000.")
  expect_error(lit_search(start=10000,limit=0),"Max 'start' \\+ 'limit' is 10,000.")
  expect_error(lit_search(start=9999,limit=2),"Max 'start' \\+ 'limit' is 10,000.")
  expect_error(lit_search(q=2), "q must be of class character")
  expect_error(lit_search(peerReview="frog"), "peerReview must be of class logical")
})

test_that("lit_count works as expected", {
  vcr::use_cassette("lit_count", {
    ii <- lit_count(datasetKey="50c9509d-22c7-4a22-a47d-8c48425ef4a7")
    ee <- lit_count()
    # many values 
    mm <- lit_count(datasetKey=c("9ca92552-f23a-41a8-a140-01abaa31c931",
                                     "50c9509d-22c7-4a22-a47d-8c48425ef4a7"))
    
    }, preserve_exact_body_bytes = TRUE)
  
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

test_that("lit_all_gbif works as expected", {
  skip_on_cran()
  skip_on_ci()
  
  # takes a while so I skip running it 
  # vv <- lit_all_gbif() # fetch all peer-reviewed lit from a journal
  # expect_true(nrow(vv) > 8000) # limit + steps
  # expect_is(vv,"data.frame")
  # expect_true(!all(sapply(vv,class) == "list"))
  # expect_true(all(vv$peerReview==TRUE))
  # expect_true(all(grepl("GBIF_USED",vv$relevance)))
  # expect_true(all(grepl("JOURNAL",vv$literatureType)))
  
  aa <- lit_all_gbif(limit=20)
  nn <- lit_all_gbif(peerReview = NULL,limit=20)
  pp <- lit_all_gbif(peerReview = FALSE,limit=20)
  ff <- lit_all_gbif(limit=20,flatten=FALSE)
  
  expect_true(nrow(aa) == 20) # limit + steps
  expect_is(aa,"data.frame")
  expect_true(!all(sapply(aa,class) == "list"))
  expect_true(all(aa$peerReview==TRUE))
  expect_true(all(grepl("GBIF_USED",aa$relevance)))
  expect_true(all(grepl("JOURNAL",aa$literatureType)))
  
  expect_is(pp,"data.frame")
  expect_true(all(pp$peerReview==FALSE))
  
  expect_is(nn,"data.frame")
  # expect_true(FALSE %in% nn$peerReview)
  # expect_true(TRUE %in% nn$peerReview)
  
  # flatten=FALSE should return some list types
  expect_is(ff,"data.frame")
  expect_true(any(sapply(ff,class) == "list"))
  
  expect_error(lit_all_gbif(limit=11000),"Max 'limit' \\+ 'step' is 10,000.")
  # expect_error(lit_all_gbif(step=2000),"Max step is 1000.")
  
  
  
})

test_that("lit_all_dataset works as expected", {
  skip_on_cran()
  skip_on_ci()
  
  # takes a while so I skip running it 
  # vv <- lit_all_dataset("50c9509d-22c7-4a22-a47d-8c48425ef4a7") # fetch all iNat related lit
  # print(vv %>% glimpse())
  # expect_true(nrow(vv) > 3000) # should not lose citations
  # expect_is(vv,"data.frame")
  # expect_true(!all(sapply(vv,class) == "list"))
  # expect_true(!all(vv$peerReview==TRUE)) # default is NULL so should return both

  aa <- lit_all_dataset("50c9509d-22c7-4a22-a47d-8c48425ef4a7",limit=20)
  nn <- lit_all_dataset("50c9509d-22c7-4a22-a47d-8c48425ef4a7",peerReview = NULL,limit=20)
  pp <- lit_all_dataset("50c9509d-22c7-4a22-a47d-8c48425ef4a7",peerReview = FALSE,limit=20)
  ff <- lit_all_dataset("50c9509d-22c7-4a22-a47d-8c48425ef4a7",limit=20,flatten=FALSE)
  ll <- lit_all_dataset("9ca92552-f23a-41a8-a140-01abaa31c931") # few citations
  
  expect_true(nrow(aa) == 20) 
  expect_is(aa,"data.frame")
  expect_true(!all(sapply(aa,class) == "list"))
  expect_true(!all(aa$peerReview==TRUE))

  expect_is(pp,"data.frame")
  expect_true(all(pp$peerReview==FALSE))
   
  expect_is(nn,"data.frame")
  expect_true(FALSE %in% nn$peerReview)
  expect_true(TRUE %in% nn$peerReview)
  
  # flatten=FALSE should return some list types
  expect_is(ff,"data.frame")
  expect_true(any(sapply(ff,class) == "list"))
  
  # check with not many citations
  expect_is(ll,"data.frame")
  expect_true(!all(sapply(ll,class) == "list"))
  expect_true(!all(ll$peerReview==TRUE))
  
  expect_error(lit_all_dataset("50c9509d-22c7-4a22-a47d-8c48425ef4a7",limit=11000),"Max 'limit' \\+ 'step' is 10,000.")
  # expect_error(lit_all_dataset("50c9509d-22c7-4a22-a47d-8c48425ef4a7",step=2000),"Max step is 1000.")
  expect_error(lit_all_dataset("dog"),"'datasetKey' should be a GBIF datasetkey uuid.")
  
})

