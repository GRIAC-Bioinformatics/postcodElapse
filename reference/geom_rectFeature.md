# ggplot annotation that draws an rect around a given spacial feature.

Computes the center of a set of given spacial features then creates a
[`geom_rect()`](https://ggplot2.tidyverse.org/reference/geom_tile.html)
centered and encompassing those spacial features. Meant to mark
locations on spacial plots. Or used in combination with
[`coord_zoomFeature()`](https://griac-bioinformatics.github.io/postcodElapse/reference/coord_zoomFeature.md)
to create inset plots.

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
