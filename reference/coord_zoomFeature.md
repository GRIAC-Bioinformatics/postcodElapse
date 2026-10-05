# Zoom into given feature

Takes an simple features collection, i.e. the output form the
polltionFrom\*() functions. Computes the center of the given features
and builds a coordinate transform that zooms into the given features.

## Usage

``` r
coord_zoomFeature(data, r = 2000, ...)
```

## Arguments

- data:

  data to zoom on.

- r:

  radius of the zoom.

## IMPORTANT NOTE

When passing a specific feature ensure you index using `[2, ]`. Add the
comma otherwise R does not pass the entire row. `coord_zoomFeature()`
expects the entire row!

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
   coord_zoomFeature(data[3, ]) # you must index with `[3, ]` the entire row is expected!

# On the 5th trough 10th buildings
ggplot() +
   geom_spatraster(data = elapse$NO2FULL) +
   geom_sf(data = data, aes(geometry = geom), colour = "red") +
   coord_zoomFeature(data[5:10, ])
} # }
```
