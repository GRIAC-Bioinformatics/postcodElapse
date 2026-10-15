# Estimate air pollution levels for Dutch postal addresses using BAG.

Kadaster's [Basisregistratie Adressen en
Gebouwen](https://www.pdok.nl/introductie/-/article/basisregistratie-adressen-en-gebouwen-ba-1)
database contains for all buildings in the Netherlands their location
and postal address. `pollutionFromBag()` estimates air pollutant levels
for a given set of postal addresses by: Querying spatial data of all
buildings part of the given postal addresses from BAG. Subsequently
extracting air pollution estimates from ELAPSE using the spatial data.

## Usage

``` r
pollutionFromBag(postcodes, bag_path, elapse_path, ...)
```

## Arguments

- postcodes:

  Dutch postal addresses.

- bag:

  Path to BAG database.

- elapse:

  Path to ELAPSE, when empty uses internal ELAPSE.

## Value

data.frame where each row represents a building with the following
columns containing:

- The postcode of a building.

- Concentration estimates for air pollutant levels, in µg/m³

- Spacial points representing the geographic location of a building.

## Examples

``` r
if (FALSE) { # \dontrun{
## Packages used in plotting
library(tidyverse)
library(tidyterra)

## Get the spacial points associated with postcodes.
data("oneHunderdAddresses")

bag <- pollutionFromBag(oneHunderdAddresses, "./data/bag-light.gpkg")

head(bag, 5)

## Plot the spacial features, and NO2 concentration across the Netherlands.
elapse <- loadElapse()

ggplot() +
  geom_spatraster(data = elapse$NO2FULL) +
  geom_sf(data = bag, aes(geometry = geom), colour = "orange") +
  scale_fill_grass_c(transform = "log10")
} # }
```
