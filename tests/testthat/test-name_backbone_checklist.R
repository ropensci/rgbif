context("name_backbone_checklist")

test_that("name_backbone_checklist good data", {
  skip_on_cran()
  skip_on_ci()
  
  name_data <- data.frame(
    scientificName = c(
      NA, # missing value
      "Cirsium arvense (L.) Scop.", # a plant
      "Calopteryx splendens (Harris, 1780)", # an insect
      "Puma concolor (Linnaeus, 1771)", # a big cat
      "Ceylonosticta alwisi (Priyadarshana & Wijewardhane, 2016)", # newly discovered insect 
      "Puma concuolor (Linnaeus, 1771)", # a mis-spelled big cat
      "Fake species (John Waller 2021)", # a fake species
      "Calopteryx", # Just a Genus,
      "Hymenochaete fuliginosa (Fr.) Lév.", # name with special character
      "Aleurodiscus amorphus (Pers.) J. Schröt.", # name with special character
      "dog [brackets break matching]"
    ), description = c(
      "missing",
      "a plant",
      "an insect",
      "a big cat",
      "newly discovered insect",
      "a mis-spelled big cat",
      "a fake species",
      "just a GENUS",
      "special character",
      "special character",
      "square brackets"
    ), 
    kingdom = c(
      "missing",
      "Plantae",
      "Animalia",
      "Animalia",
      "Animalia",
      "Animalia",
      "Johnlia",
      "Animalia",
      "Fungi",
      "Fungi",
      "Animalia"
    ), Canonical_Name = c(
      "not known",
      "Cirsium arvense", 
      "Calopteryx splendens", 
      "Puma concolor", 
      "Ceylonosticta alwisi", 
      "Puma concuolor", 
      "Fake species",
      "Calopteryx",
      "Hymenochaete fuliginosa",
      "Aleurodiscus amorphus",
      "dog"
    ))

  # vcr does not work with async requests  
  # data.frame
  tt <- name_backbone_checklist(name_data = name_data)
  vv <- name_backbone_checklist(name_data = name_data,verbose=TRUE)
  # vector
  ttt <- name_backbone_checklist(name_data = name_data$scientificName) 
  vvv <- name_backbone_checklist(name_data = name_data$scientificName,verbose=TRUE)
  # one column
  tttt <- name_backbone_checklist(name_data = name_data["scientificName"]) 
  vvvv <- name_backbone_checklist(name_data = name_data["scientificName"],verbose=TRUE)
  # one column not aliased
  ttttt <- name_backbone_checklist(name_data = name_data["Canonical_Name"]) 
  vvvvv <- name_backbone_checklist(name_data = name_data["Canonical_Name"],verbose=TRUE)
  # aliased name multiple columns
  tttttt <- name_backbone_checklist(name_data = name_data[c("scientificName","kingdom")]) 
  vvvvvv <- name_backbone_checklist(name_data = name_data[c("scientificName","kingdom")],verbose=TRUE)
  
  # data.frame
  expect_is(tt, "tbl")
  expect_is(tt, "tbl_df")
  expect_is(tt, "data.frame")
  expect_is(tt$verbatim_name, "character")
  expect_equal(nrow(tt), 11)
  expect_true(all(tt$status == "ACCEPTED" | is.na(tt$status)))

  expect_is(vv, "tbl")
  expect_is(vv, "tbl_df")
  expect_is(vv, "data.frame")
  expect_true(nrow(vv) > nrow(tt))

  # vector
  expect_is(ttt, "tbl")
  expect_is(ttt, "tbl_df")
  expect_is(ttt, "data.frame")
  expect_is(ttt$verbatim_name, "character")
  expect_equal(nrow(ttt), 11)
  expect_true(all(ttt$status == "ACCEPTED" | is.na(ttt$status)))

  expect_is(vvv, "tbl")
  expect_is(vvv, "tbl_df")
  expect_is(vvv, "data.frame")
  expect_true(nrow(vvv) > nrow(ttt))

  # one column data.frame
  expect_is(tttt, "tbl")
  expect_is(tttt, "tbl_df")
  expect_is(tttt, "data.frame")
  expect_is(tttt$verbatim_name, "character")
  expect_equal(nrow(tttt), 11)
  expect_true(all(tttt$status == "ACCEPTED" | is.na(tttt$status)))

  expect_is(vvvv, "tbl")
  expect_is(vvvv, "tbl_df")
  expect_is(vvvv, "data.frame")
  expect_true(nrow(vvvv) > nrow(tttt))
  
  # one column that is not an alias 
  expect_is(ttttt, "tbl")
  expect_is(ttttt, "tbl_df")
  expect_is(ttttt, "data.frame")
  expect_is(ttttt$verbatim_name, "character")
  expect_equal(nrow(ttttt), 11)
  expect_true(all(ttttt$status == "ACCEPTED" | is.na(ttttt$status)))

  expect_is(vvvvv, "tbl")
  expect_is(vvvvv, "tbl_df")
  expect_is(vvvvv, "data.frame")
  expect_true(nrow(vvvvv) > nrow(ttttt))

  # aliased name multiple columns
  expect_is(tttttt, "tbl")
  expect_is(tttttt, "tbl_df")
  expect_is(tttttt, "data.frame")
  expect_is(tttttt$verbatim_name, "character")
  expect_equal(nrow(tttttt), 11)
  expect_true(all(tttttt$status == "ACCEPTED" | is.na(tttttt$status)))

  expect_is(vvvvvv, "tbl")
  expect_is(vvvvvv, "tbl_df")
  expect_is(vvvvvv, "data.frame")
  expect_true(nrow(vvvvvv) > nrow(tttttt))

  })
  
test_that("name_backbone_checklist bad or weird data", {
  skip_on_cran()
  skip_on_ci()
      
    name_data <- data.frame(
      name = c(
        NA, # missing value
        "Cirsium arvense (L.) Scop.", # a plant
        "Calopteryx splendens (Harris, 1780)", # an insect
        "Puma concolor (Linnaeus, 1771)", # a big cat
        "Ceylonosticta alwisi (Priyadarshana & Wijewardhane, 2016)", # newly discovered insect 
        "Puma concuolor (Linnaeus, 1771)", # a mis-spelled big cat
        "Fake species (John Waller 2021)", # a fake species
        "Calopteryx" # Just a Genus   
      ), description = c(
        "missing",
        "a plant",
        "an insect",
        "a big cat",
        "newly discovered insect",
        "a mis-spelled big cat",
        "a fake species",
        "just a GENUS"
      ), 
      kingdom = c(
        "missing",
        "Plantae",
        "Animalia",
        "Animalia",
        "Animalia",
        "Animalia",
        "Johnlia",
        "Animalia"
      ), Canonical_Name = c(
        "not known",
        "Cirsium arvense", 
        "Calopteryx splendens", 
        "Puma concolor", 
        "Ceylonosticta alwisi", 
        "Puma concuolor", 
        "Fake species",
        "Calopteryx"
      ), scientificName = c(
        NA,
        "Cirsium arvense (L.) Scop.", # a plant
        "Calopteryx splendens (Harris, 1780)", # an insect
        "Puma concolor (Linnaeus, 1771)", # a big cat
        "Ceylonosticta alwisi (Priyadarshana & Wijewardhane, 2016)", # newly discovered insect 
        "Puma concuolor (Linnaeus, 1771)", # a mis-spelled big cat
        "Fake species (John Waller 2021)", # a fake species
        "Calopteryx" # Just a Genus   
      ))
    
  # bad data 
  expect_error(name_backbone_checklist(name_data = NULL),"You forgot to supply your checklist data.frame or vector to name_data.")
  expect_error(name_backbone_checklist(name_data = 1),"name_data should be class character.")
  expect_error(name_backbone_checklist(name_data = data.frame(1)),"The scientificName column should be class character.")
  
  # just missing names
  ff <- name_backbone_checklist(name_data = c("fake name 1","fake name 2"))
  zz <- name_backbone_checklist(name_data = c("fake name 1","fake name 2"),verbose=TRUE)
  expect_true(nrow(ff) == nrow(zz))
  expect_equal(unique(ff$matchType), "NONE")
  expect_equal(unique(zz$matchType), "NONE")
  expect_equal(nrow(ff),2)
  expect_equal(nrow(zz),2)
  
  # just one missing name
  fff <- name_backbone_checklist(name_data = name_data[1,])
  zzz <- name_backbone_checklist(name_data = name_data[1,],verbose=TRUE)   
  # expect_equal(colnames(fff), c("confidence","matchType", "synonym", "verbatim_name", "verbatim_kingdom","verbatim_index"))
  # expect_equal(colnames(zzz), c("confidence","matchType", "synonym", "is_alternative", "verbatim_name","verbatim_kingdom","verbatim_index"))
  expect_true(nrow(fff) == nrow(zzz))
  expect_equal(unique(fff$matchType), "NONE")
  expect_equal(unique(zzz$matchType), "NONE")
  expect_equal(nrow(fff),1)
  expect_equal(nrow(zzz),1)
  
  })

# strict arg might not work until switch to v2

test_that("name_backbone_checklist default values works as expected", {
  skip_on_cran()
  skip_on_ci()
  
  # basic functionality 
  gg <- name_backbone_checklist(c("Cirsium arvense (L.) Scop.", 
                                 "Calopteryx splendens (Harris, 1780)"))
  expect_warning(gg$verbatim_kingdom, "Unknown or uninitialised column: `verbatim_kingdom`.")
  
  dd <- name_backbone_checklist(c("Cirsium arvense (L.) Scop.", 
                                  "Calopteryx splendens (Harris, 1780)"),
                                kingdom = "Animalia")
  expect_is(dd, "tbl")
  expect_is(dd, "tbl_df")
  expect_is(dd, "data.frame")
  expect_true(all(dd$verbatim_kingdom == "Animalia"))
  
  rr <- name_backbone_checklist(c("Cirsium arvense (L.) Scop.", 
                                  "Calopteryx splendens (Harris, 1780)"),
                                kingdom = "Animalia",rank="SPECIES")
  
  expect_true(all(rr$verbatim_kingdom == "Animalia"))
  expect_true(all(rr$verbatim_rank == "SPECIES"))
  
  # multiple default values 
  mm <- name_backbone_checklist(c("Cirsium arvense (L.) Scop.", 
                                  "Calopteryx splendens (Harris, 1780)"),
                                kingdom = c("Plantea","Animalia"),rank="SPECIES")
  
  expect_true(all(mm$verbatim_kingdom %in% c("Plantea","Animalia")))
  
  # overwrite existing values in name_data
  name_data <- data.frame(
    name = c(
      NA, # missing value
      "Cirsium arvense (L.) Scop.", # a plant
      "Calopteryx splendens (Harris, 1780)", # an insect
      "Puma concolor (Linnaeus, 1771)", # a big cat
      "Ceylonosticta alwisi (Priyadarshana & Wijewardhane, 2016)", # newly discovered insect 
      "Puma concuolor (Linnaeus, 1771)", # a mis-spelled big cat
      "Fake species (John Waller 2021)", # a fake species
      "Calopteryx", # Just a Genus
      "Calopteryx fake" # make higher rank match
    ), description = c(
      "missing",
      "a plant",
      "an insect",
      "a big cat",
      "newly discovered insect",
      "a mis-spelled big cat",
      "a fake species",
      "just a GENUS",
      "higherrank match"
    ), 
    kingdom = c(
      "missing",
      "Plantae",
      "Animalia",
      "Animalia",
      "Animalia",
      "Animalia",
      "Johnlia",
      "Animalia",
      "Animalia"
    ), Canonical_Name = c(
      "not known",
      "Cirsium arvense", 
      "Calopteryx splendens", 
      "Puma concolor", 
      "Ceylonosticta alwisi", 
      "Puma concuolor", 
      "Fake species",
      "Calopteryx",
      "Calopteryx fake"
    ), scientificName = c(
      NA,
      "Cirsium arvense (L.) Scop.", # a plant
      "Calopteryx splendens (Harris, 1780)", # an insect
      "Puma concolor (Linnaeus, 1771)", # a big cat
      "Ceylonosticta alwisi (Priyadarshana & Wijewardhane, 2016)", # newly discovered insect 
      "Puma concuolor (Linnaeus, 1771)", # a mis-spelled big cat
      "Fake species (John Waller 2021)", # a fake species
      "Calopteryx", # Just a Genus
      "Calopteryx fake Waller 2022"
    ))
  
    expect_message((oo <- name_backbone_checklist(name_data,kingdom = "Animalia")),
                   "Default values found, over-writing : kingdom")
    expect_is(oo, "tbl")
    expect_is(oo, "tbl_df")
    expect_is(oo, "data.frame")
    expect_true(all(oo$verbatim_kingdom == "Animalia"))
})

test_that("name_backbone_checklist is_alternative works as expected", {
  skip_on_cran()
  skip_on_ci()

  ff <- name_backbone_checklist("Calopteryx",verbose=FALSE)
  aa <- name_backbone_checklist("Calopteryx",verbose=TRUE)
  
  expect_false(any(is.na(ff$is_alternative)))
  expect_true(is.logical(ff$is_alternative))
  expect_true(is.logical(aa$is_alternative))
  expect_false(any(is.na(aa$is_alternative)))

})

test_that("name_backbone_checklist returns the same as name_backbone", {
  skip_on_cran()
  skip_on_ci()
  
  bb <- name_backbone("Aeonium canariense (L.) Webb & Berthel. subsp. latifolium (Burchard) Bañares")$usageKey
  cc <- name_backbone_checklist("Aeonium canariense (L.) Webb & Berthel. subsp. latifolium (Burchard) Bañares")$usageKey
  
  expect_equal(bb, cc)
  
})

test_that("name_backbone_checklist works with v2 args", {
  skip_on_cran()
  skip_on_ci()
  
  cc <- name_backbone_checklist(name_data = 
                      c("Aves","Calopteryx splendens", "Animalia"),
                      checklistKey="7ddf754f-d193-4cc9-b351-99906754a03b")
  
  
  bb <- name_backbone_checklist(name_data =  
  data.frame(scientificName = 
               c("Aves","Calopteryx splendens", "Animalia"),
             checklistKey="7ddf754f-d193-4cc9-b351-99906754a03b"))
  
  
  expect_is(cc, "tbl")
  expect_is(cc, "tbl_df")
  expect_is(cc, "data.frame")
  expect_equal(nrow(cc), 3)
  expect_equal(cc$matchType, c("HIGHERRANK", "EXACT", "HIGHERRANK"))
  expect_equal(cc$verbatim_name, 
               c("Aves", "Calopteryx splendens", "Animalia"))
  expect_equal(cc$kingdom, c("Animalia", "Animalia", "Animalia"))
  expect_equal(cc$rank, c("CLASS", "SPECIES", "KINGDOM"))
  
  expect_is(bb, "tbl")
  expect_is(bb, "tbl_df")
  expect_is(bb, "data.frame")
  expect_equal(nrow(bb), 3)
  expect_equal(cc$matchType, bb$matchType)
  expect_equal(cc$verbatim_name, bb$verbatim_name)
  expect_equal(cc$kingdom, bb$kingdom)
  expect_equal(cc$rank, bb$rank)
  expect_equal(cc$usageKey, bb$usageKey)
  
})


# test_that("test status codes", {
#   skip_on_cran()
#   skip_on_ci()
# 
#   urls_200 = c("https://httpbin.org/json","https://httpbin.org/json")
#   expect_length(gbif_async_get(urls = urls_200),2)
#   
#   urls_204 = c("https://httpbin.org/status/204","https://httpbin.org/json")
#   expect_error(gbif_async_get(urls = urls_204),"Status: 204 - not found")
#                
#   urls_500 = c("https://httpbin.org/json","https://httpbin.org/status/500")
#   expect_error(gbif_async_get(urls = urls_500),"500 - Server error")
#   
#   urls_503 = c("https://httpbin.org/json","https://httpbin.org/status/503")
#   expect_error(gbif_async_get(urls = urls_503),"503 - Service Unavailable")
#   
# })

test_that("name_backbone_checklist bucket_size and sleep ", {
  skip_on_cran()
  skip_on_ci()

  names <- name_lookup(limit=100)$canonicalName
  start <- proc.time()
  ss <- name_backbone_checklist(name_data = names,
                                bucket_size = 10,
                                sleep = 10)  
  end <- proc.time()
  time1 <- end - start

  start <- proc.time()
  mm <- name_backbone_checklist(name_data = names,
                                bucket_size = 10,
                                sleep = 1)  
  end <- proc.time()
  time2 <- end - start

  expect_equal(nrow(ss), nrow(mm))
  expect_is(ss, "data.frame")
  expect_is(mm, "data.frame")
  expect_true(time1['elapsed'] > time2['elapsed'] )

})

