# postcodElapse

PostcodElapse is an R-package for estimating the levels of air pollution including fine particulate matter (PM<sub>2.5</sub>), black carbon (BC), nitrogen dioxide (NO<sub>2</sub>) and ozone (O<sub>3</sub>) at postal code level in the Netherlands. The package utilizes the [ELAPSE Land Use Regression model](https://doi.org/10.1016/j.envint.2020.106267) and a GeoPackage containing spatial data on all Dutch postal codes.

We gratefully acknowledge [Kees de Hoogh](https://orcid.org/0000-0001-5974-2007)
for developing the [ELAPSE](https://doi.org/10.1016/j.envint.2020.106267) model
and for granting permission to use it within this package.

## Quick start

### R-spatial
PostcodElapse relies on the terra package for spatial data handling. Ensure that terra is correctly install for your operating system, detailed instructions are available in the [terra installation guide.](https://rspatial.github.io/terra/index.html#installation)

### Postcode database
PostcodElapse **requires ** an external database with the spatial data on Dutch postcodes. Two databases are currently supported, download the preferred database:

1. [BAG (Basisregistratie Adressen en Gebouwencontains)](https://service.pdok.nl/lv/bag/atom/bag.xml) for every building in the Netherlands the location and postal code. Package size 8GB

1. [PC6 (Postcode6)](https://service.pdok.nl/cbs/postcode6/atom/postcode6_volledige_postcode.xml) provides the geographic area for every Dutch postal code. Package size 0.5GB

### Installation
Download the latest
[release](https://github.com/GRIAC-Bioinformatics/postcodElapse/releases) of
postcodElapse, and install the package using:

``` r
install.packages("postcodElapse_0.1.4.tar.gz")
```

If you are using RStudio, you can also install via the *Packages* panel:

1. Open the *Packages* panel and click *Install*.
2. Set *Install from* to *Package Archive File (.zip; .tar.gz)*.
3. Use the file picker to navigate to the downloaded postcodElapse release.
4. Select the file an click *Install*.

## Example

``` r
library(postcodelapse)

postcodElapse(c("8917DD", "9712CP"), "~/home/data/bag-light.gpkg")
#> Guessed db type to be: BAG
#>   postcode n BCFULL_avg NO2FULL_avg O3FULLa_avg O3FULLc_avg O3FULLw_avg
#> 1   8917DD 5   1.637956    28.14168    60.92046    46.11469    76.49764
#> 2   9712CP 8   1.735555    30.59054    62.10056    45.57095    78.96525
#>   PM25FULLt_avg BCFULL_min NO2FULL_min O3FULLa_min O3FULLc_min O3FULLw_min
#> 1      15.56012   1.587243    26.23440    59.97551    45.97074    75.85178
#> 2      14.88488   1.731880    30.42194    61.52977    45.15801    78.12064
#>   PM25FULLt_min BCFULL_max NO2FULL_max O3FULLa_max O3FULLc_max O3FULLw_max
#> 1      15.34430   1.674501    29.16468    62.22285    46.32064    77.46275
#> 2      14.84346   1.736912    30.79544    62.71158    45.99726    79.83811
#>   PM25FULLt_max
#> 1      15.64734
#> 2      15.03059
```

Above, the air pollution  levels for two postal codes are estimated with the BAG database. All air pollutant levels are provided in µg/m<sub>3</sub>. The `n` column indicates the number of buildings found per postal code. Any missing data is marked with NA. When using PC6, the output has the same structure. 

## Spacial plotting
For visualization, it is recommended to use  the [tidyverse](https://tidyverse.org/) ecosystem in conjunction with (https://dieghernan.github.io/tidyterra/). Further details and examples are provided in the spacial [spacial plotting](https://griac-bioinformatics.github.io/postcodElapse/articles/Spacial-plotting.html) article.

# Common issues
## NULL value passed as symbol address
`loadElapse()` Returns [spatical rasters (spatrasters)](https://rspatial.org/spatial/4-rasterdata.html#spatraster) these **cannot be saved** into the workspace image. Doing this will result in errors like the one below:
``` r
ggplot2::autoplot(elapse)
#> Error in .Call(list(name = "CppField__get", address = <pointer: (nil)>,  : 
#>   NULL value passed as symbol address
```
To fix this remove all spatrasters with `?rm`, at the end of an script.
