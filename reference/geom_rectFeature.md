# ggplot annotation that draws an rect around a given spacial feature. Combine with `coord_zoomFeature()` for pretty insetting.

ggplot annotation that draws an rect around a given spacial feature.
Combine with [`coord_zoomFeature()`](coord_zoomFeature.md) for pretty
insetting.

## Usage

``` r
geom_rectFeature(data, id, size = 2000, colour = "red", fill = NA, ...)
```

## Arguments

- data:

  data to zoom on.

- id:

  id of the data to zoom on

- size:

  size of the rectangle.

## Examples

``` r
if (FALSE) { # \dontrun{
# Some plotting basics
library(tidyverse)
library(tidyterra)
library(postcodElapse)

data <- pollutionFromBag("9726AC", "bag-light.gpkg")

elapse <- loadElapse()

# We are drawing a box around 3rd building.
ggplot() +
   geom_spatraster(data = elapse$NO2FULL) +
   geom_sf(data = data, aes(geometry = geom), colour = "red") +
   geom_reactFeature(data[3])

# On the 5th trough 10th buildings
ggplot() +
   geom_spatraster(data = elapse$NO2FULL) +
   geom_sf(data = data, aes(geometry = geom), colour = "red") +
   geom_rectFeature(data[5:10])
} # }
```
