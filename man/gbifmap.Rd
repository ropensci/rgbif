\name{gbifmap}
\alias{gbifmap}
\title{Make a simple map to visualize GBIF data.}
\usage{
  gbifmap(input = NULL, mapdatabase = "world",
    region = ".", pointtype = geom_point,
    jitterposition = NULL)
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

  \item{pointtype}{The geom to use, one of geom_point or
  geom_jitter. Don't quote them.}

  \item{jitterposition}{If you use jitterposition, the
  amount by which to jitter points in width, height, or
  both.}
}
\value{
  Map (using ggplot2 package) of points or tiles on a world
  map.
}
\description{
  Basic function to plot your lat/long data on a map.
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
out <- occurrencelist(scientificname = 'Accipiter erythronemius', coordinatestatus = TRUE, maxresults = 100, latlongdf = T)
gbifmap(input = out) # make a map using vertmap

# Point map, using output from occurrencelist, example 2, a species with more data
out <- occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE, maxresults = 100, latlongdf = T)
gbifmap(input = out) # make a map
gbifmap(input = out, region = 'USA') # make a map, just plotting data for

# Point map, using output from occurrencelist, many species
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa', 'Buteo regalis')
out <- lapply(splist, function(x) occurrencelist(x, coordinatestatus = T, maxresults = 100, latlongdf = T))
gbifmap(out)

# Tile map, using output from densitylist, Canada
out2 <- densitylist(originisocountrycode = "CA") # data for Canada
gbifmap(out2) # on world map
gbifmap(out2, region="Canada") # on Canada map

# Tile map, using gbifdensity, a specific data provider key
# 191 for 'University of Texas at El Paso'
out2 <- densitylist(dataproviderkey = 191) # data for the US
gbifmap(out2) # on world map

# Get occurrences or density by area, using min/max lat/long coordinates
out <- occurrencelist(minlatitude=30, maxlatitude=35, minlongitude=-100, maxlongitude=-95,
		coordinatestatus = T, maxresults = 5000, latlongdf = T)

# Using `geom_point`
gbifmap(out, "state", "texas", geom_point)

# Using geom_jitter to move the points apart from one another
gbifmap(out, "state", "texas", geom_jitter, position_jitter(width = 0.3, height = 0.3))

# And move points a lot
gbifmap(out, "state", "texas", geom_jitter, position_jitter(width = 1, height = 1))
}
}

