#' @examples \dontrun{
#' (key <- name_backbone(name='Encelia californica')$speciesKey)
#' occ_data(taxonKey = key, limit = 4)
#' (res <- occ_data(taxonKey = key, limit = 400))
#'
#' # Return 20 results, this is the default by the way
#' (key <- name_suggest(q='Helianthus annuus', rank='species')$key[1])
#' occ_data(taxonKey=key, limit=20)
#'
#' # Instead of getting a taxon key first, you can search for a name directly
#' ## However, note that using this approach (with \code{scientificName="..."})
#' ## you are getting synonyms too. The results for using \code{scientifcName}
#' ## and \code{taxonKey} parameters are the same in this case, but I wouldn't
#' ## be surprised if for some names they return different results
#' occ_data(scientificName = 'Ursus americanus', curlopts=list(verbose=TRUE))
#' key <- name_backbone(name = 'Ursus americanus', rank='species')$usageKey
#' occ_data(taxonKey = key)
#'
#' # Search by dataset key
#' occ_data(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a', limit=10)
#'
#' # Search by catalog number
#' occ_data(catalogNumber="49366", limit=10)
#' ## separate requests: use a vector of strings
#' occ_data(catalogNumber=c("49366","Bird.27847588"), limit=10)
#' ## one request, many instances of same parameter: use semi-colon sep. string
#' occ_data(catalogNumber="49366;Bird.27847588", limit=10)
#'
#' # Use paging parameters (limit and start) to page. Note the different results
#' # for the two queries below.
#' occ_data(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a',start=10,limit=5)
#' occ_data(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a',start=20,limit=5)
#'
#' # Many dataset keys
#' ## separate requests: use a vector of strings
#' occ_data(datasetKey=c("50c9509d-22c7-4a22-a47d-8c48425ef4a7",
#'    "7b5d6a48-f762-11e1-a439-00145eb45e9a"), limit=20)
#' ## one request, many instances of same parameter: use semi-colon sep. string
#' v="50c9509d-22c7-4a22-a47d-8c48425ef4a7;7b5d6a48-f762-11e1-a439-00145eb45e9a"
#' occ_data(datasetKey = v, limit=20)
#'
#' # Search by recorder
#' occ_data(recordedBy="smith", limit=20)
#'
#' # Many collector names
#' ## separate requests: use a vector of strings
#' occ_data(recordedBy=c("smith","BJ Stacey"), limit=10)
#' ## one request, many instances of same parameter: use semi-colon sep. string
#' occ_data(recordedBy="smith;BJ Stacey", limit=10)
#'
#' # recordedByID
#' occ_data(recordedByID="https://orcid.org/0000-0003-1691-239X", limit=20)
#' ## many at once
#' ### separate searches
#' ids <- c("https://orcid.org/0000-0003-1691-239X",
#'   "https://orcid.org/0000-0001-7569-1828",
#'   "https://orcid.org/0000-0002-0596-5376")
#' res <- occ_data(recordedByID=ids, limit=20)
#' res[[1]]$data$recordedByIDs[[1]]
#' res[[2]]$data$recordedByIDs[[1]]
#' res[[3]]$data$recordedByIDs[[1]]
#' ### all in one search
#' res <- occ_data(recordedByID=paste0(ids, collapse=";"), limit=20)
#' unique(vapply(res$data$recordedByIDs, "[[", "", "value"))
#'
#' # identifiedByID
#' occ_data(identifiedByID="https://orcid.org/0000-0003-4710-2648", limit=20)
#'
#' # Pass in curl options for extra fun
#' occ_data(taxonKey=2433407, limit=20, curlopts=list(verbose=TRUE))
#' occ_data(taxonKey=2433407, limit=20,
#'   curlopts = list(
#'     noprogress = FALSE,
#'     progressfunction = function(down, up) {
#'       cat(sprintf("up: %d | down %d\n", up, down))
#'       return(TRUE)
#'     }
#'   )
#' )
#' # occ_data(taxonKey=2433407, limit=20, curlopts=list(timeout_ms=1))
#'
#' # Search for many species
#' splist <- c('Cyanocitta stelleri', 'Junco hyemalis', 'Aix sponsa')
#' keys <- sapply(splist, function(x) name_suggest(x)$key[1], USE.NAMES=FALSE)
#' ## separate requests: use a vector of strings
#' occ_data(taxonKey = keys, limit=5)
#' ## one request, many instances of same parameter: use semi-colon sep. string
#' occ_data(taxonKey = paste0(keys, collapse = ";"), limit=5)
#'
#' # Search using a synonym name
#' #  Note that you'll see a message printing out that the accepted name will
#' # be used
#' occ_data(scientificName = 'Pulsatilla patens', limit=5)
#'
#' # Search on latitidue and longitude
#' occ_data(decimalLatitude=40, decimalLongitude=-120, limit = 10)
#'
#' # Search on a bounding box
#' ## in well known text format
#' ### polygon
#' occ_data(geometry='POLYGON((30.1 10.1,40 40,20 40,10 20,30.1 10.1))',
#'   limit=20)
#' ### multipolygon
#' wkt <- 'MULTIPOLYGON(((-123 38,-116 38,-116 43,-123 43,-123 38)),
#'    ((-97 41,-93 41,-93 45,-97 45,-97 41)))'
#' occ_data(geometry = gsub("\n\\s+", "", wkt), limit = 20)
#' ### polygon and taxonkey
#' key <- name_suggest(q='Aesculus hippocastanum')$key[1]
#' occ_data(taxonKey=key,
#'  geometry='POLYGON((30.1 10.1,40 40,20 40,10 20,30.1 10.1))',
#'  limit=20)
#' ## or using bounding box, converted to WKT internally
#' occ_data(geometry=c(-125.0,38.4,-121.8,40.9), limit=20)
#'
#' ## you can seaerch on many geometry objects
#' ### separate requests: use a vector of strings
#' wkts <-
#' c('POLYGON((-102.2 46,-102.2 43.7,-93.9 43.7,-93.9 46,-102.2 46))',
#' 'POLYGON((30.1 10.1,40 40,20 40,10 20,30.1 10.1))')
#' occ_data(geometry = wkts, limit=20)
#' ### one request, many instances of same parameter: use semi-colon sep. string
#' occ_data(geometry = paste0(wkts, collapse = ";"), limit=20)
#'
#'
#' # Search on a long WKT string - too long for a GBIF search API request
#' ## By default, a very long WKT string will likely cause a request failure as
#' ## GBIF only handles strings up to about 1500 characters long. You can leave as is, or
#' ##  - Alternatively, you can choose to break up your polygon into many, and do a
#' ##      data request on each piece, and the output is put back together (see below)
#' ##  - Or, 2nd alternatively, you could use the GBIF download API
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
#' # res <- occ_data(geometry = wkt)
#'
#' #### if WKT too long, with 'geom_big=bbox': makes into bounding box
#' res <- occ_data(geometry = wkt, geom_big = "bbox")
#' library("rgeos")
#' library("sp")
#' wktsp <- readWKT(wkt)
#' plot(wktsp)
#' coordinates(res$data) <- ~decimalLongitude+decimalLatitude
#' points(res$data)
#'
#' #### Or, use 'geom_big=axe'
#' (res <- occ_data(geometry = wkt, geom_big = "axe"))
#' ##### manipulate essentially number of polygons that result, so number of requests
#' ###### default geom_size is 40
#' ###### fewer calls
#' (res <- occ_data(geometry = wkt, geom_big = "axe", geom_size=50))
#' ###### more calls
#' (res <- occ_data(geometry = wkt, geom_big = "axe", geom_size=30))
#'
#' # Search on country
#' occ_data(country='US', limit=20)
#' isocodes[grep("France", isocodes$name),"code"]
#' occ_data(country='FR', limit=20)
#' occ_data(country='DE', limit=20)
#' ### separate requests: use a vector of strings
#' occ_data(country=c('US','DE'), limit=20)
#' ### one request, many instances of same parameter: use semi-colon sep. string
#' occ_data(country = 'US;DE', limit=20)
#'
#' # Get only occurrences with lat/long data
#' occ_data(taxonKey=key, hasCoordinate=TRUE, limit=20)
#'
#' # Get only occurrences that were recorded as living specimens
#' occ_data(basisOfRecord="LIVING_SPECIMEN", hasCoordinate=TRUE, limit=20)
#'
#' # Get occurrences for a particular eventDate
#' occ_data(taxonKey=key, eventDate="2013", limit=20)
#' occ_data(taxonKey=key, year="2013", limit=20)
#' occ_data(taxonKey=key, month="6", limit=20)
#'
#' # Get occurrences based on depth
#' key <- name_backbone(name='Salmo salar', kingdom='animals')$speciesKey
#' occ_data(taxonKey=key, depth=1, limit=20)
#'
#' # Get occurrences based on elevation
#' key <- name_backbone(name='Puma concolor', kingdom='animals')$speciesKey
#' occ_data(taxonKey=key, elevation=50, hasCoordinate=TRUE, limit=20)
#'
#' # Get occurrences based on institutionCode
#' occ_data(institutionCode="TLMF", limit=20)
#' ### separate requests: use a vector of strings
#' occ_data(institutionCode=c("TLMF","ArtDatabanken"), limit=20)
#' ### one request, many instances of same parameter: use semi-colon sep. string
#' occ_data(institutionCode = "TLMF;ArtDatabanken", limit=20)
#'
#' # Get occurrences based on collectionCode
#' occ_data(collectionCode="Floristic Databases MV - Higher Plants", limit=20)
#' ### separate requests: use a vector of strings
#' occ_data(collectionCode=c("Floristic Databases MV - Higher Plants",
#'   "Artport"), limit = 20)
#' ### one request, many instances of same parameter: use semi-colon sep. string
#' occ_data(collectionCode = "Floristic Databases MV - Higher Plants;Artport",
#'   limit = 20)
#'
#' # Get only those occurrences with spatial issues
#' occ_data(taxonKey=key, hasGeospatialIssue=TRUE, limit=20)
#'
#' # Search using a query string
#' occ_data(search="kingfisher", limit=20)
#'
#' # search on repatriated - doesn't work right now
#' # occ_data(repatriated = "")
#'
#' # search on phylumKey
#' occ_data(phylumKey = 7707728, limit = 5)
#'
#' # search on kingdomKey
#' occ_data(kingdomKey = 1, limit = 5)
#'
#' # search on classKey
#' occ_data(classKey = 216, limit = 5)
#'
#' # search on orderKey
#' occ_data(orderKey = 7192402, limit = 5)
#'
#' # search on familyKey
#' occ_data(familyKey = 3925, limit = 5)
#'
#' # search on genusKey
#' occ_data(genusKey = 1935496, limit = 5)
#'
#' # search on establishmentMeans
#' occ_data(establishmentMeans = "INVASIVE", limit = 5)
#' occ_data(establishmentMeans = "NATIVE", limit = 5)
#' occ_data(establishmentMeans = "UNCERTAIN", limit = 5)
#' ### separate requests: use a vector of strings
#' occ_data(establishmentMeans = c("INVASIVE", "NATIVE"), limit = 5)
#' ### one request, many instances of same parameter: use semi-colon sep. string
#' occ_data(establishmentMeans = "INVASIVE;NATIVE", limit = 5)
#'
#' # search on protocol
#' occ_data(protocol = "DIGIR", limit = 5)
#'
#' # search on license
#' occ_data(license = "CC_BY_4_0", limit = 5)
#'
#' # search on organismId
#' occ_data(organismId = "100", limit = 5)
#'
#' # search on publishingOrg
#' occ_data(publishingOrg = "28eb1a3f-1c15-4a95-931a-4af90ecb574d", limit = 5)
#'
#' # search on stateProvince
#' occ_data(stateProvince = "California", limit = 5)
#'
#' # search on waterBody
#' occ_data(waterBody = "pacific ocean", limit = 5)
#'
#' # search on locality
#' occ_data(locality = "Trondheim", limit = 5)
#' ### separate requests: use a vector of strings
#' res <- occ_data(locality = c("Trondheim", "Hovekilen"), limit = 5)
#' res$Trondheim$data
#' res$Hovekilen$data
#' ### one request, many instances of same parameter: use semi-colon sep. string
#' occ_data(locality = "Trondheim;Hovekilen", limit = 5)
#'
#'
#' # Range queries
#' ## See Detail for parameters that support range queries
#' occ_data(depth='50,100', limit = 20)
#' ### this is not a range search, but does two searches for each depth
#' occ_data(depth=c(50,100), limit = 20)
#'
#' ## Range search with year
#' occ_data(year='1999,2000', limit=20)
#'
#' ## Range search with latitude
#' occ_data(decimalLatitude='29.59,29.6', limit = 20)
#'
#' # Search by specimen type status
#' ## Look for possible values of the typeStatus parameter looking at the typestatus dataset
#' occ_data(typeStatus = 'allotype', limit = 20)$data[,c('name','typeStatus')]
#'
#' # Search by specimen record number
#' ## This is the record number of the person/group that submitted the data, not GBIF's numbers
#' ## You can see that many different groups have record number 1, so not super helpful
#' occ_data(recordNumber = 1, limit = 20)$data[,c('name','recordNumber','recordedBy')]
#'
#' # Search by last time interpreted: Date the record was last modified in GBIF
#' ## The lastInterpreted parameter accepts ISO 8601 format dates, including
#' ## yyyy, yyyy-MM, yyyy-MM-dd, or MM-dd. Range queries are accepted for lastInterpreted
#' occ_data(lastInterpreted = '2016-04-02', limit = 20)
#'
#' # Search for occurrences with images
#' occ_data(mediaType = 'StillImage', limit = 20)
#' occ_data(mediaType = 'MovingImage', limit = 20)
#' occ_data(mediaType = 'Sound', limit = 20)
#'
#' # Search by continent
#' ## One of africa, antarctica, asia, europe, north_america, oceania, or
#' ## south_america
#' occ_data(continent = 'south_america', limit = 20)$meta
#' occ_data(continent = 'africa', limit = 20)$meta
#' occ_data(continent = 'oceania', limit = 20)$meta
#' occ_data(continent = 'antarctica', limit = 20)$meta
#' ### separate requests: use a vector of strings
#' occ_data(continent = c('south_america', 'oceania'), limit = 20)
#' ### one request, many instances of same parameter: use semi-colon sep. string
#' occ_data(continent = 'south_america;oceania', limit = 20)
#'
#' # Query based on issues - see Details for options
#' ## one issue
#' x <- occ_data(taxonKey=1, issue='DEPTH_UNLIKELY', limit = 20)
#' x$data[,c('name','key','decimalLatitude','decimalLongitude','depth')]
#' ## two issues
#' occ_data(taxonKey=1, issue=c('DEPTH_UNLIKELY','COORDINATE_ROUNDED'), limit = 20)
#' # Show all records in the Arizona State Lichen Collection that cant be matched to the GBIF
#' # backbone properly:
#' occ_data(datasetKey='84c0e1a0-f762-11e1-a439-00145eb45e9a',
#'    issue=c('TAXON_MATCH_NONE','TAXON_MATCH_HIGHERRANK'), limit = 20)
#'
#' # Parsing output by issue
#' (res <- occ_data(geometry='POLYGON((30.1 10.1,40 40,20 40,10 20,30.1 10.1))', limit = 50))
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
#' }
