# Zoom into given spacial feature (Broken on Windows.)

Builds an ggplot coordinate system that zooms into a given set of
spacial features. Spacial features can be generated using the
[`pollutionFromBag()`](https://griac-bioinformatics.github.io/postcodElapse/reference/pollutionFromBag.md)
for
[`pollutionFromPc6()`](https://griac-bioinformatics.github.io/postcodElapse/reference/pollutionFromPc6.md)
functions. Use with
[`geom_rectFeature()`](https://griac-bioinformatics.github.io/postcodElapse/reference/geom_rectFeature.md)
to inset plots.

When passing spacial features only pass the geometry column using
subsetting: `data$geom`. Select specific features or ranged by:
`data$geom[2]` or `data$geom[2:20]`.

## Usage

``` r
coord_zoomFeature(spacial_features, size = 2000, ...)
```

## Arguments

- spacial_features:

  to zoom on.

- size:

  of the zoom always a square.

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

## Zoom into the 10th postal address
base + coord_zoomFeature(pc6$geom[10])

## Zoom into 10th trogh 15th postal addresses.
base + coord_zoomFeature(pc6$geom[10:15])
} # }
```
