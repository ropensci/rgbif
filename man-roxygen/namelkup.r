#' @param query Query term(s) for full text search.
#' @param rank CLASS, CULTIVAR, CULTIVAR_GROUP, DOMAIN, FAMILY, FORM, GENUS,
#' INFORMAL, INFRAGENERIC_NAME, INFRAORDER, INFRASPECIFIC_NAME,
#' INFRASUBSPECIFIC_NAME, KINGDOM, ORDER, PHYLUM, SECTION, SERIES, SPECIES,
#' STRAIN, SUBCLASS, SUBFAMILY, SUBFORM, SUBGENUS, SUBKINGDOM, SUBORDER,
#' SUBPHYLUM, SUBSECTION, SUBSERIES, SUBSPECIES, SUBTRIBE, SUBVARIETY,
#' SUPERCLASS, SUPERFAMILY, SUPERORDER, SUPERPHYLUM, SUPRAGENERIC_NAME,
#' TRIBE, UNRANKED, VARIETY
#' @param higherTaxonKey Filters by any of the higher Linnean rank keys. Note
#' this is within the respective checklist and not searching nub keys
#' across all checklists. This parameter accepts many inputs in a vector (
#' passed in the same request).
#' @param status Filters by the taxonomic status as one of:
#' \itemize{
#'  \item ACCEPTED
#'  \item DETERMINATION_SYNONYM Used for unknown child taxa referred to via
#'  spec, ssp, ...
#'  \item DOUBTFUL Treated as accepted, but doubtful whether this is correct.
#'  \item HETEROTYPIC_SYNONYM More specific subclass of SYNONYM.
#'  \item HOMOTYPIC_SYNONYM More specific subclass of SYNONYM.
#'  \item INTERMEDIATE_RANK_SYNONYM Used in nub only.
#'  \item MISAPPLIED More specific subclass of SYNONYM.
#'  \item PROPARTE_SYNONYM More specific subclass of SYNONYM.
#'  \item SYNONYM A general synonym, the exact type is unknown.
#' }
#' @param isExtinct (logical) Filters by extinction status (e.g.
#' \code{isExtinct=TRUE})
#' @param habitat (character) Filters by habitat. One of: marine, freshwater,
#' or terrestrial
#' @param nameType Filters by the name type as one of:
#' \itemize{
#'  \item BLACKLISTED surely not a scientific name.
#'  \item CANDIDATUS Candidatus is a component of the taxonomic name for a
#'  bacterium that cannot be maintained in a Bacteriology Culture Collection.
#'  \item CULTIVAR a cultivated plant name.
#'  \item DOUBTFUL doubtful whether this is a scientific name at all.
#'  \item HYBRID a hybrid formula (not a hybrid name).
#'  \item INFORMAL a scientific name with some informal addition like "cf." or
#'  indetermined like Abies spec.
#'  \item SCINAME a scientific name which is not well formed.
#'  \item VIRUS a virus name.
#'  \item WELLFORMED a well formed scientific name according to present
#'  nomenclatural rules.
#' }
#' @param datasetKey Filters by the dataset's key (a uuid)
#' @param origin (character) Filters by origin. One of:
#' \itemize{
#'  \item SOURCE
#'  \item DENORMED_CLASSIFICATION
#'  \item VERBATIM_ACCEPTED
#'  \item EX_AUTHOR_SYNONYM
#'  \item AUTONYM
#'  \item BASIONYM_PLACEHOLDER
#'  \item MISSING_ACCEPTED
#'  \item IMPLICIT_NAME
#'  \item PROPARTE
#'  \item VERBATIM_BASIONYM
#' }
#' @param nomenclaturalStatus	Not yet implemented, but will eventually allow
#' for filtering by a nomenclatural status enum.
#' @param facet	A vector/list of facet names used to retrieve the 100 most
#' frequent values for a field. Allowed facets are: datasetKey, higherTaxonKey,
#' rank, status, isExtinct, habitat, and nameType. Additionally threat and
#' nomenclaturalStatus are legal values but not yet implemented, so data will
#' not yet be returned for them.
#' @param facetMincount Used in combination with the facet parameter. Set
#' facetMincount to exclude facets with a count less than x, e.g.
#' http://bit.ly/2osAUQB only shows the type values 'CHECKLIST' and 'OCCURRENCE'
#' because the other types have counts less than 10000
#' @param facetMultiselect (logical) Used in combination with the facet
#' parameter. Set \code{facetMultiselect=TRUE} to still return counts for
#' values that are not currently filtered, e.g. http://bit.ly/2JAymaC still
#' shows all type values even though type is being filtered
#' by \code{type=CHECKLIST}.
#' @param type Type of name. One of occurrence, checklist, or metadata.
#' @param hl (logical) Set \code{hl=TRUE} to highlight terms matching the query
#'   when in fulltext search fields. The highlight will be an emphasis tag of
#'   class \code{gbifH1} e.g. \code{query='plant', hl=TRUE}. Fulltext search
#'   fields include: title, keyword, country, publishing country, publishing
#'   organization title, hosting organization title, and description. One
#'   additional full text field is searched which includes information from
#'   metadata documents, but the text of this field is not returned in the
#'   response.
#' @param issue Filters by issue. Issue has to be related to names. Type
#'   \code{gbif_issues()} to get complete list of issues.
#' @param limit Number of records to return.
#' Hard maximum limit set by GBIF API: 99999.
#' @param start Record number to start at. Default: 0.
#' @param verbose (logical) If \code{TRUE}, all data is returned as a list for each
#' element. If \code{FALSE} (default) a subset of the data that is thought to be most
#' essential is organized into a data.frame.
#' @param constituentKey Filters by the dataset's constituent key (a uuid). 
#' @param return Defunct. All components are returned; index to the
#' one(s) you want
#'
#' @return An object of class gbif, which is a S3 class list, with slots for
#'   metadata (\code{meta}), the data itself (\code{data}), the taxonomic
#'   hierarchy data (\code{hierarchies}), and vernacular names (\code{names}).
#'   In addition, the object has attributes listing the user supplied arguments
#'   and type of search, which is, differently from occurrence data, always
#'   equals to 'single' even if multiple values for some parameters are given.
#'   \code{meta} is a list of length four with offset, limit, endOfRecords and
#'   count fields. \code{data} is a tibble (aka data.frame) containing all
#'   information about the found taxa. \code{hierarchies} is a list of
#'   data.frame's, one per GBIF key (taxon), containing its taxonomic
#'   classification. Each data.frame contains two columns: \code{rankkey} and
#'   \code{name}. \code{names} returns a list of data.frame's, one per GBIF key
#'   (taxon), containing all vernacular names. Each data.frame contains two
#'   columns: \code{vernacularName} and \code{language}.
#'
#' @return A list of length five:
#' \itemize{
#'  \item \strong{metadata}
#'  \item \strong{data}: either a data.frame (\code{verbose=FALSE}, default) or a list (\code{verbose=TRUE}).
#'  \item \strong{facets}
#'  \item \strong{hierarchies}
#'  \item \strong{names}
#' }
#'
#' @description
#' This service uses fuzzy lookup so that you can put in partial names and
#' you should get back those things that match. See examples below.
#'
#' Faceting: If \code{facet=FALSE} or left to the default (NULL), no faceting
#' is done. And therefore, all parameters with facet in their name are
#' ignored (facetOnly, facetMincount, facetMultiselect).
#'
#' @section Repeat parameter inputs:
#' Some parameters can take many inputs, and treated as 'OR' (e.g., a or b or
#' c). The following take many inputs:
#' \itemize{
#'  \item \strong{rank}
#'  \item \strong{higherTaxonKey}
#'  \item \strong{status}
#'  \item \strong{habitat}
#'  \item \strong{nameType}
#'  \item \strong{datasetKey}
#'  \item \strong{origin}
#' }
#'
