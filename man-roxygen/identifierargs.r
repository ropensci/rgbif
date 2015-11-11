#' @param identifier The value for this parameter can be a simple string or integer,
#'    e.g. identifier=120. This parameter doesn't seem to work right now.
#' @param identifierType Used in combination with the identifier parameter to filter
#'    identifiers by identifier type. See details. This parameter doesn't seem to
#'    work right now.
#'
#' @details
#' identifierType options:
#'
#' \itemize{
#'  \item {DOI} No description.
#'  \item {FTP} No description.
#'  \item {GBIF_NODE} Identifies the node (e.g: 'DK' for Denmark, 'sp2000' for Species 2000).
#'  \item {GBIF_PARTICIPANT} Participant identifier from the GBIF IMS Filemaker system.
#'  \item {GBIF_PORTAL} Indicates the identifier originated from an auto_increment column in the
#'  portal.data_provider or portal.data_resource table respectively.
#'  \item {HANDLER} No description.
#'  \item {LSID} Reference controlled by a separate system, used for example by DOI.
#'  \item {SOURCE_ID} No description.
#'  \item {UNKNOWN} No description.
#'  \item {URI} No description.
#'  \item {URL} No description.
#'  \item {UUID} No description.
#' }
