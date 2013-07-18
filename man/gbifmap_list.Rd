\name{gbifmap_list}
\alias{gbifmap_list}
\title{Make a simple map to visualize GBIF point data.}
\usage{
  gbifmap_list(input = NULL, mapdatabase = "world",
    region = ".", geom = geom_point, jitter = NULL,
    customize = NULL)
}
\arguments{
  \item{input}{Either a single data.frame or a list of
  data.frame's (e.g., from different speies). The
  data.frame has to have, in addition to any other columns,
  columns named exactly "decimalLatitude" and
  "decimalLongitude".}

  \item{mapdatabase}{The map database to use in mapping.
  What you choose here determines what you can choose in
  the region parameter. One of: county, state, usa, world,
  world2, france, italy, or nz.}

  \item{region}{The region of the world to map. From the
  maps package, run
  \code{sort(unique(map_data("world")$region))} to see
  region names for the world database layer, or e.g.,
  \code{sort(unique(map_data("state")$region))} for the
  state layer.}

  \item{geom}{The geom to use, one of geom_point or
  geom_jitter. Don't quote them.}

  \item{jitter}{If you use jitterposition, the amount by
  which to jitter points in width, height, or both.}

  \item{customize}{Further arguments passed on to ggplot.}
}
\value{
  Map (using ggplot2 package) of points on a map or tiles
  on a map.
}
\description{
  Make a simple map to visualize GBIF point data.
}
\details{
  gbifmap takes care of cleaning up the data.frame
  (removing NA's, etc.)  returned from rgbif functions, and
  creating the map. This function gives a simple map of
  your data.  You can look at the code behing the function
  itself if you want to build on it to make a map according
  to your specfications.
}
\examples{
\dontrun{
# Point map, using output from occurrencelist, example 1
out <- occurrencelist(scientificname = 'Accipiter erythronemius',
   coordinatestatus = TRUE, maxresults = 100)
gbifmap_list(input = out) # make a map using vertmap

# Point map, using output from occurrencelist, example 2, a species with more data
out <- occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE,
   maxresults = 100)
gbifmap_list(input = out) # make a map
gbifmap_list(input = out, region = 'USA') # make a map, just using the US map

# Point map, using output from occurrencelist, many species
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
out <- occurrencelist_many(splist, coordinatestatus = TRUE, maxresults = 20)
gbifmap_list(out)

# Point map, using output from occurrencelist, many species
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa', 'Ceyx fallax',
   'Picoides lignarius', 'Campephilus leucopogon')
out <- occurrencelist_many(splist, coordinatestatus = TRUE, maxresults = 100)
gbifmap_list(out)

# Get occurrences or density by area, using min/max lat/long coordinates
# Setting scientificname="*" so we just get any species
out <- occurrencelist(scientificname="*", minlatitude=30, maxlatitude=35,
   minlongitude=-100, maxlongitude=-95, coordinatestatus = TRUE, maxresults = 500)

# Using `geom_point`
gbifmap_list(out, "state", "texas", geom_point)

# Using geom_jitter to move the points apart from one another
gbifmap_list(out, "state", "texas", geom_jitter, position_jitter(width = 0.3,
   height = 0.3))

# And move points a lot
gbifmap_list(out, "state", "texas", geom_jitter, position_jitter(width = 1, height = 1))

# Customize the plot by passing options to `ggplot()`
mycustom <- function(){
   list(geom_point(size=9)
       )}
out <- occurrencelist(scientificname = 'Accipiter erythronemius',
   coordinatestatus = TRUE, maxresults = 100)
gbifmap_list(out, customize = mycustom())
}
}

