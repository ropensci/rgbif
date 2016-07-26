# gbif class sub-setters -------------------
# `[[.gbif` <- function(x, i) {
#   #y <- NextMethod()
#   if (inherits(i, "character")) {
#     tmp <- x[names(x) %in% i][[1]]
#   } else {
#     tmp <- x[[i]]
#   }
#   structure(tmp, class = "gbif",
#             args = attr(x, 'args'),
#             type = 'single',
#             return = attr(x, 'return'))
#   #x[names(x) %in% i][1]
# }

# `[.gbif` <- function(x, i) {
#   tmp <- x[names(x) %in% i]
#   structure(tmp, class = "gbif",
#             args = attr(x, 'args'),
#             type = 'single',
#             return = attr(x, 'return'))
# }
