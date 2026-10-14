# Estimate air pollution concentrations in a postcode with PC6 database.

[Postcode6(PC6)](https://service.pdok.nl/cbs/postcode6/atom/postcode6_volledige_postcode.xml)
by the CBS, contains the geographic region of every postcode in the
Netherlands. `pollutionFromPc6()` query's the geographic region of all
given postcodes. Subsequently it uses ELAPSE to calculate the average,
minimum & maximum concentration of every air pollutant in that region.
In addition it collects the amount of buildings in that region.

## Usage

``` r
pollutionFromPc6(postcodes, pc6_path, elapse_path, ...)
```

## Arguments

- postcodes:

  string or vector of strings Containing PC6 postcodes.

- pc6_path:

  string Path to the Postcode6 database.

- elapse_path:

  *optional* string Path to the ELAPSE database.

## Value

simple feature collection. for every postcode the average, minimum &
maximum air pollutant concentration. In addition the geographic area of
that postcode.

## Examples

``` r
if (FALSE) { # \dontrun{
## Packages used in plotting
library(tidyverse)
library(tidyterra)

## Get the spacial area's associated with postcodes.
data("oneHunderdAddresses")

pc6 <- pollutionFromPc6(oneHunderdAddresses, "./data/cbs_pc6_2024.gpkg")

head(pc6, 5)

## Plot the spacial features, and NO2 concentration across the Netherlands.
elapse <- loadElapse()

ggplot() +
  geom_spatraster(data = elapse$NO2FULL) +
  geom_sf(data = pc6, aes(geometry = geom), colour = "purple") +
  scale_fill_grass_c(transform = "log10")
} # }
```
