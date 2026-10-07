# Draws squares encompassing spacial features.

Takes a collection of spacial features calculates the position and size
of an square encompassing all given spacial features. Builds and outputs
ggplot geom_rect to draw that square on a plot.

## Usage

``` r
geom_rectFeature(data, size = 4000, colour = "red", fill = NA, ...)
```

## Arguments

- data:

  data to zoom on.

- size:

  size of the rectangle.

- colour:

  border colour of the rectangle.

## IMPORTANT NOTE

When passing a specific feature ensure you index using `[2, ]`. Add the
comma otherwise R does not pass the entire row. `geom_rectFeature()`
expects the entire row!

## Examples

``` r
if (FALSE) { # \dontrun{
# Some plotting basics
library(tidyverse)
library(tidyterra)
library(postcodElapse)

data <- pollutionFromBag("9726AC", "bag-light.gpkg")

elapse <- loadElapse()

# Draw a box around 3rd building.
ggplot() +
   geom_spatraster(data = elapse$NO2FULL) +
   geom_sf(data = data, aes(geometry = geom), colour = "red") +
   geom_reactFeature(data[3, ])

# On the 5th trough 10th buildings
ggplot() +
   geom_spatraster(data = elapse$NO2FULL) +
   geom_sf(data = data, aes(geometry = geom), colour = "red") +
   geom_rectFeature(data[5:10, ])
} # }
```
