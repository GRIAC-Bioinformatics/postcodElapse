#' Format strings as Dutch postcodes.
#'
#' This attempts to format any given string as an Dutch postcodes. IE. four numbers
#' followed by two capital letters, no spaces between each character. `formatPostcode()`
#' removes any spaces in a given string and capitalizes all letters. In addition
#' extra numbers and or letters are checked for, resulting in an if they are present.
#'
#' @param postcodes Strings to be formatted as postcode
#' @returns Strings formatted as postcodes
#'
#' @examples
#' formatPostcode("8 9 3 3 DV", "9 713 Gz", "1071 xx")
#'
#' @export
formatPostcode <- function(postcodes) {
  # Format all postcodes as PC6, e.g. for numbers directly followed by two capital letters
  postcodes_pc6 <- toupper(gsub(" ", "", postcodes))

  # Check if we did it correctly using regex. Otherwise error
  for(index in length(postcodes_pc6)) {
    if(!grepl("^[1-9][0-9]{3}?[A-Z]{2}$", postcodes_pc6[index])) {
      stop("Unable to format: \"", postcodes[index], "\" as PC6")
    }
  }

  return(postcodes_pc6)
}

#' Load ELAPSE form given file or extdata.
#'
#' @description
#' Expects ELAPSE as a single tiff grey-scale image containing multiple layers.
#' When path argument is not given loads ELAPSE from inst/ELAPSE.tif otherwise
#' uses the given path.
#'
#' @param path *optional* Path to .tif image containing ELAPSE
#' @return terra spatraster
#'
#' @export
loadElapse <- function(path) {
  # No path, get it for the internal ELAPSE.
  if(missing(path)) {
    path <- system.file("ELAPSE.tif", package = "postcodElapse")
  }
  if(!file.exists(path)) {
    stop(path, " Does not exist.")
  }

  elapse_stack <- terra::rast(path)

  return(elapse_stack)
}

# Simple helper that attempts to guess the type of an given gpkg database.
# I would like to use hashing but that doesn't play nice with differing R versions
# and platforms.
checkDb <- function(path) {
  # sf::st_layers() gives metadata about the given gpkg, here it is used to
  # determine the type of the database, if you want to add another DB just check
  # the output off sf::st_layers() and add another if case.
  tryCatch({
    metadata <- sf::st_layers(path)
  }, error = function(e) {
    stop("Failed to open database: ", path)
  })

  # Do the test
  if(identical(metadata$name, c("pand", "verblijfsobject", "ligplaats", "standplaats", "woonplaats"))) {
    type <- "BAG"
  } else if(identical(metadata$name, c("postcode6"))) {
    type <- "PC6"
  } else {
    stop("Unable to determine type of database: ", path)
  }

  message("Guessed db type to be: ", type)

  return(type)
}
