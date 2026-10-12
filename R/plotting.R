#' Zoom into given spacial feature
#'
#' @description
#' Builds an ggplot coordinate system that zooms into a given set of spacial
#' features. Spacial features can be generated using the `pollutionFromBag()`
#' for `pollutionFromPc6()` functions. Use with `geom_rectFeature()` to inset
#' plots.
#'
#' When passing spacial features only pass the geometry column using subsetting:
#' `data$geom`. Select specific features or ranged by: `data$geom[2]` or
#' `data$geom[2:20]`.
#'
#' @param spacial_features to zoom on.
#' @param size of the zoom always a square.
#'
#' @examples
#' \dontrun{
#' # You need to use this with a plot so the basics
#' library(tidyverse)
#' library(tidyterra)
#' library(postcodElapse)
#'
#' data <- pollutionFromBag("9726AC", "bag-light.gpkg")
#'
#' elapse <- loadElapse()
#'
#' # We are zooming in on the 3rd building.
#' ggplot() +
#'    geom_spatraster(data = elapse$NO2FULL) +
#'    geom_sf(data = data, aes(geometry = geom), colour = "red") +
#'    coord_zoomFeature(data[3, ]) # you must index with `[3, ]` the entire row is expected!
#'
#' # On the 5th trough 10th buildings
#' ggplot() +
#'    geom_spatraster(data = elapse$NO2FULL) +
#'    geom_sf(data = data, aes(geometry = geom), colour = "red") +
#'    coord_zoomFeature(data[5:10, ])
#' }
#'
#' @export
coord_zoomFeature <- function(spacial_features, size = 2000, ...) {
  # did we get spacial data?
  if ((!"sfc" %in% class(spacial_features))) {
    stop("Argument data arent spacial features. Was `data$geom` used?")
  }

  # If the geoms are MULTIPOLYGONS first find the center then calculate the bbox
  geom_multipolygon <- FALSE
  tryCatch({
    geom_multipolygon <- sf::st_geometry_type(spacial_features, by_geometry = FALSE) == "MULTIPOLYGON"
  })

  if (geom_multipolygon) {
    bbox <- sf::st_bbox(sf::st_centroid(spacial_features))
  } else {
    bbox <- sf::st_bbox(spacial_features) #otherwise just directly calculate the bbox.
  }

  size <- size / 2

  # Build ggplot coord_sf with bbox.
  return(
    ggplot2::coord_sf(xlim = c(bbox$xmin - size, bbox$xmax + size),
                      ylim = c(bbox$ymin - size, bbox$ymax + size),
                      ...)
  )
}

#' Draws squares encompassing spacial features.
#'
#' @description
#' Takes a set of spacial features calculates the position and size of an square
#' encompassing all given spacial features. Builds and outputs ggplot geom_rect
#' to draw that square on a plot.
#'
#' When passing spacial features only pass the geometry column using subsetting:
#' `data$geom`. Select specific features or ranged by: `data$geom[2]` or
#' `data$geom[2:20]`.
#'
#' @param spacial_features to zoom on.
#' @param size of the rectangle.
#'
#' @examples
#' \dontrun{
#' # Some plotting basics
#' library(tidyverse)
#' library(tidyterra)
#' library(postcodElapse)
#'
#' data <- pollutionFromBag("9726AC", "bag-light.gpkg")
#'
#' elapse <- loadElapse()
#'
#' # Draw a box around 3rd building.
#' ggplot() +
#'    geom_spatraster(data = elapse$NO2FULL) +
#'    geom_sf(data = data, aes(geometry = geom), colour = "red") +
#'    geom_reactFeature(data[3, ])
#'
#' # On the 5th trough 10th buildings
#' ggplot() +
#'    geom_spatraster(data = elapse$NO2FULL) +
#'    geom_sf(data = data, aes(geometry = geom), colour = "red") +
#'    geom_rectFeature(data[5:10, ])
#' }
#'
#' @export
geom_rectFeature <- function(spacial_features,
                             size = 4000,
                             colour = "red",
                             fill = NA,
                             ...) {
  # did we get spacial data?
  if ((!"sfc" %in% class(spacial_features))) {
    stop("Argument data arent spacial features. Was `data$geom` used?")
  }
  bbox <- sf::st_bbox(spacial_features)

  df_bbox <- data.frame(
    xmin = bbox$xmin - size,
    xmax = bbox$xmax + size,
    ymin = bbox$ymin - size,
    ymax = bbox$ymax + size
  )

  return(
    ggplot2::geom_rect(data = df_bbox, ggplot2::aes(xmin = xmin, xmax = xmax,
                                                    ymin = ymin, ymax = ymax),
                       colour = colour, fill = fill, ...)
  )
}
