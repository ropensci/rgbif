#' @export
print.gbif <- function(x, ...) {
  if (
    if (is.null(attr(x, "type"))) FALSE else attr(x, "type") == "single"
    ) {
    if ("meta" %in% names(x)) {
      if ("count" %in% names(x$meta)) {
        cat(rgbif_wrap(sprintf("Records found [%s]", x$meta$count)), "\n")
      }
    }
    if ("data" %in% names(x)) {
      cat(rgbif_wrap(sprintf("Records returned [%s]", NROW(x$data))), "\n")
    }
    if ("hierarchy" %in% names(x)) {
      cat(rgbif_wrap(sprintf("No. unique hierarchies [%s]",
                             length(x$hierarchy))), "\n")
    }
    if ("hierarchies" %in% names(x)) {
      cat(rgbif_wrap(sprintf("No. unique hierarchies [%s]",
                             length(x$hierarchies))), "\n")
    }
    if ("media" %in% names(x)) {
      cat(rgbif_wrap(sprintf("No. media records [%s]", length(x$media))), "\n")
    }
    if ("facets" %in% names(x)) {
      cat(rgbif_wrap(sprintf("No. facets [%s]", length(x$facets))), "\n")
    }
    if ("names" %in% names(x)) {
      cat(rgbif_wrap(sprintf("No. names [%s]", length(x$names))), "\n")
    }
    cat(rgbif_wrap(sprintf("Args [%s]", pasteargs(x))), "\n")
    if (inherits(x$data, "data.frame")) print(x$data) else cat(x$data)
  } else if (if (is.null(attr(x, "type"))) FALSE else attr(x, "type") == "many") {
    cat(rgbif_wrap(sprintf("Records found [%s]", pastemax(x))), "\n")
    cat(rgbif_wrap(sprintf("Records returned [%s]", pastemax(x, "returned"))), "\n")
    cat(rgbif_wrap(sprintf("No. unique hierarchies [%s]", pastemax(x, "hier"))), "\n")
    cat(rgbif_wrap(sprintf("No. media records [%s]", pastemax(x, "media"))), "\n")
    cat(rgbif_wrap(sprintf("No. facets [%s]", pastemax(x, "facets"))), "\n")
    cat(rgbif_wrap(sprintf("Args [%s]", pasteargs(x))), "\n")
    cat(sprintf("%s requests; First 10 rows of data from %s\n\n", length(x), substring(names(x)[1], 1, 50)))
    if (inherits(x[[1]]$data, "data.frame")) print(x[[1]]$data) else cat(x[[1]]$data)
  } else if (inherits(x, "data.frame")) {
    print(tibble::as_tibble(x))
  } else {
    if (inherits(x, "gbif")) x <- unclass(x)
    attr(x, "type") <- NULL
    print(x)
  }
}

pasteargs <- function(b){
  arrrgs <- attr(b, "args")
  arrrgs <- rgbif_compact(arrrgs)
  tt <- list()
  for (i in seq_along(arrrgs)) {
    tt[[i]] <- sprintf("%s=%s", names(arrrgs)[i],
                       if (length(arrrgs[[i]]) > 1) {
                         substring(paste0(arrrgs[[i]], collapse = ","), 1, 100)
                       } else {
                         substring(arrrgs[[i]], 1, 100)
                       })
  }
  paste0(tt, collapse = ", ")
}

pastemax <- function(z, type='counts', n=10){
  xnames <- names(z)
  xnames <- sapply(xnames, function(x) {
    if (nchar(x) > 8) {
      paste0(substr(x, 1, 6), "..", collapse = "")
    } else {
      x
    }
  }, USE.NAMES = FALSE)
  yep <- switch(
    type,
    counts = vapply(unclass(z), function(y) y$meta$count, numeric(1),
                    USE.NAMES = FALSE),
    facets = vapply(unclass(z), function(y) length(y$facets), numeric(1),
                    USE.NAMES = FALSE),
    returned = vapply(unclass(z), function(y) NROW(y$data), numeric(1),
                      USE.NAMES = FALSE),
    hier = vapply(unclass(z), function(y) length(y$hierarchy), numeric(1),
                  USE.NAMES = FALSE),
    media = vapply(unclass(z), function(y) length(y$media), numeric(1),
                   USE.NAMES = FALSE)
  )
  tt <- list()
  for (i in seq_along(xnames)) {
    tt[[i]] <- sprintf("%s (%s)", xnames[i], yep[[i]])
  }
  paste0(tt, collapse = ", ")
}

#' @export
print.gbif_data <- function(x, ..., n = 10) {
  if ("type" %in% names(attributes(x))) {
    if (attr(x, "type") == "single") {
      cat(rgbif_wrap(sprintf("Records found [%s]", x$meta$count)), "\n")
      cat(rgbif_wrap(sprintf("Records returned [%s]", NROW(x$data))), "\n")
      cat(rgbif_wrap(sprintf("Args [%s]", pasteargs(x))), "\n")
      if (inherits(x$data, "data.frame")) print(x$data) else cat(x$data)
    } else if (attr(x, "type") == "many") {
      cat(rgbif_wrap(sprintf("Occ. found [%s]", pastemax(x))), "\n")
      cat(rgbif_wrap(sprintf("Occ. returned [%s]", pastemax(x, "returned"))), "\n")
      cat(rgbif_wrap(sprintf("Args [%s]", pasteargs(x))), "\n")
      cat(sprintf("%s requests; First 10 rows of data from %s\n\n", length(x), substring(names(x)[1], 1, 50)))
      if (inherits(x[[1]]$data, "data.frame")) print(x[[1]]$data) else cat(x[[1]]$data)
    }
  } else {
    if (inherits(x, "gbif_data")) x <- unclass(x)
    attr(x, "type") <- NULL
    attr(x, "return") <- NULL
    print(tibble::as_tibble(x))
  }
}
