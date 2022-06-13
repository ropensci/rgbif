
test_that("gbif_geocode good data", {
    skip_on_cran()
    skip_on_ci()  
  
  latitude <- c(6.21894170064479,
                -62.9498637467623,
                29.1579705337062,
                -41.8117704614997,
                -22.3302195221186,
                -75.0109953107312,
                -55.8152778726071,
                14.4396186294034,
                -70.4408057732508,
                28.4300485951826,
                0)
  
  longitude <- c(-162.108721397817,
                 24.4691565725952,
                 62.3468875698745,
                 121.634590448812,
                 75.5223315116018,
                 -54.7737318556756,
                 149.485444463789,
                 90.1322764065117,
                 -30.4905872326344,
                 158.874245462939,
                 NA)
  
  z <- gbif_geocode(latitude,longitude)
  
  expect_is(z,"data.frame")
  expect_equal(max(z$index),length(latitude))
  expect_equal(max(z$index),length(longitude))
  expect_gt(nrow(z),length(latitude))
  expect_true(all(c("latitude", "longitude", "index") %in% colnames(z)))
  expect_is(z$type,"character")
  expect_is(z$id,"character")
  expect_is(z$latitude,"numeric")
  expect_is(z$longitude,"numeric")
  #handles missing data well
  expect_true(is.na(tail(z,1)$id))
  expect_true(is.na(tail(z,1)$longitude))
  
  # single location 
  x <- gbif_geocode(0,0) 
  expect_is(x,"data.frame")
  expect_equal(max(x$index),1)
  expect_equal(max(x$index),1)
  expect_gt(nrow(x),1)
  expect_true(all(c("latitude", "longitude", "index") %in% colnames(x)))
  expect_is(x$type,"character")
  expect_is(x$id,"character")
  expect_is(x$latitude,"numeric")
  expect_is(x$longitude,"numeric")
})


test_that("gbif_geocode bad data", {
  skip_on_cran()
  skip_on_ci()

  expect_warning(gbif_geocode(c(1,"dog"),c(2,1)),"NAs introduced by coercion")
  expect_warning(gbif_geocode(c(1,"dog"),c(2)), "NAs introduced by coercion")
  expect_error(gbif_geocode(NULL,NULL), "latitude should be between -90 and 90")
  
  # print(e)
  # expect_is(e,"data.frame")
  # expect_equal(max(z$index),length(latitude))
  # expect_equal(max(z$index),length(longitude))
  # expect_gt(nrow(z),length(latitude))
  # expect_true(all(c("latitude", "longitude", "index") %in% colnames(z)))
  # expect_is(z$type,"character")
  # expect_is(z$id,"character")
  # expect_is(z$latitude,"numeric")
  # expect_is(z$longitude,"numeric")
  
})
