#' @examples \dontrun{
#' # Search by species name, using \code{\link{name_backbone}} first to get key
#' (key <- name_suggest(q='Helianthus annuus', rank='species')$key[1])
#' occ_search(taxonKey=key, limit=2)
#'
#' # Return 20 results, this is the default by the way
#' occ_search(taxonKey=key, limit=20)
#'
#' # Return just metadata for the search
#' occ_search(taxonKey=key, limit=0, return='meta')
#'
#' # Instead of getting a taxon key first, you can search for a name directly
#' ## However, note that using this approach (with \code{scientificName="..."})
#' ## you are getting synonyms too. The results for using \code{scientifcName} and
#' ## \code{taxonKey} parameters are the same in this case, but I wouldn't be surprised if for some
#' ## names they return different results
#' occ_search(scientificName = 'Ursus americanus')
#' key <- name_backbone(name = 'Ursus americanus', rank='species')$usageKey
#' occ_search(taxonKey = key)
#'
#' # Search by dataset key
#' occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a', return='data', limit=20)
#'
#' # Search by catalog number
#' occ_search(catalogNumber="49366", limit=20)
#' ## separate requests: use a vector of strings
#' occ_search(catalogNumber=c("49366","Bird.27847588"), limit=10)
#' ## one request, many instances of same parameter: use semi-colon sep. string
#' occ_search(catalogNumber="49366;Bird.27847588", limit=10)
#'
#' # Get all data, not just lat/long and name
#' occ_search(taxonKey=key, fields='all', limit=20)
#'
#' # Or get specific fields. Note that this isn't done on GBIF's side of things. This
#' # is done in R, but before you get the return object, so other fields are garbage
#' # collected
#' occ_search(taxonKey=key, fields=c('name','basisOfRecord','protocol'), limit=20)
#'
#' # Use paging parameters (limit and start) to page. Note the different results
#' # for the two queries below.
#' occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a',start=10,limit=5,
#'    return="data")
#' occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a',start=20,limit=5,
#'    return="data")
#'
#' # Many dataset keys
#' ## separate requests: use a vector of strings
#' occ_search(datasetKey=c("50c9509d-22c7-4a22-a47d-8c48425ef4a7",
#'    "7b5d6a48-f762-11e1-a439-00145eb45e9a"), limit=20)
#' ## one request, many instances of same parameter: use semi-colon sep. string
#' v="50c9509d-22c7-4a22-a47d-8c48425ef4a7;7b5d6a48-f762-11e1-a439-00145eb45e9a"
#' occ_search(datasetKey = v, limit=20)
#'
#' # Occurrence data: lat/long data, and associated metadata with occurrences
#' ## If return='data' the output is a data.frame of all data together
#' ## for easy manipulation
#' occ_search(taxonKey=key, return='data', limit=20)
#'
#' # Taxonomic hierarchy data
#' ## If return='meta' the output is a list of the hierarch for each record
#' occ_search(taxonKey=key, return='hier', limit=10)
#'
#' # Search by recorder
#' occ_search(recordedBy="smith", limit=20)
#'
#' # Many collector names
#' occ_search(recordedBy=c("smith","BJ Stacey"), limit=20)
#'
#' # Pass in curl options for extra fun
#' occ_search(taxonKey=2433407, limit=20, return='hier',
#'   curlopts=list(verbose=TRUE))
#' occ_search(taxonKey=2433407, limit=20, return='hier',
#'   curlopts = list(
#'     noprogress = FALSE,
#'     progressfunction = function(down, up) {
#'       cat(sprintf("up: %d | down %d\n", up, down))
#'       return(TRUE)
#'     }
#'   )
#' )
#' # occ_search(taxonKey=2433407, limit=20, return='hier',
#' #   curlopts = list(timeout_ms = 1))
#'
#' # Search for many species
#' splist <- c('Cyanocitta stelleri', 'Junco hyemalis', 'Aix sponsa')
#' keys <- sapply(splist, function(x) name_suggest(x)$key[1], USE.NAMES=FALSE)
#' ## separate requests: use a vector of strings
#' occ_search(taxonKey = keys, limit=5)
#' ## one request, many instances of same parameter: use semi-colon sep. string
#' occ_search(taxonKey = paste0(keys, collapse = ";"), limit=5)
#'
#' # Search using a synonym name
#' #  Note that you'll see a message printing out that the accepted name will be used
#' occ_search(scientificName = 'Pulsatilla patens', fields = c('name','scientificName'), limit=5)
#'
#' # Search on latitidue and longitude
#' occ_search(decimalLatitude=48, decimalLongitude=10)
#'
#' # Search on a bounding box
#' ## in well known text format
#' ### polygon
#' occ_search(geometry='POLYGON((30.1 10.1,40 40,20 40,10 20,30.1 10.1))', limit=20)
#' ### multipolygon
#' wkt <- 'MULTIPOLYGON(((-123 38,-116 38,-116 43,-123 43,-123 38)),
#'    ((-97 41,-93 41,-93 45,-97 45,-97 41)))'
#' occ_search(geometry = gsub("\n\\s+", "", wkt), limit = 20)
#'
#' ## taxonKey + WKT
#' key <- name_suggest(q='Aesculus hippocastanum')$key[1]
#' occ_search(taxonKey=key, geometry='POLYGON((30.1 10.1,40 40,20 40,10 20,30.1 10.1))',
#'    limit=20)
#' ## or using bounding box, converted to WKT internally
#' occ_search(geometry=c(-125.0,38.4,-121.8,40.9), limit=20)
#'
#' # Search on a long WKT string - too long for a GBIF search API request
#' ## We internally convert your WKT string to a bounding box
#' ##  then do the query
#' ##  then clip the results down to just those in the original polygon
#' ##  - Alternatively, you can set the parameter `geom_big="bbox"`
#' ##  - An additional alternative is to use the GBIF download API, see ?downloads
#' wkt <- "POLYGON((-9.178796777343678 53.22769021556159,
#' -12.167078027343678 51.56540789297837,
#' -12.958093652343678 49.78333685689162,-11.024499902343678 49.21251756301334,
#' -12.079187402343678 46.68179685941719,-15.067468652343678 45.83103608186854,
#' -15.770593652343678 43.58271629699817,-15.067468652343678 41.57676278827219,
#' -11.815515527343678 40.44938999172728,-12.958093652343678 37.72112962230871,
#' -11.639734277343678 36.52987439429357,-8.299890527343678 34.96062625095747,
#' -8.739343652343678 32.62357394385735,-5.223718652343678 30.90497915232165,
#' 1.1044063476563224 31.80562077746643,1.1044063476563224 30.754036557416256,
#' 6.905187597656322 32.02942785462211,5.147375097656322 32.99292810780193,
#' 9.629796972656322 34.164474406524725,10.860265722656322 32.91918014319603,
#' 14.551671972656322 33.72700959356651,13.409093847656322 34.888564192275204,
#' 16.748937597656322 35.104560368110114,19.561437597656322 34.81643887792552,
#' 18.594640722656322 36.38849705969625,22.989171972656322 37.162874858929854,
#' 19.825109472656322 39.50651757842751,13.760656347656322 38.89353140585116,
#' 14.112218847656322 42.36091601976124,10.596593847656322 41.11488736647705,
#' 9.366125097656322 43.70991402658437,5.059484472656322 42.62015372417812,
#' 2.3348750976563224 45.21526500321446,-0.7412967773436776 46.80225692528942,
#' 6.114171972656322 47.102229890207894,8.047765722656322 45.52399303437107,
#' 12.881750097656322 48.22681126957933,9.190343847656322 48.693079457106684,
#' 8.750890722656322 50.68283120621287,5.059484472656322 50.40356146487845,
#' 4.268468847656322 52.377558897655156,1.4559688476563224 53.28027243658647,
#' 0.8407344726563224 51.62000971578333,0.5770625976563224 49.32721423860726,
#' -2.5869999023436776 49.49875947592088,-2.4991092773436776 51.18135535408638,
#' -2.0596561523436776 52.53822562473851,-4.696374902343678 51.67454591918756,
#' -5.311609277343678 50.009802108095776,-6.629968652343678 48.75106196817059,
#' -7.684656152343678 50.12263634382465,-6.190515527343678 51.83776110910459,
#' -5.047937402343678 54.267098895684235,-6.893640527343678 53.69860705549198,
#' -8.915124902343678 54.77719740243195,-12.079187402343678 54.52294465763567,
#' -13.573328027343678 53.437631551347174,
#' -11.288171777343678 53.48995552517918,
#' -9.178796777343678 53.22769021556159))"
#' wkt <- gsub("\n", " ", wkt)
#'
#' #### Default option with large WKT string fails
#' # res <- occ_search(geometry = wkt)
#'
#' #### if WKT too long, with 'geom_big=bbox': makes into bounding box
#' res <- occ_search(geometry = wkt, geom_big = "bbox")$data
#' library("rgeos")
#' library("sp")
#' wktsp <- readWKT(wkt)
#' plot(wktsp)
#' coordinates(res) <- ~decimalLongitude+decimalLatitude
#' points(res)
#'
#' #### Or, use 'geom_big=axe'
#' (res <- occ_search(geometry = wkt, geom_big = "axe"))
#' ##### manipulate essentially number of polygons that result, so number of requests
#' ###### default geom_size is 40
#' ###### fewer calls
#' (res <- occ_search(geometry = wkt, geom_big = "axe", geom_size=50))
#' ###### more calls
#' (res <- occ_search(geometry = wkt, geom_big = "axe", geom_size=30))
#'
#'
#' # Search on country
#' occ_search(country='US', fields=c('name','country'), limit=20)
#' isocodes[grep("France", isocodes$name),"code"]
#' occ_search(country='FR', fields=c('name','country'), limit=20)
#' occ_search(country='DE', fields=c('name','country'), limit=20)
#' ### separate requests: use a vector of strings
#' occ_search(country=c('US','DE'), limit=20)
#' ### one request, many instances of same parameter: use semi-colon sep. string
#' occ_search(country = 'US;DE', limit=20)
#'
#' # Get only occurrences with lat/long data
#' occ_search(taxonKey=key, hasCoordinate=TRUE, limit=20)
#'
#' # Get only occurrences that were recorded as living specimens
#' occ_search(taxonKey=key, basisOfRecord="LIVING_SPECIMEN", hasCoordinate=TRUE, limit=20)
#'
#' # Get occurrences for a particular eventDate
#' occ_search(taxonKey=key, eventDate="2013", limit=20)
#' occ_search(taxonKey=key, year="2013", limit=20)
#' occ_search(taxonKey=key, month="6", limit=20)
#'
#' # Get occurrences based on depth
#' key <- name_backbone(name='Salmo salar', kingdom='animals')$speciesKey
#' occ_search(taxonKey=key, depth="5", limit=20)
#'
#' # Get occurrences based on elevation
#' key <- name_backbone(name='Puma concolor', kingdom='animals')$speciesKey
#' occ_search(taxonKey=key, elevation=50, hasCoordinate=TRUE, limit=20)
#'
#' # Get occurrences based on institutionCode
#' occ_search(institutionCode="TLMF", limit=20)
#' ### separate requests: use a vector of strings
#' occ_search(institutionCode=c("TLMF","ArtDatabanken"), limit=20)
#' ### one request, many instances of same parameter: use semi-colon sep. string
#' occ_search(institutionCode = "TLMF;ArtDatabanken", limit=20)
#'
#' # Get occurrences based on collectionCode
#' occ_search(collectionCode="Floristic Databases MV - Higher Plants", limit=20)
#' occ_search(collectionCode=c("Floristic Databases MV - Higher Plants","Artport"))
#'
#' # Get only those occurrences with spatial issues
#' occ_search(taxonKey=key, hasGeospatialIssue=TRUE, limit=20)
#'
#' # Search using a query string
#' # occ_search(search = "kingfisher", limit=20)
#' ## spell check - only works with the `search` parameter
#' ### spelled correctly - same result as above call
#' # occ_search(search = "kingfisher", limit=20, spellCheck = TRUE)
#' ### spelled incorrectly - stops with suggested spelling
#' # occ_search(search = "kajsdkla", limit=20, spellCheck = TRUE)
#' ### spelled incorrectly - stops with many suggested spellings
#' ###   and number of results for each
#' # occ_search(search = "helir", limit=20, spellCheck = TRUE)
#'
#'
#'
#' # search on repatriated - doesn't work right now
#' # occ_search(repatriated = "")
#'
#' # search on phylumKey
#' occ_search(phylumKey = 7707728, limit = 5)
#'
#' # search on kingdomKey
#' occ_search(kingdomKey = 1, limit = 5)
#'
#' # search on classKey
#' occ_search(classKey = 216, limit = 5)
#'
#' # search on orderKey
#' occ_search(orderKey = 7192402, limit = 5)
#'
#' # search on familyKey
#' occ_search(familyKey = 3925, limit = 5)
#'
#' # search on genusKey
#' occ_search(genusKey = 1935496, limit = 5)
#'
#' # search on establishmentMeans
#' occ_search(establishmentMeans = "INVASIVE", limit = 5)
#' occ_search(establishmentMeans = "NATIVE", limit = 5)
#' occ_search(establishmentMeans = "UNCERTAIN", limit = 5)
#'
#' # search on protocol
#' occ_search(protocol = "DIGIR", limit = 5)
#'
#' # search on license
#' occ_search(license = "CC_BY_4_0", limit = 5)
#'
#' # search on organismId
#' occ_search(organismId = "100", limit = 5)
#'
#' # search on publishingOrg
#' occ_search(publishingOrg = "28eb1a3f-1c15-4a95-931a-4af90ecb574d", limit = 5)
#'
#' # search on stateProvince
#' occ_search(stateProvince = "California", limit = 5)
#'
#' # search on waterBody
#' occ_search(waterBody = "AMAZONAS BASIN, RIO JURUA", limit = 5)
#'
#' # search on locality
#' res <- occ_search(locality = c("Trondheim", "Hovekilen"), limit = 5)
#' res$Trondheim$data
#' res$Hovekilen$data
#'
#'
#'
#' # Range queries
#' ## See Detail for parameters that support range queries
#' occ_search(depth='50,100') # this is a range depth, with lower/upper limits in character string
#' occ_search(depth=c(50,100)) # this is not a range search, but does two searches for each depth
#'
#' ## Range search with year
#' occ_search(year='1999,2000', limit=20)
#'
#' ## Range search with latitude
#' occ_search(decimalLatitude='29.59,29.6')
#'
#' # Search by specimen type status
#' ## Look for possible values of the typeStatus parameter looking at the typestatus dataset
#' occ_search(typeStatus = 'allotype', fields = c('name','typeStatus'))
#'
#' # Search by specimen record number
#' ## This is the record number of the person/group that submitted the data, not GBIF's numbers
#' ## You can see that many different groups have record number 1, so not super helpful
#' occ_search(recordNumber = 1, fields = c('name','recordNumber','recordedBy'))
#'
#' # Search by last time interpreted: Date the record was last modified in GBIF
#' ## The lastInterpreted parameter accepts ISO 8601 format dates, including
#' ## yyyy, yyyy-MM, yyyy-MM-dd, or MM-dd. Range queries are accepted for lastInterpreted
#' occ_search(lastInterpreted = '2014-04-02', fields = c('name','lastInterpreted'))
#'
#' # Search by continent
#' ## One of africa, antarctica, asia, europe, north_america, oceania, or south_america
#' occ_search(continent = 'south_america', return = 'meta')
#' occ_search(continent = 'africa', return = 'meta')
#' occ_search(continent = 'oceania', return = 'meta')
#' occ_search(continent = 'antarctica', return = 'meta')
#'
#' # Search for occurrences with images
#' occ_search(mediaType = 'StillImage', return='media')
#' occ_search(mediaType = 'MovingImage', return='media')
#' occ_search(mediaType = 'Sound', return='media')
#'
#' # Query based on issues - see Details for options
#' ## one issue
#' occ_search(taxonKey=1, issue='DEPTH_UNLIKELY', fields =
#'    c('name','key','decimalLatitude','decimalLongitude','depth'))
#' ## two issues
#' occ_search(taxonKey=1, issue=c('DEPTH_UNLIKELY','COORDINATE_ROUNDED'))
#' # Show all records in the Arizona State Lichen Collection that cant be matched to the GBIF
#' # backbone properly:
#' occ_search(datasetKey='84c0e1a0-f762-11e1-a439-00145eb45e9a',
#'    issue=c('TAXON_MATCH_NONE','TAXON_MATCH_HIGHERRANK'))
#'
#' # Parsing output by issue
#' (res <- occ_search(geometry='POLYGON((30.1 10.1,40 40,20 40,10 20,30.1 10.1))', limit = 50))
#' ## what do issues mean, can print whole table, or search for matches
#' head(gbif_issues())
#' gbif_issues()[ gbif_issues()$code %in% c('cdround','cudc','gass84','txmathi'), ]
#' ## or parse issues in various ways
#' ### remove data rows with certain issue classes
#' library('magrittr')
#' res %>% occ_issues(gass84)
#' ### split issues into separate columns
#' res %>% occ_issues(mutate = "split")
#' ### expand issues to more descriptive names
#' res %>% occ_issues(mutate = "expand")
#' ### split and expand
#' res %>% occ_issues(mutate = "split_expand")
#' ### split, expand, and remove an issue class
#' res %>% occ_issues(-cudc, mutate = "split_expand")
#'
#' # If you try multiple values for two different parameters you are wacked on the hand
#' # occ_search(taxonKey=c(2482598,2492010), recordedBy=c("smith","BJ Stacey"))
#'
#' # Get a lot of data, here 1500 records for Helianthus annuus
#' # out <- occ_search(taxonKey=key, limit=1500, return="data")
#' # nrow(out)
#'
#' # If you pass in an invalid polygon you get hopefully informative errors
#'
#' ### the WKT string is fine, but GBIF says bad polygon
#' wkt <- 'POLYGON((-178.59375 64.83258989321493,-165.9375 59.24622380205539,
#' -147.3046875 59.065977905449806,-130.78125 51.04484764446178,-125.859375 36.70806354647625,
#' -112.1484375 23.367471303759686,-105.1171875 16.093320185359257,-86.8359375 9.23767076398516,
#' -82.96875 2.9485268155066175,-82.6171875 -14.812060061226388,-74.8828125 -18.849111862023985,
#' -77.34375 -47.661687803329166,-84.375 -49.975955187343295,174.7265625 -50.649460483096114,
#' 179.296875 -42.19189902447192,-176.8359375 -35.634976650677295,176.8359375 -31.835565983656227,
#' 163.4765625 -6.528187613695323,152.578125 1.894796132058301,135.703125 4.702353722559447,
#' 127.96875 15.077427674847987,127.96875 23.689804541429606,139.921875 32.06861069132688,
#' 149.4140625 42.65416193033991,159.2578125 48.3160811030533,168.3984375 57.019804336633165,
#' 178.2421875 59.95776046458139,-179.6484375 61.16708631440347,-178.59375 64.83258989321493))'
#'
#' # occ_search(geometry = gsub("\n", '', wkt))
#'
#' ### unable to parse due to last number pair needing two numbers, not one
#' # wkt <- 'POLYGON((-178.5 64.8,-165.9 59.2,-147.3 59.0,-130.7 51.0,-125.8))'
#' # occ_search(geometry = wkt)
#'
#' ### unable to parse due to unclosed string
#' # wkt <- 'POLYGON((-178.5 64.8,-165.9 59.2,-147.3 59.0,-130.7 51.0))'
#' # occ_search(geometry = wkt)
#' ### another of the same
#' # wkt <- 'POLYGON((-178.5 64.8,-165.9 59.2,-147.3 59.0,-130.7 51.0,-125.8 36.7))'
#' # occ_search(geometry = wkt)
#'
#' ### returns no results
#' # wkt <- 'LINESTRING(3 4,10 50,20 25)'
#' # occ_search(geometry = wkt)
#'
#' ### Apparently a point is allowed, but errors
#' # wkt <- 'POINT(45 -122)'
#' # occ_search(geometry = wkt)
#'
#' ## Faceting
#' x <- occ_search(facet = "country", limit = 0)
#' x$facets
#' x <- occ_search(facet = "establishmentMeans", limit = 10)
#' x$facets
#' x$data
#' x <- occ_search(facet = c("country", "basisOfRecord"), limit = 10)
#' x$data
#' x$facets
#' x$facets$country
#' x$facets$basisOfRecord
#' x$facets$basisOfRecord$count
#' x <- occ_search(facet = "country", facetMincount = 30000000L, limit = 10)
#' x$facets
#' x$data
#' # paging per each faceted variable
#' (x <- occ_search(
#'   facet = c("country", "basisOfRecord", "hasCoordinate"),
#'   country.facetLimit = 3,
#'   basisOfRecord.facetLimit = 6,
#'   limit = 0
#' ))
#' x$facets
#'
#'
#' # You can set limit=0 to get number of results found
#' occ_search(datasetKey = '7b5d6a48-f762-11e1-a439-00145eb45e9a', limit = 0)$meta
#' occ_search(scientificName = 'Ursus americanus', limit = 0)$meta
#' occ_search(scientificName = 'Ursus americanus', limit = 0, return = "meta")
#' }
