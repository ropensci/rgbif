context("dataset_gridded")

skip_on_cran()
skip_on_ci()

test_that("dataset_gridded good data", {
  uuids <-
    c("9070a460-0c6e-11dd-84d2-b8a03c50a862",
      "c779b049-28f3-4daf-bbf4-0a40830819b6",
      NA,
      "9070a460-0c6e-11dd-84d2-b8a03c50a862",
      "4fa7b334-ce0d-4e88-aaae-2e0c138d049e",
      NA
    )

  # test return="logical"
  x <- dataset_gridded(uuids,warn=FALSE)
  expect_true(is.logical(x))
  expect_length(x,length(uuids))
  expect_true(any(is.na(x)))
  expect_true(any(x))

  # test return="data"
  xx <- dataset_gridded(uuids,return="data",warn=FALSE)
  expect_false(is.logical(xx))
  expect_equal(nrow(xx),length(uuids))
  expect_equal(ncol(xx),8)
  expect_equal(class(xx),"data.frame")

  # single datasetkey
  z <- dataset_gridded("9070a460-0c6e-11dd-84d2-b8a03c50a862",warn=FALSE)
  expect_true(is.logical(z))
  expect_length(z,1)

  # single missing
  expect_error(dataset_gridded(NA),"'uuid' should be a GBIF datasetkey uuid.")
  })


test_that("dataset_gridded bad data", {
  bad_uuids <-
    c("9070a460-0c6e-11dd-84d2-b8a03c50a862",
      "dog",
      NA,
      "cat",
      "4fa7b334-ce0d-4e88-aaae-2e0c138d049e",
      NA
    )

  # test return="logical"
  b <- dataset_gridded(bad_uuids,warn=FALSE)
  expect_true(is.logical(b))
  expect_length(b,length(bad_uuids))
  expect_true(any(is.na(b)))

  # # test return="data"
  bb <- dataset_gridded(bad_uuids,return="data",warn=FALSE)
  expect_false(is.logical(bb))
  expect_equal(nrow(bb),length(bad_uuids))
  expect_equal(ncol(bb),8)
  expect_equal(class(bb),"data.frame")

  # other types of bad input
  expect_error(dataset_gridded(1),"'uuid' should be a GBIF datasetkey uuid.")
  expect_error(dataset_gridded(1,1),"'uuid' should be a GBIF datasetkey uuid.")
  expect_error(dataset_gridded(c(1,1),return="data"),"'uuid' should be a GBIF datasetkey uuid.")
  expect_error(dataset_gridded(NULL),"'uuid' should be a GBIF datasetkey uuid.")
  expect_error(dataset_gridded(FALSE),"'uuid' should be a GBIF datasetkey uuid.")
  expect_error(dataset_gridded(1,return="data"),"'uuid' should be a GBIF datasetkey uuid.")

  # test only non-gridded datasets
  expect_false(dataset_gridded("13b70480-bd69-11dd-b15f-b8a03c50a862"))
  expect_false(dataset_gridded("13b70480-bd69-11dd-b15f-b8a03c50a862",return="data")$is_gridded)

  nn <- dataset_gridded(c("4fa7b334-ce0d-4e88-aaae-2e0c138d049e","13b70480-bd69-11dd-b15f-b8a03c50a862"))
  expect_equal(length(nn),2)
  expect_false(any(nn))
  expect_equal(class(nn),"logical")

  dd <- dataset_gridded(c("4fa7b334-ce0d-4e88-aaae-2e0c138d049e","13b70480-bd69-11dd-b15f-b8a03c50a862"),return="data")
  expect_true(all(is.na(dd$min_distance)))
  expect_false(any(dd$is_gridded))
  expect_false(is.logical(dd))
  expect_equal(nrow(dd),2)
  expect_equal(ncol(dd),8)
  expect_equal(class(dd),"data.frame")

})
