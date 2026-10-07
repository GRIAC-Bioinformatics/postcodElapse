#' Zoom into given spacial feature
#'
#' @description
#' Takes the output from ether `pollutionFrom*()` function, calculates the center
#' of all given special features. Outputs ggplot coord to zoom into the given features.
#' Works best when sub-setting a lager data-set zooming into a feature of interest.
#'
#' @section IMPORTANT NOTE:
#' When passing a specific feature ensure you index using `[2, ]`. Add the comma
#' otherwise R does not pass the entire row. `coord_zoomFeature()` expects the
#' entire row!
#'
#' @param data data to zoom on.
#' @param r radius of the zoom, is always a square.
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
coord_zoomFeature <- function(data, r = 2000, ...) {
  data <- data$geom # I just want the geometery

  # If the geoms are MULTIPOLYGONS first find the center then calculate the bbox
  geom_multipolygon <- FALSE
  tryCatch({
    geom_multipolygon <- sf::st_geometry_type(data, by_geometry = FALSE) == "MULTIPOLYGON"
  })

  if(geom_multipolygon) {
    bbox <- sf::st_bbox(sf::st_centroid(data))
  } else {
    bbox <- sf::st_bbox(data) #otherwise just directly calculate the bbox.
  }

  r <- r / 2

  # Build ggplot coord_sf with bbox.
  return(
    ggplot2::coord_sf(xlim = c(bbox$xmin - r, bbox$xmax + r),
                      ylim = c(bbox$ymin - r, bbox$ymax + r),
                      ...)
  )
}

#' Draws squares encompassing spacial features.
#'
#' @description
#' Takes a collection of spacial features calculates the position and size of an
#' square encompassing all given spacial features. Builds and outputs ggplot
#' geom_rect to draw that square on a plot.
#'
#' @section IMPORTANT NOTE:
#' When passing a specific feature ensure you index using `[2, ]`. Add the comma
#' otherwise R does not pass the entire row. `geom_rectFeature()` expects the
#' entire row!
#'
#' @param data data to zoom on.
#' @param size size of the rectangle.
#' @param colour border colour of the rectangle.
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
geom_rectFeature <- function(data, size = 4000, colour = "red", fill = NA, ...) {
  bbox <- sf::st_bbox(data$geom)

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
