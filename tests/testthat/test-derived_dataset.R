
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
  expect_output(print.derived_dataset(yyy),"<<gbif derived dataset - created>>")
})

test_that("derived_dataset: bad data", {
  skip_on_cran()
  
  
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
      gbif_download_doi = "10.15468/dl.hgc9gw"
    ),
    "GBIF dataset uuids have 36 characters and look something like this :  '3ea36590-9b79-46a8-9300-c9ef0bfed7b8' Put your uuids in the first column. Occurrence counts in the second column."
  )
  
  bad_data_2 <- data.frame(
    datasetKey = c(
      "3ea36590-9b79-46a8-9300-c9ef0bfed7b8",
      "630eb55d-5169-4473-99d6-a93396aeae38",
      "806bf7d4-f762-11e1-a439-00145eb45e9a"
    ),
    count = c("dog", "cat", "frog")
  )
  
  expect_error(
    derived_dataset_prep(
      citation_data = bad_data_2,
      title = "Test for derived dataset",
      description = "This data was filtered using a fake protocol",
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = "10.15468/dl.hgc9gw"
    ),
    "Column 2 should be occurrence counts."
    )
  
  bad_data_3 <- data.frame(
    datasetKey = c(
      "not a key",
      "630eb55d-5169-4473-99d6-a93396aeae38",
      "806bf7d4-f762-11e1-a439-00145eb45e9a"
    ),
    count = c(3, 1, 2781)
  ) 

  expect_error(
    derived_dataset_prep(
      citation_data = bad_data_3,
      title = "Test for derived dataset",
      description = "This data was filtered using a fake protocol",
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = "10.15468/dl.hgc9gw"
      ),
    "GBIF dataset uuids have 36 characters and look something like this :  '3ea36590-9b79-46a8-9300-c9ef0bfed7b8' Put your uuids in the first column. Occurrence counts in the second column."
    )

  expect_error(
    derived_dataset_prep(
      citation_data = c("630eb55d-5169-4473-99d6-a93396aeae38",1),
      title = "Test for derived dataset",
      description = "This data was filtered using a fake protocol",
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = "10.15468/dl.hgc9gw"
    ),
    "citation_data should be a data.frame not a vector."
  )
  
  bad_data_4 <- data.frame(
    datasetKey = c(
      "3ea36590-9b79-46a8-9300-c9ef0bfed7b8",
      "630eb55d-5169-4473-99d6-a93396aeae38",
      "806bf7d4-f762-11e1-a439-00145eb45e9a"
    ),
    count = c(3, 1, 2781)
  )
  class(bad_data_4) <- "fake_class"
  
  expect_error(
    derived_dataset_prep(
      citation_data = bad_data_4,
      title = "Test for derived dataset",
      description = "This data was filtered using a fake protocol",
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY"
    )
    ,
    "Error converting to data.frame. Please supply a data.frame to citation_data"
  )
    
  bad_data_5 <- data.frame(
    datasetKey = c(
      "3ea36590-9b79-46a8-9300-c9ef0bfed7b8",
      "630eb55d-5169-4473-99d6-a93396aeae38",
      "806bf7d4-f762-11e1-a439-00145eb45e9a"
    ),
    count = c(0, 1, 2781)
  )
  
  expect_error(
  derived_dataset_prep(
    citation_data = bad_data_5,
    title = "Test for derived dataset",
    description = "This data was filtered using a fake protocol",
    source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY"
  ),
  "Only positive occurrence counts should be in column 2 of citation data."
  )
  
  bad_data_6 <- data.frame(
    datasetKey = c(
      "3ea36590-9b79-46a8-9300-c9ef0bfed7b8",
      "630eb55d-5169-4473-99d6-a93396aeae38",
      "806bf7d4-f762-11e1-a439-00145eb45e9a"
    ),
    count = c(NA_integer_, 1, 23)
  )

  expect_equal(
    length(derived_dataset_prep(
      citation_data = bad_data_6,
      title = "Test for derived dataset",
      description = "This data was filtered using a fake protocol",
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY"
    )$request$relatedDatasets),2)
  
})

test_that("derived_dataset: title, description, source_url, and gbif_download_doi", {
  skip_on_cran()
  
  data <- data.frame(
    datasetKey = c(
      "3ea36590-9b79-46a8-9300-c9ef0bfed7b8",
      "630eb55d-5169-4473-99d6-a93396aeae38",
      "806bf7d4-f762-11e1-a439-00145eb45e9a"
    ),
    count = c(3, 1, 2781)
  )
  
expect_error(
  derived_dataset_prep(
    citation_data = data,
    title = NULL,
    description = "This data was filtered using a fake protocol",
    source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
    gbif_download_doi = "10.15468/dl.hgc9gw"),
  "GBIF requires you to fill in the title."
  )

  expect_error(
    derived_dataset_prep(
    citation_data = data,
    title = 123,
    description = "This data was filtered using a fake protocol",
    source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
    gbif_download_doi = "10.15468/dl.hgc9gw"),
    "The title should be character string."
  )

  expect_error(
    derived_dataset_prep(
      citation_data = data,
      title = "Test for derived dataset",
      description = NULL,
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = "10.15468/dl.hgc9gw"
    ),
    "GBIF requires you to fill in the description."
  )

  expect_error(
    derived_dataset_prep(
      citation_data = data,
      title = "Test for derived dataset",
      description = 123,
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = "10.15468/dl.hgc9gw"
    ),
    "The description should be character string."
  )
  
  expect_error(
    derived_dataset_prep(
      citation_data = data,
      title = "Test for derived dataset",
      description = "This data was filtered using a fake protocol",
      source_url = NULL,
      gbif_download_doi = "10.15468/dl.hgc9gw"
    ),
    "Please fill in the url where the derived dataset is stored."
  )

  expect_error(
    derived_dataset_prep(
      citation_data = as.matrix(data),
      title = "Test for derived dataset",
      description = "This data was filtered using a fake protocol",
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = "10.15468/dl.hgc9gw"),
    "Column 2 should be occurrence counts."
    )
  
  expect_error(
    derived_dataset_prep(
      citation_data = NULL,
      title = "Test for derived dataset",
      description = "This data was filtered using a fake protocol",
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = "10.15468/dl.hgc9gw"),
    "Supply your datsetkey uuids with occurrence counts."
    )
  
  expect_error(
    derived_dataset_prep(
      citation_data = data[1],
      title = "Test for derived dataset",
      description = "This data was filtered using a fake protocol",
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = "10.15468/dl.hgc9gw"),
    "Data should have two columns with dataset uuids and occurrence counts."
    )
  
  expect_error(
  derived_dataset_prep(
      citation_data = data.frame(keys=c(),counts=c()),
      title = "Test for derived dataset",
      description = "This data was filtered using a fake protocol",
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = "10.15468/dl.hgc9gw"),
  "citation_data should not have zero rows. Check if your data.frame is empty."
  )

  expect_error(
  derived_dataset_prep(
    citation_data = data,
    title = "Test for derived dataset",
    description = "This data was filtered using a fake protocol",
    source_url = 123
  ),
  "The source_url should be character string."
  )
  
  expect_equal(
    class(derived_dataset_prep(
      citation_data = data,
      title = "Test for derived dataset",
      description = "This data was filtered using a fake protocol",
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = as.factor("10.15468/dl.hgc9gw")
    )$request$originalDownloadDOI),
    "character"
    )
  
  expect_error(
    derived_dataset_prep(
      citation_data = data,
      title = "Test for derived dataset",
      description = "This data was filtered using a fake protocol",
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = "10.15468/dl.hgc9gw.doi.org"
    ),
    "remove 'https://doi.org/' from gbif_download_doi."
  )

  expect_error(
    derived_dataset_prep(
      citation_data = data,
      title = "Test for derived dataset",
      description = "This data was filtered using a fake protocol",
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = "https://doi.org/10.15468/dl.hgc9gw"
    ),
    "remove 'https://doi.org/' from gbif_download_doi."
  )
  
 expect_message( 
  derived_dataset_prep(
    citation_data = data,
    title = "Test for derived dataset",
    description = "This data was filtered using a fake protocol",
    source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
    gbif_download_doi = "this is my doi"
  ),
  "For gbif_download_doi, DOI not valid, proceeding with potentially invalid DOI..."
  )
 
})

test_that("derived_dataset_prep: print methods", {
  skip_on_cran()
  
  data <- data.frame(
    datasetKey = c(
      "3ea36590-9b79-46a8-9300-c9ef0bfed7b8",
      "630eb55d-5169-4473-99d6-a93396aeae38",
      "806bf7d4-f762-11e1-a439-00145eb45e9a"
    ),
    count = c(3, 1, 2781)
  )
  
  expect_output(
  print(derived_dataset_prep(
    citation_data = data,
    title = "This is a test of the print method",
    description = "This data was filtered using a fake protocol",
    source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
    gbif_download_doi = "10.15468/dl.hgc9gw")),
  "This is a test of the print method"
  )
  
  expect_output(
    print(derived_dataset_prep(
      citation_data = data,
      title = "This is a test of the print method",
      description = "This data was filtered using a fake protocol",
      source_url = "https://zenodo.org/record/4246090#.YPGS2OgzZPY",
      gbif_download_doi = "10.15468/dl.hgc9gw")),
    "3ea36590-9b79-46a8-9300-c9ef0bfed7b8 : 3"
  )
  
  expect_error(print.derived_dataset(123))
  
})
