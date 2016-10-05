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
#' occ_search(catalogNumber=c("49366","Bird.27847588"), limit=20)
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
#' occ_search(datasetKey=c("50c9509d-22c7-4a22-a47d-8c48425ef4a7",
#'    "7b5d6a48-f762-11e1-a439-00145eb45e9a"), limit=20)
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
#' library('httr')
#' occ_search(taxonKey=key, limit=20, return='hier', config=verbose())
#' # occ_search(taxonKey=key, limit=20, return='hier', config=progress())
#' # occ_search(taxonKey=key, limit=20, return='hier', config=timeout(1))
#'
#' # Search for many species
#' splist <- c('Cyanocitta stelleri', 'Junco hyemalis', 'Aix sponsa')
#' keys <- sapply(splist, function(x) name_suggest(x)$key[1], USE.NAMES=FALSE)
#' occ_search(taxonKey=keys, limit=5, return='data')
#'
#' # Search using a synonym name
#' #  Note that you'll see a message printing out that the accepted name will be used
#' occ_search(scientificName = 'Pulsatilla patens', fields = c('name','scientificName'), limit=5)
#'
#' # Search on latitidue and longitude
#' occ_search(search="kingfisher", decimalLatitude=50, decimalLongitude=-10)
#'
#' # Search on a bounding box
#' ## in well known text format
#' ### polygon
#' occ_search(geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))', limit=20)
#' ### multipolygon
#' ## wkt <- 'MULTIPOLYGON(((-123 38, -123 43, -116 43, -116 38, -123 38)),
#' ##   ((-97 41, -97 45, -93 45, -93 41, -97 41)))'
#' ## occ_search(geometry = gsub("\n", "", wkt), limit = 20)
#' ## taxonKey + WKT
#' key <- name_suggest(q='Aesculus hippocastanum')$key[1]
#' occ_search(taxonKey=key, geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))',
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
#' wkt <- "POLYGON((13.26349675655365 52.53991761181831,18.36115300655365 54.11445544219924,
#' 21.87677800655365 53.80418956368524,24.68927800655365 54.217364774722455,28.20490300655365
#' 54.320018299365124,30.49005925655365 52.85948216284084,34.70880925655365 52.753220564427814,
#' 35.93927800655365 50.46131871049754,39.63068425655365 49.55761261299145,40.86115300655365
#' 46.381388009130845,34.00568425655365 45.279102926537,33.30255925655365 48.636868465271846,
#' 30.13849675655365 49.78513301801265,28.38068425655365 47.2236377039631,29.78693425655365
#' 44.6572866068524,27.67755925655365 42.62220075124676,23.10724675655365 43.77542058000212,
#' 24.51349675655365 47.10412345120368,26.79865300655365 49.55761261299145,23.98615300655365
#' 52.00209943876426,23.63459050655365 49.44345313705238,19.41584050655365 47.580567827212114,
#' 19.59162175655365 44.90682206053508,20.11896550655365 42.36297154876359,22.93146550655365
#' 40.651849782081555,25.56818425655365 39.98171166226459,29.61115300655365 40.78507856230178,
#' 32.95099675655365 40.38459278067577,32.95099675655365 37.37491910393631,26.27130925655365
#' 33.65619609886799,22.05255925655365 36.814081996401605,18.71271550655365 36.1072176729021,
#' 18.53693425655365 39.16878677351903,15.37287175655365 38.346355762190846,15.19709050655365
#' 41.578843777436326,12.56037175655365 41.050735748143424,12.56037175655365 44.02872991212046,
#' 15.19709050655365 45.52594200494078,16.42755925655365 48.05271546733352,17.48224675655365
#' 48.86865641518059,10.62677800655365 47.817178329053135,9.57209050655365 44.154980365192,
#' 8.16584050655365 40.51835445724746,6.05646550655365 36.53210972067291,0.9588092565536499
#' 31.583640057148145,-5.54509699344635 35.68001485298146,-6.77556574344635 40.51835445724746,
#' -9.41228449344635 38.346355762190846,-12.40056574344635 35.10683619158607,-15.74040949344635
#' 38.07010978950028,-14.68572199344635 41.31532459432774,-11.69744074344635 43.64836179231387,
#' -8.88494074344635 42.88035509418534,-4.31462824344635 43.52103366008421,-8.35759699344635
#' 47.2236377039631,-8.18181574344635 50.12441989397795,-5.01775324344635 49.55761261299145,
#' -2.73259699344635 46.25998980446569,-1.67790949344635 44.154980365192,-1.32634699344635
#' 39.30493590580802,2.18927800655365 41.44721797271696,4.47443425655365 43.26556960420879,
#' 2.18927800655365 46.7439668697322,1.83771550655365 50.3492841273576,6.93537175655365
#' 49.671505849335254,5.00177800655365 52.32557322466785,7.81427800655365 51.67627099802223,
#' 7.81427800655365 54.5245591562317,10.97834050655365 51.89375191441792,10.97834050655365
#' 55.43241335888528,13.26349675655365 52.53991761181831))"
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
#' occ_search(country=c('US','DE'), fields=c('name','country'), limit=20)
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
#' occ_search(institutionCode=c("TLMF","ArtDatabanken"), limit=20)
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
#' (res <- occ_search(geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))', limit = 50))
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
#' ### Apparently a point is allowed, but haven't successfully retrieved data, so returns nothing
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
