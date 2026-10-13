#' Plot ELAPSE layered with GeoPackages.
#'
#' @description
#'
#' @param elapse **optional** file-paht to an ELAPSE.tif
#'
#' @export
plotElapse <- function(elapse,
                       postcodes,

                       BAG_path,
                       BAG_colour = "orange",

                       PC6_path,
                       PC6_fill = "purple",
                       PC6_alpha = 0.7,

                       annotate_postcodes,
                       annotate_size = 4000,
                       annotate_colour = "red",

                       zoom_postcodes,
                       zoom_size = 2000,
                       no_facet = FALSE) {

  if (missing(elapse)) {
    message("No ELAPSE given loading internal.")
    elapse <- loadElapse()
  }

  #Plot ELAPSE layer
  figure <- ggplot2::ggplot() +
    tidyterra::geom_spatraster(data = elapse)

  # Plot the given geopackages + styling.
  if (!missing(postcodes)) { #Got postcodes? try to plot.
    #To plot we need atleas one GeoPackage, if none are given error.
    if (missing(PC6_path) & missing(BAG_path)) {
      stop("Got postcodes but no GeoPackage, provide at-least one GeoPackage.")
    }

    if (!missing(BAG_path)) {
      message("Plotting BAG from: ", BAG_path)
      bag <- pollutionFromBag(postcodes, BAG_path)

      figure <- figure + ggplot2::geom_sf(data = bag, ggplot2::aes(geometry = geom),
                                          colour = BAG_colour)
    }

    if (!missing(PC6_path)) {
      message("Plotting PC6 from: ", PC6_path)
      pc6 <- pollutionFromPc6(postcodes, PC6_path)

      figure <- figure + ggplot2::geom_sf(data = pc6, ggplot2::aes(geometry = geom),
                                          fill = PC6_fill, alpha = PC6_alpha)
    }
  }

  #Scale the figure colour
  figure <- figure + tidyterra::scale_fill_grass_c()

  #Add Annotate or zoom
  if (!missing(annotate_postcodes) & !missing(zoom_postcodes)) {
    stop("Cannot add annotate and zoom plot at the same time.")
  }

  if (!missing(annotate_postcodes)) { # Add annotation using geom_rectFeature()
    if (missing(PC6_path) & missing(BAG_path)) {
      stop("Got postcodes but no GeoPackage, provide at-least one GeoPackage.")
    }

    # I internaly decide wich data to use PC6 has priority.
    # Having the user decide would make this function even more conveluted.
    if (!missing(PC6_path)) {
      message("Using spacial data from PC6 to annotate.")
      spacial_data <- pc6
    } else if (!missing(BAG_path)) {
      message("Using spacial data from BAG to annotate.")
      spacial_data <- bag
    }
    spacial_data <- spacial_data |>
      dplyr::filter(postcode %in% annotate_postcodes)

    # This geom is provided by postcodElapse
    figure <- figure + geom_rectFeature(spacial_data$geom, annotate_size,
                                        annotate_colour)
  } else if (!missing(zoom_postcodes)) { # Add zoom using coord_zoomFeature()
    if (missing(PC6_path) & missing(BAG_path)) {
      stop("Got postcodes but no GeoPackage, provide at-least one GeoPackage.")
    }

    # Again PC6 has priority
    if (!missing(PC6_path)) {
      message("Using spacial data from PC6 to zoom.")
      spacial_data <- pc6
    } else if (!missing(BAG_path)) {
      message("Using spacial data from BAG to zoom.")
      spacial_data <- bag
    }
    spacial_data <- spacial_data |>
      dplyr::filter(postcode %in% zoom_postcodes)

    # This scale is provided by postcodElapse
    figure <- figure + coord_zoomFeature(spacial_data$geom, zoom_size)
  }

  #Do we facet?
  if (terra::nlyr(elapse) > 1 & !no_facet) {
    message("ELAPSE has multiple layers, adding facet_wrap()")
    figure <- figure + ggplot2::facet_wrap(ggplot2::vars(lyr))
  }

  #?Labels
  figure <- figure + ggplot2::labs(
    fill = bquote("µg/m"^3)
  )

  print(figure)
}

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
