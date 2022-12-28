context("name_backbone_checklist")

test_that("name_backbone_checklist good data", {
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
    ), scientificName = c(
      NA,
      "Cirsium arvense (L.) Scop.", # a plant
      "Calopteryx splendens (Harris, 1780)", # an insect
      "Puma concolor (Linnaeus, 1771)", # a big cat
      "Ceylonosticta alwisi (Priyadarshana & Wijewardhane, 2016)", # newly discovered insect 
      "Puma concuolor (Linnaeus, 1771)", # a mis-spelled big cat
      "Fake species (John Waller 2021)", # a fake species
      "Calopteryx", # Just a Genus   
      "Hymenochaete fuliginosa (Fr.) Lév.", # name with special character
      "Aleurodiscus amorphus (Pers.) J. Schröt.", # name with special character
      "dog [brackets break matching]"
    ))

  # vcr does not seem to work with async requests  
  # data.frame
  tt <- name_backbone_checklist(name_data = name_data)
  vv <- name_backbone_checklist(name_data = name_data,verbose=TRUE)
  # vector
  ttt <- name_backbone_checklist(name_data = name_data$name) 
  vvv <- name_backbone_checklist(name_data = name_data$name,verbose=TRUE)
  # one column
  tttt <- name_backbone_checklist(name_data = name_data["name"]) 
  vvvv <- name_backbone_checklist(name_data = name_data["name"],verbose=TRUE)
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
  expect_is(tt$usageKey, "integer")
  expect_is(tt$verbatim_name, "character")
  expect_equal(nrow(tt), 11)
  expect_true(all(tt$status == "ACCEPTED" | is.na(tt$status)))
  expect_true(is.numeric(tt$verbatim_index))
  expect_true(!is.unsorted(tt$verbatim_index))
  
  expect_is(vv, "tbl")
  expect_is(vv, "tbl_df")
  expect_is(vv, "data.frame")
  expect_is(vv$usageKey, "integer")
  expect_true(nrow(vv) > nrow(tt))
  expect_true(is.numeric(vv$verbatim_index))
  expect_true(!is.unsorted(vv$verbatim_index))
  
  # vector
  expect_is(ttt, "tbl")
  expect_is(ttt, "tbl_df")
  expect_is(ttt, "data.frame")
  expect_is(ttt$usageKey, "integer")
  expect_is(ttt$verbatim_name, "character")
  expect_equal(nrow(ttt), 11)
  expect_true(all(ttt$status == "ACCEPTED" | is.na(ttt$status)))
  expect_true(is.numeric(ttt$verbatim_index))
  expect_true(!is.unsorted(ttt$verbatim_index))
  
  expect_is(vvv, "tbl")
  expect_is(vvv, "tbl_df")
  expect_is(vvv, "data.frame")
  expect_is(vvv$usageKey, "integer")
  expect_true(nrow(vvv) > nrow(ttt))
  expect_true(is.numeric(vvv$verbatim_index))
  expect_true(!is.unsorted(vvv$verbatim_index))
  
  # one column data.frame
  expect_is(tttt, "tbl")
  expect_is(tttt, "tbl_df")
  expect_is(tttt, "data.frame")
  expect_is(tttt$usageKey, "integer")
  expect_is(tttt$verbatim_name, "character")
  expect_equal(nrow(tttt), 11)
  expect_true(all(tttt$status == "ACCEPTED" | is.na(tttt$status)))
  expect_true(is.numeric(tttt$verbatim_index))
  expect_true(!is.unsorted(tttt$verbatim_index))

  expect_is(vvvv, "tbl")
  expect_is(vvvv, "tbl_df")
  expect_is(vvvv, "data.frame")
  expect_is(vvvv$usageKey, "integer")
  expect_true(nrow(vvvv) > nrow(tttt))
  
  # one column that is not an alias 
  expect_is(ttttt, "tbl")
  expect_is(ttttt, "tbl_df")
  expect_is(ttttt, "data.frame")
  expect_is(ttttt$usageKey, "integer")
  expect_is(ttttt$verbatim_name, "character")
  expect_equal(nrow(ttttt), 11)
  expect_true(all(ttttt$status == "ACCEPTED" | is.na(ttttt$status)))
  expect_true(is.numeric(ttttt$verbatim_index))
  expect_true(!is.unsorted(ttttt$verbatim_index))
  
  expect_is(vvvvv, "tbl")
  expect_is(vvvvv, "tbl_df")
  expect_is(vvvvv, "data.frame")
  expect_is(vvvvv$usageKey, "integer")
  expect_true(nrow(vvvvv) > nrow(ttttt))
  expect_true(is.numeric(vvvvv$verbatim_index))
  expect_true(!is.unsorted(vvvvv$verbatim_index))
  
  # aliased name multiple columns
  expect_is(tttttt, "tbl")
  expect_is(tttttt, "tbl_df")
  expect_is(tttttt, "data.frame")
  expect_is(tttttt$usageKey, "integer")
  expect_is(tttttt$verbatim_name, "character")
  expect_equal(nrow(tttttt), 11)
  expect_true(all(tttttt$status == "ACCEPTED" | is.na(tttttt$status)))
  expect_true(is.numeric(tttttt$verbatim_index))
  expect_true(!is.unsorted(tttttt$verbatim_index))
  
  expect_is(vvvvvv, "tbl")
  expect_is(vvvvvv, "tbl_df")
  expect_is(vvvvvv, "data.frame")
  expect_is(vvvvvv$usageKey, "integer")
  expect_true(nrow(vvvvvv) > nrow(tttttt))
  expect_true(is.numeric(vvvvvv$verbatim_index))
  expect_true(!is.unsorted(vvvvvv$verbatim_index))
  
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
  expect_error(name_backbone_checklist(name_data = data.frame(1)),"The name column should be class character.")
  
  # name column is a factor
  name_data_factor = name_data
  name_data_factor$name<-as.factor(name_data_factor$name)
  expect_error(name_backbone_checklist(name_data = name_data_factor),"All taxonomic columns should be character.")
  name_data_factor$name<-as.numeric(name_data_factor$name)
  expect_error(name_backbone_checklist(name_data = name_data_factor),"All taxonomic columns should be character.")
  
  # just missing names
  ff <- name_backbone_checklist(name_data = c("fake name 1","fake name 2"))
  zz <- name_backbone_checklist(name_data = c("fake name 1","fake name 2"),verbose=TRUE)
  expect_equal(colnames(ff), c("confidence","matchType", "synonym", "verbatim_name","verbatim_index"))
  expect_equal(colnames(zz), c("confidence","matchType", "synonym", "is_alternative", "verbatim_name","verbatim_index"))
  expect_true(nrow(ff) == nrow(zz))
  expect_equal(unique(ff$matchType), "NONE")
  expect_equal(unique(zz$matchType), "NONE")
  expect_equal(nrow(ff),2)
  expect_equal(nrow(zz),2)
  
  # just one missing name
  fff <- name_backbone_checklist(name_data = name_data[1,])
  zzz <- name_backbone_checklist(name_data = name_data[1,],verbose=TRUE)   
  expect_equal(colnames(fff), c("confidence","matchType", "synonym", "verbatim_name", "verbatim_kingdom","verbatim_index"))
  expect_equal(colnames(zzz), c("confidence","matchType", "synonym", "is_alternative", "verbatim_name","verbatim_kingdom","verbatim_index"))
  expect_true(nrow(fff) == nrow(zzz))
  expect_equal(unique(fff$matchType), "NONE")
  expect_equal(unique(zzz$matchType), "NONE")
  expect_equal(nrow(fff),1)
  expect_equal(nrow(zzz),1)
  
  })

test_that("name_backbone_checklist strict arg works as expected", {
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
  
    ff <- name_backbone_checklist(name_data)
    ss <- name_backbone_checklist(name_data,strict=TRUE)
    sv <- name_backbone_checklist(name_data,verbose=TRUE,strict=TRUE)
    
    # basic functionality 
    expect_is(ss, "tbl")
    expect_is(ss, "tbl_df")
    expect_is(ss, "data.frame")
    expect_true(is.numeric(ss$verbatim_index))
    expect_true(!is.unsorted(ss$verbatim_index))
    
    # basic functionality 
    expect_is(sv, "tbl")
    expect_is(sv, "tbl_df")
    expect_is(sv, "data.frame")
    expect_true(is.numeric(sv$verbatim_index))
    expect_true(!is.unsorted(sv$verbatim_index))
    
    # correct matchType is returned 
    expect_true(all(ff$matchType %in% c("NONE","EXACT","FUZZY","HIGHERRANK")))
    
    expect_true(all(ss$matchType %in% c("NONE","EXACT")))
    expect_false(all(ss$matchType %in% c("FUZZY","HIGHERRANK")))
    
    expect_true(all(sv$matchType %in% c("NONE","EXACT")))
    expect_false(all(sv$matchType %in% c("FUZZY","HIGHERRANK")))
    
    # More matchType NONE is returned for strict
    expect_true(nrow(ff[ff$matchType == "NONE",]) < nrow(ss[ss$matchType == "NONE",]))
    
    # More rows for verbose=true and strict=true
    expect_true(nrow(sv) > nrow(ss))
    expect_true(nrow(sv) > nrow(ff))
    
    
})

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
  expect_true(is.numeric(dd$verbatim_index))
  expect_true(!is.unsorted(dd$verbatim_index))
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
    expect_true(is.numeric(oo$verbatim_index))
    expect_true(!is.unsorted(oo$verbatim_index))
    expect_true(all(oo$verbatim_kingdom == "Animalia"))
})

test_that("name_backbone_checklist is_alternative works as expected", {
  skip_on_cran()
  skip_on_ci()
  
  ff <- name_backbone_checklist("Calopteryx",verbose=FALSE)
  expect_warning(ff$is_alternative, "Unknown or uninitialised column: `is_alternative`.")
  aa <- name_backbone_checklist("Calopteryx",verbose=TRUE)
  expect_true(is.logical(aa$is_alternative))
  expect_false(any(is.na(aa$is_alternative)))
  
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






