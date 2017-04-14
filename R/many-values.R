#' Many value inputs to some parameters
#'
#'
#' @name many-values
#' @details
#' There are some differences in how functions across \pkg{rgbif} behave
#' with respect to many values given to a single parameter (let's call it
#' `foo`).
#'
#' The following functions originally only iterated over many
#' values passed to `foo` as a vector (e.g., `foo = c(1, 2)`) with completely
#' separate HTTP requests. But now these functions also support passing in many
#' values to the same HTTP request (e.g., `foo = "1;2"`). This is a bit
#' awkward, but means that we don't break existing code.
#'
#' \itemize{
#'  \item [occ_search()]
#'  \item [occ_data()]
#' }
#'
#' The following functions, unlike those above, only support passing in many
#' values to the same HTTP request, which is done like `foo = c("1", "2")`.
#'
#' \itemize{
#'  \item [dataset_search()]
#'  \item [dataset_suggest()]
#'  \item [name_lookup()]
#'  \item [name_suggest()]
#'  \item [name_usage()]
#' }
#'
#' Last, some parameters in the functions above don't accept more than one,
#' and some functions don't have any parameters that accept more than one
#' value (i.e., none of those listed above).
#'
#' Each function that has at least some parameters that accept many values
#' also has documentation on this issue.
NULL
