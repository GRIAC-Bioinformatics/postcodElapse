# Spacial plotting

``` r

library(postcodElapse)
```

## Spacial plotting

The data postcodElapse handles inherently has an spacial component so
plotting the data is of interest in some cases. There is one problem
tough base R plotting doesn’t handle spacial data well. I recommend you
install the `tidyverse` and `tidyterra` packages, this equips us with
ggplot2 and tidyterra enhances ggplot2 with spacial plotting.

### ELAPSE

Remember I said terra models air pollution concentration across Europe,
well lets plot the internal one and took at the structure. See below.

``` r

# Remember to install these!
library(tidyverse)
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.2.1     ✔ readr     2.2.0
#> ✔ forcats   1.0.1     ✔ stringr   1.6.0
#> ✔ ggplot2   4.0.3     ✔ tibble    3.3.1
#> ✔ lubridate 1.9.5     ✔ tidyr     1.3.2
#> ✔ purrr     1.2.2     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
library(tidyterra)
#> 
#> Attaching package: 'tidyterra'
#> 
#> The following object is masked from 'package:stats':
#> 
#>     filter

elapse <- loadElapse()

ggplot() +
  geom_spatraster(data = elapse) +
  facet_wrap(~ lyr)
#> <SpatRaster> resampled to 500490 cells.
```

![](Spacial-plotting_files/figure-html/plotting%20ELAPSE-1.png)

We can see the shape of the Netherlands well, if you want to change the
fill color I recommend reading the docs of
[`?tidyterra::scale_fill_grass_c`](https://dieghernan.github.io/tidyterra/reference/scale_grass.html).
Now we are going to plot the location of postcodes ontop of ELAPSE.

For this we are using
[`pollutionFromPc6()`](https://griac-bioinformatics.github.io/postcodElapse/reference/pollutionFromPc6.md)
which is one layer deeper into postcodeLapse, first lets run it without
plotting

``` r

data_pc6 <- pollutionFromPc6("9713AV", "../../../data/cbs_pc6_2024.gpkg")
#> Guessed db type to be: PC6

data_pc6
#> Simple feature collection with 1 feature and 20 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 234015.1 ymin: 582553.7 xmax: 234196 ymax: 582720.1
#> Projected CRS: Amersfoort / RD New
#>   postcode  n BCFULL_avg NO2FULL_avg O3FULLa_avg O3FULLc_avg O3FULLw_avg
#> 1   9713AV NA    1.87643     31.3348    59.92856    44.74765    77.72683
#>   PM25FULLt_avg BCFULL_min NO2FULL_min O3FULLa_min O3FULLc_min O3FULLw_min
#> 1      15.53723   1.874042    31.10718     59.8123    44.69811     77.5975
#>   PM25FULLt_min BCFULL_max NO2FULL_max O3FULLa_max O3FULLc_max O3FULLw_max
#> 1       15.4238   1.878818    31.56242    60.04483     44.7972    77.85616
#>   PM25FULLt_max                           geom
#> 1      15.65066 MULTIPOLYGON (((234060.7 58...
```
