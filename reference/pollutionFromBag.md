# Estimate air pollution concentrations in a postcode with BAG database.

Kadaster's [Basisregistratie Adressen en
Gebouwen](https://www.pdok.nl/introductie/-/article/basisregistratie-adressen-en-gebouwen-ba-1)
database contains for all buildings in the Netherlands their location
and postcode. `pollutionFromBag()` finds the geo-location of all
buildings part of the given postcodes. Then extracts the air pollutant
concentrations at those geo-locations from ELAPSE. Returned are all
pollution estimates for every building in the wanted postcodes,
including the geo-location.

## Usage

``` r
pollutionFromBag(postcodes, bag_path, elapse_path, ...)
```

## Arguments

- postcodes:

  string or vector of strings Containing Duch postcodes.

- bag:

  string Path to BAG database.

- elapse:

  *optional* Path to ELAPSE. (When empty will load internal ELAPSE)

## Value

data.frame containing air pollution estimates and geo-location for all
buildings in the given postcodes

## Examples

``` r
if (FALSE) { # \dontrun{
# Basic usage
pollutionFromBag("9726AC", "bag-light.gpkg")

# Plotting the location of all buildings,
# I recommend you use tidyverse & tidyterra
library(tidyverse)
library(tidyterra)
library(postcodElapse)

data <- pollutionFromBag("9726AC", "bag-light.gpkg")

elapse <- loadElapse()

ggplot() +
   geom_spatraster(data = elapse$NO2FULL) +
   geom_sf(data = data, aes(geometry = geom), colour = "red")
} # }
```
