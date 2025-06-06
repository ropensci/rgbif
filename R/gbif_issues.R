#' List all GBIF issues and their codes.
#'
#' Returns a data.frame of all GBIF issues with the following columns:
#' - `code`: issue short code, e.g. `gass84`
#' - `code`: issue full name, e.g. `GEODETIC_DATUM_ASSUMED_WGS84`
#' - `description`: issue description
#' - `type`: issue type, either related to `occurrence` or `name`
#'
#' @export
#' @usage gbif_issues()
#' @source
#' https://gbif.github.io/gbif-api/apidocs/org/gbif/api/vocabulary/OccurrenceIssue.html
#' https://gbif.github.io/gbif-api/apidocs/org/gbif/api/vocabulary/NameUsageIssue.html
#'
gbif_issues <- function() {
  .Deprecated(msg= "gbif_issues() is deprecated since v3.8.2.") 
  gbifissues
}

gbifissues <- structure(list(
  code = c(
           # occurrence issues
           "bri", "ccm", "cdc", "conti", "cdiv",
           "cdout", "cdrep", "cdrepf", "cdreps", "cdround", "cucdmis", "cudc",
           "cuiv", "cum", "depmms", "depnn", "depnmet", "depunl", "elmms",
           "elnn", "elnmet", "elunl", "gass84", "gdativ", "iddativ", "iddatunl",
           "mdativ", "mdatunl", "muldativ", "muluriiv", "preneglat",
           "preneglon", "preswcd", "rdativ", "rdatm", "rdatunl", "refuriiv",
           "txmatfuz", "txmathi", "txmatnon", "typstativ", "zerocd",
           "cdpi", "cdumi", "indci", "interr", "iccos", "osiic", "osu",
           "geodi","geodu", "ambcol", "ambinst", "colmafu", "colmano",
           "incomis", "inmafu", "inmano", "osifbor", "diffown", "taxmatagg",
           "fpsrsinv","fpwktinv",
           # name issues
           "anm", "annu", "anuidi", "aitidinv", "bbmn", "basauthm",
           "bibrinv", "chsun", "clasna", "clasroi", "conbascomb", "desinv",
           "disinv", "hom", "minv", "npm", "ns","nsinv", "onder", "onnu",
           "onuidinv", "ov", "pc", "pnnu", "pnuidinv", "pp","pbg","rankinv",
           "relmiss", "scina", "spprinv", "taxstinv", "taxstmis", "unpars",
           "vernnameinv", "backmatagg"),
  issue = c(
            # occurrence issues
            "BASIS_OF_RECORD_INVALID",
            "CONTINENT_COUNTRY_MISMATCH", "CONTINENT_DERIVED_FROM_COORDINATES",
            "CONTINENT_INVALID", "COORDINATE_INVALID", "COORDINATE_OUT_OF_RANGE",
            "COORDINATE_REPROJECTED", "COORDINATE_REPROJECTION_FAILED", "COORDINATE_REPROJECTION_SUSPICIOUS",
            "COORDINATE_ROUNDED", "COUNTRY_COORDINATE_MISMATCH", "COUNTRY_DERIVED_FROM_COORDINATES",
            "COUNTRY_INVALID", "COUNTRY_MISMATCH", "DEPTH_MIN_MAX_SWAPPED",
            "DEPTH_NON_NUMERIC", "DEPTH_NOT_METRIC", "DEPTH_UNLIKELY", "ELEVATION_MIN_MAX_SWAPPED",
            "ELEVATION_NON_NUMERIC", "ELEVATION_NOT_METRIC", "ELEVATION_UNLIKELY",
            "GEODETIC_DATUM_ASSUMED_WGS84", "GEODETIC_DATUM_INVALID", "IDENTIFIED_DATE_INVALID",
            "IDENTIFIED_DATE_UNLIKELY", "MODIFIED_DATE_INVALID", "MODIFIED_DATE_UNLIKELY",
            "MULTIMEDIA_DATE_INVALID", "MULTIMEDIA_URI_INVALID", "PRESUMED_NEGATED_LATITUDE",
            "PRESUMED_NEGATED_LONGITUDE", "PRESUMED_SWAPPED_COORDINATE",
            "RECORDED_DATE_INVALID", "RECORDED_DATE_MISMATCH", "RECORDED_DATE_UNLIKELY",
            "REFERENCES_URI_INVALID", "TAXON_MATCH_FUZZY", "TAXON_MATCH_HIGHERRANK",
            "TAXON_MATCH_NONE", "TYPE_STATUS_INVALID", "ZERO_COORDINATE",
            "COORDINATE_PRECISION_INVALID", "COORDINATE_UNCERTAINTY_METERS_INVALID",
            "INDIVIDUAL_COUNT_INVALID", "INTERPRETATION_ERROR",
            "INDIVIDUAL_COUNT_CONFLICTS_WITH_OCCURRENCE_STATUS", "OCCURRENCE_STATUS_INFERRED_FROM_INDIVIDUAL_COUNT", "OCCURRENCE_STATUS_UNPARSABLE",
            "GEOREFERENCED_DATE_INVALID","GEOREFERENCED_DATE_UNLIKELY", "AMBIGUOUS_COLLECTION",
            "AMBIGUOUS_INSTITUTION", "COLLECTION_MATCH_FUZZY", "COLLECTION_MATCH_NONE",
            "INSTITUTION_COLLECTION_MISMATCH", "INSTITUTION_MATCH_FUZZY",
            "INSTITUTION_MATCH_NONE", "OCCURRENCE_STATUS_INFERRED_FROM_BASIS_OF_RECORD",
            "DIFFERENT_OWNER_INSTITUTION","TAXON_MATCH_AGGREGATE",
            "FOOTPRINT_SRS_INVALID","FOOTPRINT_WKT_INVALID",
            # name issues
            "ACCEPTED_NAME_MISSING", "ACCEPTED_NAME_NOT_UNIQUE", "ACCEPTED_NAME_USAGE_ID_INVALID",
            "ALT_IDENTIFIER_INVALID", "BACKBONE_MATCH_NONE",
            "BASIONYM_AUTHOR_MISMATCH", "BIB_REFERENCE_INVALID", "CHAINED_SYNOYM",
            "CLASSIFICATION_NOT_APPLIED", "CLASSIFICATION_RANK_ORDER_INVALID",
            "CONFLICTING_BASIONYM_COMBINATION", "DESCRIPTION_INVALID",
            "DISTRIBUTION_INVALID", "HOMONYM", "MULTIMEDIA_INVALID", "NAME_PARENT_MISMATCH",
            "NO_SPECIES", "NOMENCLATURAL_STATUS_INVALID", "ORIGINAL_NAME_DERIVED",
            "ORIGINAL_NAME_NOT_UNIQUE", "ORIGINAL_NAME_USAGE_ID_INVALID", "ORTHOGRAPHIC_VARIANT",
            "PARENT_CYCLE", "PARENT_NAME_NOT_UNIQUE", "PARENT_NAME_USAGE_ID_INVALID",
            "PARTIALLY_PARSABLE", "PUBLISHED_BEFORE_GENUS", "RANK_INVALID",
            "RELATIONSHIP_MISSING", "SCIENTIFIC_NAME_ASSEMBLED", "SPECIES_PROFILE_INVALID",
            "TAXONOMIC_STATUS_INVALID", "TAXONOMIC_STATUS_MISMATCH", "UNPARSABLE",
            "VERNACULAR_NAME_INVALID", "BACKBONE_MATCH_AGGREGATE"),
  description = c(
                  # occurrence issues
                  "The given basis of record is impossible to interpret or seriously different from the recommended vocabulary.",
                  "The interpreted continent and country do not match up.",
                  "The interpreted continent is based on the coordinates, not the verbatim string information.",
                  "Uninterpretable continent values found.", "Coordinate value given in some form but GBIF is unable to interpret it.",
                  "Coordinate has invalid lat/lon values out of their decimal max range.",
                  "The original coordinate was successfully reprojected from a different geodetic datum to WGS84.",
                  "The given decimal latitude and longitude could not be reprojected to WGS84 based on the provided datum.",
                  "Indicates successful coordinate reprojection according to provided datum, but which results in a datum shift larger than 0.1 decimal degrees.",
                  "Original coordinate modified by rounding to 5 decimals.",
                  "The interpreted occurrence coordinates fall outside of the indicated country.",
                  "The interpreted country is based on the coordinates, not the verbatim string information.",
                  "Uninterpretable country values found.", "Interpreted country for dwc:country and dwc:countryCode contradict each other.",
                  "Set if supplied min>max", "Set if depth is a non numeric value",
                  "Set if supplied depth is not given in the metric system, for example using feet instead of meters",
                  "Set if depth is larger than 11.000m or negative.", "Set if supplied min > max elevation",
                  "Set if elevation is a non numeric value", "Set if supplied elevation is not given in the metric system, for example using feet instead of meters",
                  "Set if elevation is above the troposphere (17km) or below 11km (Mariana Trench).",
                  "Indicating that the interpreted coordinates assume they are based on WGS84 datum as the datum was either not indicated or interpretable.",
                  "The geodetic datum given could not be interpreted.", "The date given for dwc:dateIdentified is invalid and cant be interpreted at all.",
                  "The date given for dwc:dateIdentified is in the future or before Linnean times (1700).",
                  "A (partial) invalid date is given for dc:modified, such as a non existing date, invalid zero month, etc.",
                  "The date given for dc:modified is in the future or predates unix time (1970).",
                  "An invalid date is given for dc:created of a multimedia object.",
                  "An invalid uri is given for a multimedia object.", "Latitude appears to be negated, e.g. 32.3 instead of -32.3",
                  "Longitude appears to be negated, e.g. 32.3 instead of -32.3",
                  "Latitude and longitude appear to be swapped.", "A (partial) invalid date is given, such as a non existing date, invalid zero month, etc.",
                  "The recording date specified as the eventDate string and the individual year, month, day are contradicting.",
                  "The recording date is highly unlikely, falling either into the future or represents a very old date before 1600 that predates modern taxonomy.",
                  "An invalid uri is given for dc:references.", "Matching to the taxonomic backbone can only be done using a fuzzy, non exact match.",
                  "Matching to the taxonomic backbone can only be done on a higher rank and not the scientific name.",
                  "Matching to the taxonomic backbone cannot be done cause there was no match at all or several matches with too little information to keep them apart (homonyms).",
                  "The given type status is impossible to interpret or seriously different from the recommended vocabulary.",
                  "Coordinate is the exact 0/0 coordinate, often indicating a bad null coordinate.",
                  "Indicates an invalid or very unlikely coordinatePrecision",
                  "Indicates an invalid or very unlikely dwc:uncertaintyInMeters.",
                  "Individual count value not parsable into an integer.",
                  "An error occurred during interpretation, leaving the record interpretation incomplete.",
                  "Example: individual count value > 0, but occurrence status is absent and etc.",
                  "Occurrence status was inferred from the individual count value",
                  "Occurrence status value can't be assigned to OccurrenceStatus",
                  "The date given for dwc:georeferencedDate is invalid and can't be interpreted at all.",
                  "The date given for dwc:georeferencedDate is in the future or before Linnean times (1700).",
                  "The given collection matches with more than 1 GrSciColl collection.",
                  "The given institution matches with more than 1 GrSciColl institution.",
                  "The given collection was fuzzily matched to a GrSciColl collection.",
                  "The given collection couldn't be matched with any GrSciColl collection.",
                  "The collection matched doesn't belong to the institution matched.",
                  "The given institution was fuzzily matched to a GrSciColl institution.",
                  "The given institution couldn't be matched with any GrSciColl institution.",
                  "Occurrence status was inferred from basis of records",
                  "The given owner institution is different than the given institution. Therefore we assume it doesn't belong to the institution and we don't link it to the occurrence.",
                  "Matching to the taxonomic backbone can only be done on a species level, but the occurrence was in fact considered a broader species aggregate/complex.",
                  "The Footprint Spatial Reference System given could not be interpreted",
                  "The Footprint Well-Known-Text given could not be interpreted",
                  # name issues
                  "Synonym lacking an accepted name.",
                  "Synonym has a verbatim accepted name which is not unique and refers to several records.",
                  "The value for dwc:acceptedNameUsageID could not be resolved.",
                  "At least one alternative identifier extension record attached to this name usage is invalid.",
                  "Name usage could not be matched to the GBIF backbone.",
                  "The authorship of the original name does not match the authorship in brackets of the actual name.",
                  "At least one bibliographic reference extension record attached to this name usage is invalid.",
                  "If a synonym points to another synonym as its accepted taxon the chain is resolved.",
                  "The denormalized classification could not be applied to the name usage.",
                  "The given ranks of the names in the classification hierarchy do not follow the hierarchy of ranks.",
                  "There have been more than one accepted name in a homotypical basionym group of names.",
                  "At least one description extension record attached to this name usage is invalid.",
                  "At least one distribution extension record attached to this name usage is invalid.",
                  "A not synonymized homonym exists for this name in some other backbone source which have been ignored at build time.",
                  "At least one multimedia extension record attached to this name usage is invalid.",
                  "The (accepted) bi/trinomial name does not match the parent name and should be recombined into the parent genus/species.",
                  "The group (currently only genera are tested) are lacking any accepted species GBIF backbone specific issue.",
                  "dwc:nomenclaturalStatus could not be interpreted",
                  "Record has a original name (basionym) relationship which was derived from name & authorship comparison, but did not exist explicitly in the data.",
                  "Record has a verbatim original name (basionym) which is not unique and refers to several records.",
                  "The value for dwc:originalNameUsageID could not be resolved.",
                  "A potential orthographic variant exists in the backbone.",
                  "The child parent classification resulted into a cycle that needed to be resolved/cut.",
                  "Record has a verbatim parent name which is not unique and refers to several records.",
                  "The value for dwc:parentNameUsageID could not be resolved.",
                  "The beginning of the scientific name string was parsed, but there is additional information in the string that was not understood.",
                  "A bi/trinomial name published earlier than the parent genus was published.",
                  "dwc:taxonRank could not be interpreted",
                  "There were problems representing all name usage relationships, i.e.",
                  "The scientific name was assembled from the individual name parts and not given as a whole string.",
                  "At least one species profile extension record attached to this name usage is invalid.",
                  "dwc:taxonomicStatus could not be interpreted",
                  "no description",
                  "The scientific name string could not be parsed at all, but appears to be a parsable name type, i.e.",
                  "At least one vernacular name extension record attached to this name usage is invalid.",
                  "Name usage could only be matched to a GBIF backbone species, but was in fact a broader species aggregate/complex."),
  type <- c(rep("occurrence", 63), rep("name", 36)
  )), .Names = c("code", "issue", "description", "type"), class = "data.frame", row.names = c(NA, -99L))

collapse_issues <- function(x, issue_col = "issues") {
  tmp <- x[names(x) %in% issue_col][[1]]
  tmp <- gbifissues[ gbifissues$issue %in% tmp, "code" ]
  paste(tmp, collapse = ",")
}

collapse_issues_vec <- function(x, issue_col = "issues") {
  tmp <- x[names(x) %in% issue_col][[1]]
  unlist(lapply(tmp, function(z) paste(gbifissues[ gbifissues$issue %in% z, "code" ], collapse = ",")))
}
