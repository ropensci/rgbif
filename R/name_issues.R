#' Table of GBIF name usage issues, with codes used in data output, full issue name,
#' and descriptions.
#'
#' Table has the following fields:
#'
#' - code. Code for issue, making viewing data easier.
#' - issue. Full name of the issue.
#' - description. Description of the issue.
#'
#' @export
#' @usage name_issues()
#' @seealso [gbif_issues()]
#' @source <https://gbif.github.io/gbif-api/apidocs/org/gbif/api/vocabulary/NameUsageIssue.html>
name_issues <- function() nameissues

nameissues <- structure(list(
  code = c("anm","annu","anuidi","aitidinv","bbmf","bbmn","basauthm","bibrinv","chsun",
    "clasna","clasroi","conbascomb","desinv","disinv","hom","minv","npm","ns","nsinv",
    "onder","onnu","onuidinv","ov","pc","pnnu","pnuidinv","pp","pbg","rankinv",
    "relmiss","scina","spprinv","taxstinv","taxstmis","unpars","vernnameinv"),
  issue = c("ACCEPTED_NAME_MISSING","ACCEPTED_NAME_NOT_UNIQUE","ACCEPTED_NAME_USAGE_ID_INVALID",
    "ALT_IDENTIFIER_INVALID","BACKBONE_MATCH_FUZZY","BACKBONE_MATCH_NONE",
    "BASIONYM_AUTHOR_MISMATCH","BIB_REFERENCE_INVALID","CHAINED_SYNOYM",
    "CLASSIFICATION_NOT_APPLIED","CLASSIFICATION_RANK_ORDER_INVALID","CONFLICTING_BASIONYM_COMBINATION",
    "DESCRIPTION_INVALID","DISTRIBUTION_INVALID","HOMONYM","MULTIMEDIA_INVALID",
    "NAME_PARENT_MISMATCH","NO_SPECIES","NOMENCLATURAL_STATUS_INVALID","ORIGINAL_NAME_DERIVED",
    "ORIGINAL_NAME_NOT_UNIQUE","ORIGINAL_NAME_USAGE_ID_INVALID","ORTHOGRAPHIC_VARIANT",
    "PARENT_CYCLE","PARENT_NAME_NOT_UNIQUE","PARENT_NAME_USAGE_ID_INVALID","PARTIALLY_PARSABLE",
    "PUBLISHED_BEFORE_GENUS","RANK_INVALID","RELATIONSHIP_MISSING","SCIENTIFIC_NAME_ASSEMBLED",
    "SPECIES_PROFILE_INVALID","TAXONOMIC_STATUS_INVALID","TAXONOMIC_STATUS_MISMATCH","UNPARSABLE",
    "VERNACULAR_NAME_INVALID"),
  description = c("Synonym lacking an accepted name.",
    "Synonym has a verbatim accepted name which is not unique and refers to several records.",
    "The value for dwc:acceptedNameUsageID could not be resolved.",
    "At least one alternative identifier extension record attached to this name usage is invalid.",
    "Deprecated. because there should be no fuzzy matching being used anymore for matching checklist names",
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
    "At least one vernacular name extension record attached to this name usage is invalid."
  )), .Names = c("code", "issue", "description"), class = "data.frame", row.names = c(NA, -36L))

collapse_name_issues <- function(x, issue_col = "issues") {
  tmp <- x[names(x) %in% issue_col][[1]]
  tmp <- nameissues[ nameissues$issue %in% tmp, "code" ]
  paste(tmp, collapse = ",")
}
