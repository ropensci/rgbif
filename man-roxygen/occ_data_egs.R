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
#' ## you are getting synonyms too. The results for using \code{scientifcName} and
#' ## \code{taxonKey} parameters are the same in this case, but I wouldn't be surprised if for some
#' ## names they return different results
#' library("httr")
#' occ_data(scientificName = 'Ursus americanus', config=verbose())
#' key <- name_backbone(name = 'Ursus americanus', rank='species')$usageKey
#' occ_data(taxonKey = key)
#'
#' # Search by dataset key
#' occ_data(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a', limit=10)
#'
#' # Search by catalog number
#' occ_data(catalogNumber="49366", limit=10)
#' occ_data(catalogNumber=c("49366","Bird.27847588"), limit=10)
#'
#' # Use paging parameters (limit and start) to page. Note the different results
#' # for the two queries below.
#' occ_data(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a',start=10,limit=5)
#' occ_data(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a',start=20,limit=5)
#'
#' # Many dataset keys
#' occ_data(datasetKey=c("50c9509d-22c7-4a22-a47d-8c48425ef4a7",
#'    "7b5d6a48-f762-11e1-a439-00145eb45e9a"), limit=20)
#'
#' # Search by recorder
#' occ_data(recordedBy="smith", limit=20)
#'
#' # Many collector names
#' occ_data(recordedBy=c("smith","BJ Stacey"), limit=20)
#'
#' # Pass in curl options for extra fun
#' library('httr')
#' occ_data(taxonKey=key, limit=20, config=verbose())
#' x <- occ_data(taxonKey=key, limit=50, config=progress())
#' # occ_data(taxonKey=key, limit=20, config=timeout(0.01))
#'
#' # Search for many species
#' splist <- c('Cyanocitta stelleri', 'Junco hyemalis', 'Aix sponsa')
#' keys <- sapply(splist, function(x) name_suggest(x)$key[1], USE.NAMES=FALSE)
#' occ_data(taxonKey=keys, limit=5)
#'
#' # Search using a synonym name
#' #  Note that you'll see a message printing out that the accepted name will be used
#' occ_data(scientificName = 'Pulsatilla patens', limit=5)
#'
#' # Search on latitidue and longitude
#' occ_data(decimalLatitude=40, decimalLongitude=-120, limit = 10)
#'
#' # Search on a bounding box
#' ## in well known text format
#' occ_data(geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))', limit=20)
#' key <- name_suggest(q='Aesculus hippocastanum')$key[1]
#' occ_data(taxonKey=key, geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))',
#'    limit=20)
#' ## or using bounding box, converted to WKT internally
#' occ_data(geometry=c(-125.0,38.4,-121.8,40.9), limit=20)
#'
#' # Search on country
#' occ_data(country='US', limit=20)
#' isocodes[grep("France", isocodes$name),"code"]
#' occ_data(country='FR', limit=20)
#' occ_data(country='DE', limit=20)
#' occ_data(country=c('US','DE'), limit=20)
#'
#' # Get only occurrences with lat/long data
#' occ_data(taxonKey=key, hasCoordinate=TRUE, limit=20)
#'
#' # Get only occurrences that were recorded as living specimens
#' occ_data(taxonKey=key, basisOfRecord="LIVING_SPECIMEN", hasCoordinate=TRUE, limit=20)
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
#' occ_data(institutionCode=c("TLMF","ArtDatabanken"), limit=20)
#'
#' # Get occurrences based on collectionCode
#' occ_data(collectionCode="Floristic Databases MV - Higher Plants", limit=20)
#' occ_data(collectionCode=c("Floristic Databases MV - Higher Plants","Artport"))
#'
#' # Get only those occurrences with spatial issues
#' occ_data(taxonKey=key, hasGeospatialIssue=TRUE, limit=20)
#'
#' # Search using a query string
#' occ_data(search="kingfisher", limit=20)
#'
#' # Range queries
#' ## See Detail for parameters that support range queries
#' occ_data(depth='50,100') # this is a range depth, with lower/upper limits in character string
#' occ_data(depth=c(50,100)) # this is not a range search, but does two searches for each depth
#'
#' ## Range search with year
#' occ_data(year='1999,2000', limit=20)
#'
#' ## Range search with latitude
#' occ_data(decimalLatitude='29.59,29.6')
#'
#' # Search by specimen type status
#' ## Look for possible values of the typeStatus parameter looking at the typestatus dataset
#' head(occ_data(typeStatus = 'allotype')$data[,c('name','typeStatus')])
#'
#' # Search by specimen record number
#' ## This is the record number of the person/group that submitted the data, not GBIF's numbers
#' ## You can see that many different groups have record number 1, so not super helpful
#' head(occ_data(recordNumber = 1)$data[,c('name','recordNumber','recordedBy')])
#'
#' # Search by last time interpreted: Date the record was last modified in GBIF
#' ## The lastInterpreted parameter accepts ISO 8601 format dates, including
#' ## yyyy, yyyy-MM, yyyy-MM-dd, or MM-dd. Range queries are accepted for lastInterpreted
#' occ_data(lastInterpreted = '2015-09-02')
#'
#' # Search for occurrences with images
#' occ_data(mediaType = 'StillImage')
#' occ_data(mediaType = 'MovingImage')
#' occ_data(mediaType = 'Sound')
#'
#' # Search by continent
#' ## One of africa, antarctica, asia, europe, north_america, oceania, or south_america
#' occ_data(continent = 'south_america')$meta
#' occ_data(continent = 'africa')$meta
#' occ_data(continent = 'oceania')$meta
#' occ_data(continent = 'antarctica')$meta
#'
#' # Query based on issues - see Details for options
#' ## one issue
#' x <- occ_data(taxonKey=1, issue='DEPTH_UNLIKELY')
#' x$data[,c('name','key','decimalLatitude','decimalLongitude','depth')]
#' ## two issues
#' occ_data(taxonKey=1, issue=c('DEPTH_UNLIKELY','COORDINATE_ROUNDED'))
#' # Show all records in the Arizona State Lichen Collection that cant be matched to the GBIF
#' # backbone properly:
#' occ_data(datasetKey='84c0e1a0-f762-11e1-a439-00145eb45e9a',
#'    issue=c('TAXON_MATCH_NONE','TAXON_MATCH_HIGHERRANK'))
#'
#' # Parsing output by issue
#' (res <- occ_data(geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))', limit = 50))
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
