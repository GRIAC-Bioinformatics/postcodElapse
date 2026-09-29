#' Zoom into given feature
#' @param data data to zoom on.
#' @param id id of the data to zoom on
#' @param r radius of the zoom.
#' @export
coord_zoomFeature <- function(data, id, r = 2000, ...) {
  data <- data$geom[[id]] # I just want the geometery

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

#' ggplot annotation that draws an rect around a given spacial feature.
#' Combine with `coord_zoomFeature()` for pretty insetting.
#' @param data data to zoom on.
#' @param id id of the data to zoom on
#' @param size size of the rectangle.
#' @export
geom_rectFeature <- function(data, id, size = 2000, colour = "red", fill = NA, ...) {
  bbox <- sf::st_bbox(data$geom[[id]])

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
