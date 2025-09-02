context("name_backbone")

test_that("name_backbone returns the correct class", {
  vcr::use_cassette("name_backbone", {
    tt <- name_backbone(name = 'Helianthus annuus', rank = 'species')
    uu <- name_backbone_verbose(name = 'Helianthus annuus', rank = 'species')
    nn <- name_backbone(name = "Calopteryx fakeus")
    kk <- name_backbone(name = "Calopteryx splendens", kingdom = "Plantae",
                        strict = FALSE)
    ss <- name_backbone(name = "Calopteryx splendens", kingdom = "Plantae", 
                        strict = TRUE)
    vv <- name_backbone(name = "Calopteryx splendens", kingdom = "Plantae", 
                        verbose = TRUE)
    vvv <- name_backbone(name = "Calopteryx splendens", kingdom = "Plantae", 
                        verbose = TRUE, strict = TRUE)
    
    # test new args from species match v2
    cc <- name_backbone(name = "Aves",
                  checklistKey="7ddf754f-d193-4cc9-b351-99906754a03b")
    bb <- name_backbone(name = "Calopteryx",
                  checklistKey="7ddf754f-d193-4cc9-b351-99906754a03b",
                  usageKey = "V2")
    dd <- name_backbone(genericName = "Agra", 
                    specificEpithet = "schwarzeneggeri",
                    scientificNameAuthorship = "Erwin, 2002")
  })

  expect_is(tt, "tbl")
  expect_is(tt, "tbl_df")
  expect_is(tt, "data.frame")
  expect_true(all(tt$verbatim_name == "Helianthus annuus"))
  expect_true(rev(names(tt))[1] =="verbatim_rank")
  expect_equal(tt$verbatim_name[1], "Helianthus annuus")
  expect_equal(tt$verbatim_rank[1], "species")
  expect_equal(nrow(tt),1)
  
  expect_is(uu, "list")
  expect_is(uu$data, "tbl")
  expect_is(uu$data, "tbl_df")
  expect_is(uu$data, "data.frame")
  expect_is(uu$alternatives, "tbl")
  expect_is(uu$alternatives, "tbl_df")
  expect_is(uu$alternatives, "data.frame")
  expect_is(uu$alternatives$phylumKey, "character")
  expect_is(uu$alternatives$canonicalName, "character")
  
  expect_is(nn, "tbl")
  expect_is(nn, "tbl_df")
  expect_is(nn, "data.frame")
  expect_true(all(nn$verbatim_name == "Calopteryx fakeus"))
  expect_equal(nn$verbatim_name[1], "Calopteryx fakeus")
  expect_equal(nn$matchType, "NONE")
  expect_equal(nrow(nn), 1)
  
  # test that strict does not return HIGHERRANK matches
  expect_is(kk, "tbl")
  expect_is(kk, "tbl_df")
  expect_is(kk, "data.frame")
  expect_equal(kk$verbatim_name[1], "Calopteryx splendens")
  expect_equal(kk$kingdom[1], "Plantae")
  expect_equal(kk$matchType[1], "HIGHERRANK")
  
  expect_is(ss, "tbl")
  expect_is(ss, "tbl_df")
  expect_is(ss, "data.frame")
  expect_equal(ss$verbatim_name[1], "Calopteryx splendens")
  expect_equal(ss$verbatim_kingdom[1], "Plantae")
  expect_equal(ss$matchType, "NONE")
  
  expect_is(vv, "tbl")
  expect_is(vv, "tbl_df")
  expect_is(vv, "data.frame")
  expect_equal(vv$verbatim_name[1], "Calopteryx splendens")
  expect_equal(vv$verbatim_kingdom[1], "Plantae")
  expect_gte(nrow(vv), 1)
  expect_true("HIGHERRANK" %in% unique(vv$matchType))
  
  expect_is(vvv, "tbl")
  expect_is(vvv, "tbl_df")
  expect_is(vvv, "data.frame")
  expect_equal(vvv$verbatim_name[1], "Calopteryx splendens")
  expect_equal(vvv$verbatim_kingdom[1], "Plantae")
  expect_gte(nrow(vvv), 1)
  expect_false("HIGHERRANK" %in% unique(vvv$matchType))
  
  expect_is(cc, "tbl")
  expect_is(cc, "tbl_df")
  expect_is(cc, "data.frame")
  expect_equal(cc$verbatim_name[1], "Aves")
  expect_equal(cc$verbatim_checklistKey[1], 
               "7ddf754f-d193-4cc9-b351-99906754a03b")
  expect_equal(nrow(cc), 1)
  expect_equal(cc$usageKey,"V2")
  expect_equal(cc$matchType[1], "HIGHERRANK")
  
  expect_is(bb, "tbl")
  expect_is(bb, "tbl_df")
  expect_is(bb, "data.frame")
  expect_equal(bb$verbatim_name[1], "Calopteryx")
  expect_equal(bb$verbatim_checklistKey[1], 
               "7ddf754f-d193-4cc9-b351-99906754a03b")
  expect_equal(nrow(bb), 1)
  expect_equal(bb$usageKey,"V2")
  expect_equal(bb$verbatim_usageKey, "V2")
  
  expect_is(dd, "tbl")
  expect_is(dd, "tbl_df")
  expect_is(dd, "data.frame")
  expect_equal(dd$verbatim_genericName[1], "Agra")
  expect_equal(dd$verbatim_specificEpithet[1], "schwarzeneggeri")
  expect_equal(dd$verbatim_scientificNameAuthorship[1], "Erwin, 2002")
  expect_equal(nrow(dd), 1)
  expect_equal(dd$scientificName[1], "Agra schwarzeneggeri Erwin, 2002")
  
})

test_that("name_backbone verbose=TRUE", {
  vcr::use_cassette("name_backbone_verbose_true", {
    tt <- name_backbone(name = "Calopteryx",rank="GENUS")
    vv <- name_backbone(name = "Calopteryx",rank="GENUS",verbose=TRUE)
  })
  expect_is(vv, "tbl")
  expect_is(vv, "tbl_df")
  expect_is(vv, "data.frame")
  expect_equal(vv$verbatim_name[1], "Calopteryx")
  expect_equal(vv$verbatim_rank[1], "GENUS")
  expect_true(all(vv$verbatim_name == "Calopteryx"))
  expect_true(nrow(vv) > nrow(tt))
})





