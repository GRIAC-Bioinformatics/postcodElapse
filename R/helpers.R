# Format as postcode6
# Postcodes6 postcodes are 4 numbers followed by two capital letters. Example: "1234AB"
#' Format an string or vec of strings as PC6.
#'
#' This function attempts to format a given string or vec of strings as Dutch postal
#' addresses i.e. postcode6. Which is 4 numbers followed by two uppercase letters:
#' "1234AB". The function removes extra spaces from the given postal codes and makes
#' the letters uppercase. If it finds extra numbers or letters it errors.
#'
#' @param postcodes string or vec containing strings To be formatted as postcodes
#' @returns string or vec of srings Containing postcode6 formatted postal addresses.
#' @export
formatPc6 <- function(postcodes) {
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

#' Loads ELAPSE from the given path or from extdata.
#'
#' Load the ELAPSE dataset, expected as a single .tif image containing all layers off ELAPSE.
#' When given no path the func loads the ELAPSE model stored in the package.
#'
#' @param path *optional* Path to folder containing ELAPSE dataset.
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
