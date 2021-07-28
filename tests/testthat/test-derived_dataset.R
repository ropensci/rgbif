
test_that("derived_dataset: real request", {
  skip_on_cran()
  
  data <- data.frame(
    datasetKey = c(
      "3ea36590-9b79-46a8-9300-c9ef0bfed7b8",
      "630eb55d-5169-4473-99d6-a93396aeae38",
      "806bf7d4-f762-11e1-a439-00145eb45e9a"
    ),
    count = c(3, 1, 2781)
  )
  
  vcr::use_cassette("derived_dataset_1",
                    {
                      zzz <- derived_dataset(
                        citation_data = data,
                        title = "Test for derived dataset",
                        description = "This data was filtered using a fake protocol",
                        source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
                        gbif_download_doi = NULL,
                      )
                    },
                    match_requests_on = c("method", "uri", "body"))
  
  expect_is(zzz, "derived_dataset")
  expect_false(is.null(zzz$citation))
  expect_false(is.null(zzz$title))
  expect_false(is.null(zzz$description))

  # Test with gbif_download_doi
  vcr::use_cassette("derived_dataset_2",
                    {
                      yyy <- derived_dataset(
                        citation_data = data,
                        title = "Test for derived dataset",
                        description = "This data was filtered using a fake protocol",
                        source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
                        gbif_download_doi = "10.15468/dl.hgc9gw",
                      )
                    },
                    match_requests_on = c("method", "uri", "body"))
  
  expect_is(yyy, "derived_dataset")
  expect_false(is.null(yyy$originalDownloadDOI))
  
})


test_that("derived_dataset: bad data", {
  
  # count and keys reversed
  bad_data_1 <- data.frame(
    count = c(3, 1, 2781),
    datasetKey = c(
      "3ea36590-9b79-46a8-9300-c9ef0bfed7b8",
      "630eb55d-5169-4473-99d6-a93396aeae38",
      "806bf7d4-f762-11e1-a439-00145eb45e9a"
    )
  )
  
  expect_error(
    derived_dataset_prep(
      citation_data = bad_data_1,
      title = "Test for derived dataset",
      description = "This data was filtered using a fake protocol",
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = "10.15468/dl.hgc9gw",
    )
  )
  
  bad_data_3 <- data.frame(
    datasetKey = c(
      "3ea36590-9b79-46a8-9300-c9ef0bfed7b8",
      "630eb55d-5169-4473-99d6-a93396aeae38",
      "806bf7d4-f762-11e1-a439-00145eb45e9a"
    ),
    count = c("dog", "cat", "frog")
  )
  
  expect_error(
    derived_dataset_prep(
      citation_data = bad_data_3,
      title = "Test for derived dataset",
      description = "This data was filtered using a fake protocol",
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = "10.15468/dl.hgc9gw",
    )
  )
  
  bad_data_2 <- data.frame(
    datasetKey = c(
      "not a key",
      "630eb55d-5169-4473-99d6-a93396aeae38",
      "806bf7d4-f762-11e1-a439-00145eb45e9a"
    ),
    count = c(3, 1, 2781)
  )
  
  expect_error(
    derived_dataset_prep(
      citation_data = bad_data_2,
      title = "Test for derived dataset",
      description = "This data was filtered using a fake protocol",
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = "10.15468/dl.hgc9gw",
    )
  )

  expect_error(
    derived_dataset_prep(
      citation_data = List("dog","cat"),
      title = "Test for derived dataset",
      description = "This data was filtered using a fake protocol",
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = "10.15468/dl.hgc9gw",
    )
  )
  
    
})

test_that("derived_dataset: title, description, and source_url filled", {
  skip_on_cran()
  skip_on_ci()
  
  expect_error(
    derived_dataset_prep(
      citation_data = data,
      title = NULL,
      description = "This data was filtered using a fake protocol",
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = "10.15468/dl.hgc9gw",
    )
  )
  
  expect_error(
    derived_dataset_prep(
      citation_data = data,
      title = "Test for derived dataset",
      description = NULL,
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = "10.15468/dl.hgc9gw",
    )
  )

  expect_error(
    derived_dataset_prep(
      citation_data = data,
      title = "Test for derived dataset",
      description = "This data was filtered using a fake protocol",
      source_url = NULL,
      gbif_download_doi = "10.15468/dl.hgc9gw",
    )
  )
  
})


