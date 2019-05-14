context("installations")

test_that("query all installations returns the correct class", {
  vcr::use_cassette("installations", {
    tt <- installations()
  }, preserve_exact_body_bytes = TRUE)
  
  expect_is(tt, "list")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data$organizationKey, "character")
})

test_that("single dataset query returns the correct", {
  vcr::use_cassette("installations_uuid", {
    tt <- installations(uuid="b77901f9-d9b0-47fa-94e0-dd96450aa2b4")
  })

  expect_is(tt, "list")
  expect_null(tt$meta)
  expect_is(tt$data$modifiedBy, "character")

  # value
  expect_equal(tt$data$type, "IPT_INSTALLATION")
  expect_is(tt$data$contacts, "data.frame")
  expect_is(tt$data$endpoints, "data.frame")
})

test_that("contact returns the correct", {
  vcr::use_cassette("installations_uuid_data", {
    tt <- installations(data='contact', uuid="2e029a0c-87af-42e6-87d7-f38a50b78201")
  })
  expect_is(tt, "list")
  expect_null(tt$meta)
  expect_is(tt$data$firstName, "character")

  # value
  expect_equal(tt$data$type, "TECHNICAL_POINT_OF_CONTACT")
})

test_that("search for deleted and nonPublishing installations returns the correct", {
  vcr::use_cassette("installations_deleted", {
    tt <- installations(data='deleted', limit=2)
  }, preserve_exact_body_bytes = TRUE)
  
  # class
  expect_is(tt, "list")

  # value
  expect_equal(length(tt), 2)
  expect_equal(length(tt$data), 17)
})
