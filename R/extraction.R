#' Estimate air pollutant concentraions for a given Dutch postcode.
#'
#' @description
#' Estimates air pollutant concentration for given Dutch postcodes. Using ELAPSE
#' (included) and a postcode database (not-included). Two postcode databases formatted
#' as Geopackage (.gpkg) are supported [Postcode6(PC6)](https://service.pdok.nl/cbs/postcode6/atom/postcode6_volledige_postcode.xml)
#' and [Basisregistratie Adressen en Gebouwen(BAG)](https://service.pdok.nl/lv/bag/atom/bag.xml)
#' download one of these and point the `database ` argument to it's location.
#' PostcodElapse automatically guesses the `type` argument, which you can set to
#' "PC6" or "BAG".
#'
#' @param postcodes String containing Dutch postcode (1234AB) can also be a vector.
#' @param database Path to the postcode database, see Postcode database below.
#' @param type Type of the postcode database, defaults to "GUESS" where postcodElapse
#' fills type in as "BAG" for Basisregistratie Adressen en Gebouwen or
#' "PC6" for Postcode6.
#' @param elapse_path When empty ELAPSE stored in extdata is used. Otherwise use
#' the one provided.
#'
#' @examples
#' \dontrun{
#' # Estimate air pollution for postcode "8933DV" with Postcode6.
#' postcodElapse("8933DV", "cbs_pc6_2024.gpkg")
#'
#' # Estimate air pollution for multiple postcodes with BAG.
#' postcodElapse(c("8933DV", "9713 GZ", "1071XX"), "bag-light.gpkg")
#'
#' # Postcodes are valid a long as they are four numbers followed by two letters.
#' # Any spaces will be removed and non-capital letters will be capitalized.
#' postcodElapse(c("8 9 3 3 DV", "9 713 Gz", "1071 xx"), "cbs_pc6_2024.gpkg")
#' }
#' @export
postcodElapse <- function(postcodes, database_path, database_type = "GUESS",
                          elapse_path) {
  if (missing(database_path)) {
    stop("Extra postcode database required, see ?postcodElapse on downloading.")
  }
  if (!file.exists(database_path)) {
    stop(database_path, " does not exist.")
  }
  if (!tools::file_ext(database_path) == "gpkg") {
    stop(database_path, " Is not an gpkg file.")
  }

  elapse <- loadElapse(elapse_path)

  # Check the type of the database given by the user, so we know how to extract
  # the data. And whine about it when we cannot identify the db.
  if (database_type == "GUESS") {
    database_type <- checkDb(database_path)
  }

  database_type <- toupper(database_type)
  if (database_type == "BAG") {
    postcode_pollution <- pollutionFromBag(postcodes,
                                           bag_path = database_path,
                                           elapse_path,
                                           pass_db_check = TRUE)

    # Of course multiple homes exist per postcode, so summarize.
    postcode_pollution_stats <- postcode_pollution |>
      dplyr::group_by(postcode) |>
      dplyr::summarise_at(tools::file_path_sans_ext(terra::names(elapse)),
                          list(avg = mean, min = min, max = max))

    # Counting how many homes per postcodes just makes sense
    postcode_pollution_stats <- postcode_pollution |>
      dplyr::count(postcode) |>
      dplyr::inner_join(postcode_pollution_stats, by = dplyr::join_by(postcode))

    # In case are missing postcodes warn about it.
    count_given_postcodes <- length(postcodes)
    count_found_postcodes <- nrow(postcode_pollution_stats)
    if (count_found_postcodes != count_given_postcodes) {
      warning("Found ", count_found_postcodes, " postcodes of the given ",
              count_given_postcodes, ".")
    }

  } else if(database_type == "PC6") {
    # Due to PC6 containing areas the statistics happen in pollutionFromPc6()
    # Just need to remove the unwanted geometry.
    postcode_pollution_stats <- sf::st_drop_geometry(
                                pollutionFromPc6(postcodes,
                                                lpc6_path = database_path,
                                                elapse_path,
                                                pass_db_check = TRUE))

  } else {
    stop("Nonsense db_type: ", database_type) # In case something goes wrong
  }
  rm(elapse) # Unload to prevent null-pointer errors.
  return(postcode_pollution_stats)
}

#' Estimate air pollution concentrations in a postcode with BAG database.
#'
#' @description
#' Kadaster's [Basisregistratie Adressen en Gebouwen](https://www.pdok.nl/introductie/-/article/basisregistratie-adressen-en-gebouwen-ba-1)
#' database contains for all buildings in the Netherlands their location and postcode.
#' `pollutionFromBag()` finds the geo-location of all buildings part of the given
#' postcodes. Then extracts the air pollutant concentrations at those geo-locations
#' from ELAPSE. Returned are all pollution estimates for every building in the
#' wanted postcodes, including the geo-location.
#'
#' @param postcodes string or vector of strings Containing Duch postcodes.
#' @param bag string Path to BAG database.
#' @param elapse *optional* Path to ELAPSE. (When empty will load internal ELAPSE)
#'
#' @return data.frame containing air pollution estimates and geo-location for all
#' buildings in the given postcodes
#' @examples
#' \dontrun{
#' # Basic usage
#' pollutionFromBag("9726AC", "bag-light.gpkg")
#'
#' # Plotting the location of all buildings,
#' # I recommend you use tidyverse & tidyterra
#' library(tidyverse)
#' library(tidyterra)
#' library(postcodElapse)
#'
#' data <- pollutionFromBag("9726AC", "bag-light.gpkg")
#'
#' elapse <- loadElapse()
#'
#' ggplot() +
#'    geom_spatraster(data = elapse$NO2FULL) +
#'    geom_sf(data = data, aes(geometry = geom), colour = "red")
#' }
#'
#' @export
pollutionFromBag <- function(postcodes, bag_path, elapse_path, ...) {
  pass_db_check <- list(...)$pass_db_check # grab optional parameter

  # if pass_db_check set assume that the parent did it's homework and checked the
  # database, otherwise we have to check ourselves. This is so we don't check the
  # db type twice, which is time consuming, each check takes 3100ms.
  if (is.null(pass_db_check)) {
    if (checkDb(bag_path) != "BAG") {
      stop(bag_path, " Does not seem to be an BAG database.")
    }
  }

  # Try to use ELAPSE from the parent-env, doesn't exist then.
  if (missing(elapse_path) && !exists("elapse")) {
    elapse <- loadElapse()
  }
  # when given a path for ELAPSE always use it.
  if (!missing(elapse_path)) {
    elapse <- loadElapse(elapse)
  }

  postcodes <- formatPostcode(postcodes)

  # The .gpkg file is an sqlite database, st_read() default loads the entire 8gb
  # database. Only the given postcodes are needed, st_read() supports using an
  # SQL-query's the one below is used
  # SELECT geom, postcode FROM verblijfsobject WHERE postcode IN ('####AA','####BB')
  # It query's for only the postcodes of interest producing the corresponding
  # location and postcode. The R statements below builds the query.
  postcodes_query <- paste0("('", paste(postcodes, collapse = "','"), "')")

  postcode_geo <- sf::st_read(bag_path, quiet = TRUE,
                              query = paste0("SELECT geom, postcode FROM verblijfsobject WHERE postcode IN ",
                                             postcodes_query))

  if (nrow(postcode_geo) < 1) {
    stop("None of the given postcodes where found in the BAG. This should not
         happen. Check if the schema changed in the database. And update the
         query accordingly.")
  }

  # Use the positions we just got to extract air quality form ELAPSE.
  geo_pollution <- terra::extract(elapse, postcode_geo)

  # We lost the postcodes during extraction, we want those so put them back.
  # A simple cbind() will do the data is already lined up.
  postcode_pollution <- cbind(geo_pollution, postcode_geo)

  # terra::extract add an ID column to the data for aligning purposes.
  # We don't need it in the output
  postcode_pollution <- postcode_pollution |>
    dplyr::select(!c(ID))

  return(postcode_pollution)
}

#' Estimate air pollution concentrations in a postcode with PC6 database.
#'
#' @description
#' [Postcode6(PC6)](https://service.pdok.nl/cbs/postcode6/atom/postcode6_volledige_postcode.xml)
#' by the CBS, contains the geographic region of every postcode in the Netherlands.
#' `pollutionFromPc6()` query's the geographic region of all given postcodes.
#' Subsequently it uses ELAPSE to calculate the average, minimum & maximum
#' concentration of every air pollutant in that region. In addition it collects
#' the amount of buildings in that region.
#'
#' @param postcodes string or vector of strings Containing PC6 postcodes.
#' @param pc6_path string Path to the Postcode6 database.
#' @param elapse_path *optional* string Path to the ELAPSE database.

#' @returns simple feature collection. for every postcode the average, minimum &
#' maximum air pollutant concentration. In addition the geographic area of that
#' postcode.
#'
#' @examples
#' \dontrun{
#' # basic use
#' pollutionFromPc6("9726AC", "cbs_pc6_2024.gpkg")
#'
#' # Plotting the area's, I recommend you use tidyverse & tidyterra
#' library(tidyverse)
#' library(tidyterra)
#' library(postcodElapse)
#'
#' data <- pollutionFromPc6("9726AC", "cbs_pc6_2024.gpkg")
#'
#' elapse <- loadElapse()
#'  ggplot() +
#'  geom_spatraster(data = elapse$NO2FULL) +
#'  geom_sf(data = data, aes(geometry = geom), colour = "red")
#' }
#'
#' @export
pollutionFromPc6 <- function(postcodes, pc6_path, elapse_path, ...) {
  pass_db_check <- list(...)$pass_db_check # grab optional parameter

  # if pass_db_check set assume that the parent did it's homework and checked the
  # database. Otherwise we have to check ourselves. This is so we don't check the
  # db type twice, which is expensive, each check takes 3100ms.
  if (is.null(pass_db_check)) {
    if (checkDb(pc6_path) != "PC6") {
      stop(pc6_path, " Does not seem to be an PC6 database.")
    }
  }

  if (missing(elapse_path) && !exists("elapse")) {
    elapse <- loadElapse()
  }
  if (!missing(elapse_path)) {
    elapse <- loadElapse(elapse_path)
  }

  # Build and SQL-query that for the wanted postcodes selects the area, postcode
  # and the amount of buildings stored in PC6. I figrued this out by looking at
  # the database schema.
  postcodes <- formatPostcode(postcodes)
  postcodes_query <- paste0("('", paste(postcodes, collapse = "','"), "')")

  postcode_geo <- sf::st_read(pc6_path, quiet = TRUE,
                              query = paste0("SELECT postcode6, geom, aantal_woningen FROM postcode6 WHERE postcode6 IN ",
                                             postcodes_query))

  # Use the areas we just got to extract pollution data form ELAPSE.
  # Because they are areas we must calculate average, minimum & maximum here.
  geo_pollution_mean <-  terra::extract(elapse, postcode_geo, fun = median)
  names(geo_pollution_mean) <- paste0(names(geo_pollution_mean), "_avg")

  geo_pollution_min <-  terra::extract(elapse, postcode_geo, fun = min)
  names(geo_pollution_min) <- paste0(names(geo_pollution_min), "_min")

  geo_pollution_max <-  terra::extract(elapse, postcode_geo, fun = max)
  names(geo_pollution_max) <- paste0(names(geo_pollution_max), "_max")

  # Put all statistics together and the postcodes.
  # No join_by() is needed the output is consistent
  geo_pollution_stats <- cbind(geo_pollution_mean,
                               geo_pollution_min,
                               geo_pollution_max)

  postcodes_pollution_stats <- cbind(postcode_geo, geo_pollution_stats)

  # Rename some columns and clean the output.
  # PC6 contains the multiple instances of value -99997. I am assuming this is
  # meant to me NA thus replacing with NA.
  postcodes_pollution_stats <- postcodes_pollution_stats |>
    dplyr::select(!c(ID_avg, ID_min, ID_max)) |>
    dplyr::rename(n = aantal_woningen) |>
    dplyr::rename(postcode = postcode6) |>
    dplyr::mutate(dplyr::across(dplyr::where(is.numeric), ~dplyr::na_if(., -99997)))

  return(postcodes_pollution_stats)
}
