\name{gbifmap_dens}
\alias{gbifmap_dens}
\title{Make a simple map to visualize GBIF data density data}
\usage{
gbifmap_dens(input = NULL, mapdatabase = "world", region = ".",
  geom = geom_point, jitter = NULL, customize = NULL)
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
Map (using ggplot2 package) of points on a map or tiles on
a map.
}
\description{
This function is deprecated.
}
\details{
gbifmap takes care of cleaning up the data.frame (removing
NA's, etc.)  returned from rgbif functions, and creating
the map. This function gives a simple map of your data.
You can look at the code behing the function itself if you
want to build on it to make a map according to your
specfications.

Note that this function removes values that are impossible
on the globe, and those rows that have both lat and long as
NA or zeros.
}
\examples{
\dontrun{
# Tile map, using output from densitylist, Canada
out2 <- densitylist(originisocountrycode = "CA") # data for Canada
gbifmap_dens(out2) # on world map
gbifmap_dens(out2, region="Canada") # on Canada map

# Tile map, using gbifdensity, a specific data provider key
# 191 for 'University of Texas at El Paso'
out2 <- densitylist(dataproviderkey = 191) # data for the US
gbifmap_dens(out2) # on world map

# Modify the plotting region
out <- densitylist(originisocountrycode="US")
gbifmap_dens(out, mapdatabase="usa")
}
}
\seealso{
gbifmap
}

