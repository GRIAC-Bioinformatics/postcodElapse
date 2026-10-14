# Draws squares encompassing spacial features.

Takes a set of spacial features calculates the position and size of an
square encompassing all given spacial features. Builds and outputs
ggplot geom_rect to draw that square on a plot.

When passing spacial features only pass the geometry column using
subsetting: `data$geom`. Select specific features or ranged by:
`data$geom[2]` or `data$geom[2:20]`.

## Usage

``` r
geom_rectFeature(spacial_features, size = 4000, colour = "red", fill = NA, ...)
```

## Arguments

- spacial_features:

  to zoom on.

- size:

  of the rectangle.

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

## Make base plot the spacial features, and NO2 concentration across the
## Netherlands.
elapse <- loadElapse()

base <- ggplot() +
  geom_spatraster(data = elapse$NO2FULL) +
  geom_sf(data = pc6, aes(geometry = geom), colour = "purple") +
  scale_fill_grass_c(transform = "log10")

## Annotate the position of the 10th postal address.
base + geom_rectFeature(pc6$geom[10])

## Annotate the 10th trough 15th postal addresses.
base + geom_rectFeature(pc6$geom[10:15])
} # }
```
