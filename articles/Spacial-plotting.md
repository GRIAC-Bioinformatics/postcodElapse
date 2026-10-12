# Spacial plotting

This article describes the method to plot the spacial data underlying
postcodElapse. To enable spatial plotting in R, installation of of the R
packages [tidyverse](https://tidyverse.org/),
[tidyterra](https://dieghernan.github.io/tidyterra/articles/tidyterra.html)
and [ggpubr](https://rpkgs.datanovia.com/ggpubr/) is required.

### ELAPSE

First, a map with the spatial relations of the postal codes is required.
In postcodElapse, ELAPSE is the best equivalent, which can be loaded and
plotted as indicated below:

``` r

library(tidyverse)
library(tidyterra)
library(ggpubr)
library(postcodElapse)

elapse <- loadElapse()

ggplot() +
  geom_spatraster(data = elapse) +
  facet_wrap(~ lyr)
#> <SpatRaster> resampled to 500490 cells.
```

![](Spacial-plotting_files/figure-html/plotting%20ELAPSE-1.png)

When plotting pass spacial data directly into a geom via the *data*
argument. Plotting a specific layer of ELAPSE can be done with the `$`
operator. Tidyterra’s
[`geom_spatraster()`](https://dieghernan.github.io/tidyterra/reference/geom_spatraster.html)
maps values extracted from spatrasters to the fill aestetic, to scale
the fill colour use
[`scale_fill_grass_c()`](https://dieghernan.github.io/tidyterra/reference/scale_grass.html).

## Accessing postal coded geo-locations

To plot the location of postcodes on ELAPSE the geo-location is
*required* these are provided trough:
[`pollutionFromBag()`](https://griac-bioinformatics.github.io/postcodElapse/reference/pollutionFromBag.md)
and
[`pollutionFromPc6()`](https://griac-bioinformatics.github.io/postcodElapse/reference/pollutionFromPc6.md).
These function output spacial data in the `geom` column. Plotting this
data can be done with
[`geom_sf()`](https://ggplot2.tidyverse.org/reference/ggsf.html), see
the block below.

``` r

path <- system.file("extdata/postcode100.rds", package = "postcodElapse")
postcode100 <- readRDS(path)

pc6 <- pollutionFromPc6(postcode100, "../../../data/cbs_pc6_2024.gpkg")
#> Guessed db type to be: PC6
bag <- pollutionFromBag(postcode100, "../../../data/bag-light.gpkg")
#> Guessed db type to be: BAG

ggplot() +
  geom_spatraster(data = elapse$NO2FULL) + 
  geom_sf(data = pc6, aes(geometry = geom), fill = "purple", alpha = 0.7) +
  geom_sf(data = bag, aes(geometry = geom), colour = "orange") +
  scale_fill_grass_c() +
  labs(fill = bquote("NO"[2]~"concentration in µg/m"^3))
#> <SpatRaster> resampled to 500490 cells.
```

![](Spacial-plotting_files/figure-html/layerd-1.png)

### Zooming and insetting

The scale of ELAPSE prohibits the visualization of the data. To
alleviate this, it is recommended to create an inset plot and mark the
location of the zoom in the main plot. postcodElapse provides two
functions to achive this:

- [`geom_rectFeature()`](https://griac-bioinformatics.github.io/postcodElapse/reference/geom_rectFeature.md)
  Draws a rectangle around an set of spatial features.
- [`coord_zoomFeature()`](https://griac-bioinformatics.github.io/postcodElapse/reference/coord_zoomFeature.md)
  Zooms into a set of spatial features.

See the example below on how to build an inset plot:

``` r

# Build the plots for the single figure separately
main <- ggplot() +
  geom_spatraster(data = elapse$NO2FULL) + 
  geom_sf(data = pc6, aes(geometry = geom), alpha = 0.7, fill = "purple") +
  geom_sf(data = bag, aes(geometry = geom), alpha = 0.7, colour = "orange") +
  scale_fill_grass_c(transform = "log10") +
  geom_rectFeature(pc6[100, ], 5000) + # Annotate a postal address
  labs(fill = bquote("log10 Concentration NO"[2]~"in µg/m"^3)) +
  theme(legend.position = "top")
#> <SpatRaster> resampled to 500490 cells.

inset <- ggplot() +
  geom_spatraster(data = elapse$NO2FULL) +
  geom_sf(data = pc6, aes(geometry = geom), alpha = 0.7, fill = "purple") +
  geom_sf(data = bag, aes(geometry = geom), alpha = 0.7, colour = "orange") +
  scale_fill_grass_c(transform = "log10") +
  coord_zoomFeature(pc6[100, ]) # Zoom into a postal address
#> <SpatRaster> resampled to 500490 cells.

# Combine the two plots into a single figure.
fig <- ggarrange(main, inset,
  ncol = 2,
  common.legend = TRUE,
  legend.grob = get_legend(main)
)

# Lable the figure
label <- 
"NO2 pollutant levels at postal code level in the Netherlands.
Purple areas are postal adrreses from PC6, orange dots are buildings from BAG."

annotate_figure(fig, 
  fig.lab.pos = "bottom.left",
  fig.lab = label
)
```

![](Spacial-plotting_files/figure-html/insetting-1.png)

The `geom_rectFeatrue()` and
[`coord_zoomFeature()`](https://griac-bioinformatics.github.io/postcodElapse/reference/coord_zoomFeature.md)
function expect entire rows of spacial data, subset you spacial data
using `[12, ]`.

With this material you can plot the spacial data of postcodes and
ELAPSE. To see all plotting options we recommend the documentation of
[ggplot](https://ggplot2.tidyverse.org/),
[tidyterra](https://dieghernan.github.io/tidyterra/articles/tidyterra.html)
and [ggpubr](https://rpkgs.datanovia.com/ggpubr/index.html_)
