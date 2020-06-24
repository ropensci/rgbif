test_that("occ_download_get", {
  skip_on_cran()

  vcr::use_cassette("occ_download_get1", {
    expect_message((zzz=occ_download_get("0000066-140928181241064", path = tempdir())),
      "On disk at")
    # fails if overwrite=FALSE
    expect_error(occ_download_get("0000066-140928181241064", path = tempdir()))
  })
  
  expect_is(zzz, "occ_download_get")
  expect_is(unclass(zzz), "character")
  expect_match(unclass(zzz)[1], "[0-9]+-[0-9]+\\.zip")
  expect_is(attr(zzz, "size"), "numeric")
  expect_is(attr(zzz, "key"), "character")
  expect_equal(attr(zzz, "format"), "DWCA")
  # expect_true(file.exists(zzz))
  unlink(zzz)

  expect_output(print(zzz), "gbif downloaded get")
  expect_output(print(zzz), "Path")
  expect_output(print(zzz), "File size")
})

test_that("occ_download_get fails well", {
  # key is missing
  expect_error(occ_download_get())
  # key wrong type
  expect_error(occ_download_get(5))
  # path wrong type
  expect_error(occ_download_get("foobar", path=5))
  # overwrite wrong type
  expect_error(occ_download_get("foobar", overwrite=5))
})
