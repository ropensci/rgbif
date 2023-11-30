context("dataset_uuid_funs")

skip_on_cran()

test_that("dataset_uuid_funs work as expected", {
  vcr::use_cassette("dataset_uuid_funs",{
    dd <- dataset_info()
    ds_pro <- dataset_process()
    ds_net <- dataset_networks()
    ds_const <- dataset_constituents()
    ds_met <- dataset_metadata()
    ds_com <- dataset_comment()
    ds_cont <- dataset_contact()
    ds_end <- dataset_endpoint()
    ds_id <- dataset_identifier()
    ds_mt <- dataset_machinetag()
    ds_tag <- dataset_tag()
  }, preserve_exact_body_bytes = TRUE)
  
})
