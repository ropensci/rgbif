# invisible(vcr::vcr_configure(
#   dir = "tests/fixtures",
#   filter_sensitive_data = list(
#     "<gbif_user>" = Sys.getenv("GBIF_USER"),
#     "<gbif_pwd>" = Sys.getenv("GBIF_PWD"),
#     "<gbif_email>" = Sys.getenv("GBIF_EMAIL"),
#     "<geonames_user>" = Sys.getenv("GEONAMES_USER")
#   )
# ))
# vcr_configuration()

test_that("occ_download: real requests work", {
  skip_on_cran()

  vcr::use_cassette("occ_download_1", {
    zzz <- occ_download(pred("taxonKey", 9206251),
      pred_in("country", c("US", "CA")), pred_gte("year", 1979))
  }, match_requests_on = c("method", "uri", "body"))
  
  expect_is(zzz, "occ_download")
  expect_output(print(zzz),"Your download is being processed by GBIF:")
  expect_output(print(zzz),"Please always cite the download DOI when using this data.")
  expect_is(unclass(zzz), "character")
  expect_match(unclass(zzz)[1], "^[0-9]{7}-[0-9]{15}$")
  expect_equal(attr(zzz, "user"), Sys.getenv("GBIF_USER"))
  expect_equal(attr(zzz, "email"),Sys.getenv("GBIF_EMAIL"))
  expect_equal(attr(zzz, "format"), "DWCA")
  expect_is(attr(zzz,"doi"),"character")
  expect_is(attr(zzz,"citation"),"character")
  expect_is(attr(zzz,"downloadLink"),"character")
  expect_output(print.occ_download(zzz),"<<gbif download>>")
  expect_equal(length(capture.output(print(zzz))),22)

  # skip on ci because when testing real requests, we'd get rate limited
  skip_on_ci()

  vcr::use_cassette("occ_download_2", {
    x <- occ_download(
      pred_and(
        pred_within("POLYGON((-14 42, 9 38, -7 26, -14 42))"),
        pred_gte("elevation", 5000)
      )
    )
  }, match_requests_on = c("method", "uri", "body"))
  
  expect_is(x, "occ_download")
  expect_is(unclass(x), "character")
  expect_match(unclass(x)[1], "^[0-9]{7}-[0-9]{15}$")
  expect_equal(attr(x, "user"), Sys.getenv("GBIF_USER"))
  expect_equal(attr(x, "email"), Sys.getenv("GBIF_EMAIL"))
  expect_equal(attr(x, "format"), "DWCA")
  expect_is(attr(x, "created"),"character")
  expect_is(attr(x, "status"),"character")
  expect_is(attr(x, "downloadLink"),"character")
  expect_is(attr(x, "doi"), "character")
  expect_is(attr(x, "citation"), "character")
  expect_is(attr(x,"doi"),"character")
  expect_is(attr(x,"citation"),"character")
  expect_is(attr(x,"downloadLink"),"character")
  expect_output(print.occ_download(x),"<<gbif download>>")
  expect_equal(length(capture.output(print(x))),22)
  
  vcr::use_cassette("occ_download_3", {
    z <- occ_download(pred_gte("decimalLatitude", 75), format = "SPECIES_LIST")
  }, match_requests_on = c("method", "uri", "body"))

  expect_is(z, "occ_download")
  expect_is(unclass(z), "character")
  expect_match(unclass(z)[1], "^[0-9]{7}-[0-9]{15}$")
  expect_equal(attr(z, "user"), Sys.getenv("GBIF_USER"))
  expect_equal(attr(z, "email"), Sys.getenv("GBIF_EMAIL"))
  expect_equal(attr(z, "format"), "SPECIES_LIST")
  expect_is(attr(z,"doi"),"character")
  expect_is(attr(z,"downloadLink"),"character")
  expect_is(attr(z,"citation"),"character")
  expect_output(print.occ_download(z),"<<gbif download>>")
  expect_equal(length(capture.output(print(z))),22)
  
  # test complex download 
  vcr::use_cassette("occ_download_4", {
    ccc <- occ_download(
    type="and",
    pred("taxonKey", 5052020),
    pred("hasGeospatialIssue", FALSE),
    pred("hasCoordinate", TRUE),
    pred_gte("year", 1900),
    pred_not(pred("basisOfRecord", "FOSSIL_SPECIMEN")),
    pred_or(
    pred_not(pred_in("establishmentMeans",c("MANAGED","INTRODUCED"))),
    pred_isnull("establishmentMeans"),
    pred_lt("coordinateUncertaintyInMeters",10000),
    pred_isnull("coordinateUncertaintyInMeters"),
    pred_like("catalogNumber","PAPS5-560*")
    ),
    format = "SIMPLE_CSV"
    )
  }, match_requests_on = c("method", "uri", "body"))
  
  expect_is(ccc, "occ_download")
  expect_is(unclass(ccc), "character")
  expect_match(unclass(ccc)[1], "^[0-9]{7}-[0-9]{15}$")
  expect_equal(attr(ccc, "user"), Sys.getenv("GBIF_USER"))
  expect_equal(attr(ccc, "email"), Sys.getenv("GBIF_EMAIL"))
  expect_equal(attr(ccc, "format"), "SIMPLE_CSV")
  expect_is(attr(ccc,"doi"),"character")
  expect_is(attr(ccc,"citation"),"character")
  expect_is(attr(ccc,"downloadLink"),"character")
  expect_output(print.occ_download(ccc),"<<gbif download>>")
  expect_equal(length(capture.output(print(ccc))),22)

  # test new key
  vcr::use_cassette("occ_download_5", {
    vvv <- occ_download(
      type="and",
      pred("verbatimScientificName", "Calopteryx"),
      format = "SIMPLE_CSV"
    )
  }, match_requests_on = c("method", "uri", "body"))
  
  expect_is(vvv, "occ_download")
  expect_is(unclass(vvv), "character")
  expect_match(unclass(vvv)[1], "^[0-9]{7}-[0-9]{15}$")
  expect_equal(attr(vvv, "user"), Sys.getenv("GBIF_USER"))
  expect_equal(attr(vvv, "email"), Sys.getenv("GBIF_EMAIL"))
  expect_equal(attr(vvv, "format"), "SIMPLE_CSV")
  expect_is(attr(vvv,"doi"),"character")
  expect_is(attr(vvv,"citation"),"character")
  expect_is(attr(vvv,"downloadLink"),"character")
  expect_output(print.occ_download(vvv),"<<gbif download>>")
  expect_equal(length(capture.output(print(vvv))),22)
  
  # test new key
  vcr::use_cassette("occ_download_6", {
    ooo <- occ_download(
      type="and",
      pred_gt("organismQuantity", 1),
      format = "SIMPLE_CSV"
    )
  }, match_requests_on = c("method", "uri", "body"))
  
  expect_is(ooo, "occ_download")
  expect_is(unclass(ooo), "character")
  expect_match(unclass(ooo)[1], "^[0-9]{7}-[0-9]{15}$")
  expect_equal(attr(ooo, "user"), Sys.getenv("GBIF_USER"))
  expect_equal(attr(ooo, "email"), Sys.getenv("GBIF_EMAIL"))
  expect_equal(attr(ooo, "format"), "SIMPLE_CSV")
  expect_is(attr(ooo,"doi"),"character")
  expect_is(attr(ooo,"citation"),"character")
  expect_is(attr(ooo,"downloadLink"),"character")
  expect_output(print.occ_download(ooo),"<<gbif download>>")
  expect_equal(length(capture.output(print(ooo))),22)

  # test new key
  vcr::use_cassette("occ_download_7", {
    sss <- occ_download(
      type="and",
      pred("lifeStage", "Adult"),
      format = "SIMPLE_CSV"
    )
  }, match_requests_on = c("method", "uri", "body"))
  
  expect_is(sss, "occ_download")
  expect_is(unclass(sss), "character")
  expect_match(unclass(sss)[1], "^[0-9]{7}-[0-9]{15}$")
  expect_equal(attr(sss, "user"), Sys.getenv("GBIF_USER"))
  expect_equal(attr(sss, "email"), Sys.getenv("GBIF_EMAIL"))
  expect_equal(attr(sss, "format"), "SIMPLE_CSV")
  expect_is(attr(sss,"doi"),"character")
  expect_is(attr(sss,"citation"),"character")
  expect_is(attr(sss,"downloadLink"),"character")
  expect_output(print.occ_download(sss),"<<gbif download>>")
  expect_equal(length(capture.output(print(sss))),22)
  
  # test pred_default() works
  vcr::use_cassette("occ_download_8", {
    ddd <- occ_download(
      pred_default(),
      pred("typeStatus","ALLOLECTOTYPE"),
      format = "SIMPLE_CSV"
    )
  }, match_requests_on = c("method", "uri", "body"))
  
  expect_is(unclass(ddd), "character")
  expect_match(unclass(ddd)[1], "^[0-9]{7}-[0-9]{15}$")
  expect_equal(attr(ddd, "user"), Sys.getenv("GBIF_USER"))
  expect_equal(attr(ddd, "email"), Sys.getenv("GBIF_EMAIL"))
  expect_equal(attr(ddd, "format"), "SIMPLE_CSV")
  expect_is(attr(ddd,"doi"),"character")
  expect_is(attr(ddd,"citation"),"character")
  expect_is(attr(ddd,"downloadLink"),"character")
  expect_output(print.occ_download(ddd),"<<gbif download>>")
  expect_equal(length(capture.output(print(ddd))),22)
  
})



