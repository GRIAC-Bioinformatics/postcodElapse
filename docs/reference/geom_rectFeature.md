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
