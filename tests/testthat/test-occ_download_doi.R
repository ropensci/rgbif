

test_that("occ_download_doi", {

  vcr::use_cassette("occ_download_doi", {
    ii <- occ_download_doi("10.15468/dl.hx3uzz")
    })    
    expect_is(ii, "occ_download_doi")
    expect_equal(ii$key, "0108986-200613084148143")
    expect_equal(ii$doi, "10.15468/dl.hx3uzz")
    
    expect_error(expect_warning(occ_download_doi("dog")))
    expect_error(occ_download_doi(1))

})




