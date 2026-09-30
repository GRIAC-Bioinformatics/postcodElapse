# Zoom into given feature

Zoom into given feature

## Usage

``` r
coord_zoomFeature(data, r = 2000, ...)
```

## Arguments

- data:

  data to zoom on.

- r:

  radius of the zoom.

## Examples

``` r
if (FALSE) { # \dontrun{
# You need to use this with a plot so the basics
library(tidyverse)
library(tidyterra)
library(postcodElapse)

data <- pollutionFromBag("9726AC", "bag-light.gpkg")

elapse <- loadElapse()

# We are zooming in on the 3rd building.
ggplot() +
   geom_spatraster(data = elapse$NO2FULL) +
   geom_sf(data = data, aes(geometry = geom), colour = "red") +
   coord_zoomFeature(data[3])

# On the 5th trough 10th buildings
ggplot() +
   geom_spatraster(data = elapse$NO2FULL) +
   geom_sf(data = data, aes(geometry = geom), colour = "red") +
   coord_zoomFeature(data[5:10])
} # }
```
