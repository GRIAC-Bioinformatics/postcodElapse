# postcodElapse

postcodElapse is an R-package for estimating concentrations of fine particulate
matter (PM<sub>2.5</sub>), black carbon (BC), nitrogen dioxide (NO<sub>2</sub>)
& ozone (O<sub>3</sub>) at the level of Dutch postcodes. The package utilizes
  the ELAPSE model and an GeoPackage containing spatial data on all postcodes in
  the Netherlands.

We gratefully acknowledge [Kees de Hoogh](https://orcid.org/0000-0001-5974-2007)
for developing the [ELAPSE](https://doi.org/10.1016/j.envint.2018.07.036) model
and for granting permission to use it within this package.

## Quick start

### R-spatial
postcodElapse relies on the terra package for spatial data handling. Ensure that
terra is correctly install for your operating system, detailed instructions are
available in the [terra installation guide.](https://rspatial.github.io/terra/index.html#installation)

### Postcode database

postcodElapse **requires** an external database with the spatial data on Dutch
postcodes. Two databases are currently supported, download at least one of the
following:

- [Basisregistratie Adressen en Gebouwen](https://service.pdok.nl/lv/bag/atom/bag.xml)(BAG) 
  size: 8GB
- [Postcode6](https://service.pdok.nl/cbs/postcode6/atom/postcode6_volledige_postcode.xml)(PC6)
  size: 0.5GB

### Installation
Download the latest
[release](https://github.com/GRIAC-Bioinformatics/postcodElapse/releases) of
postcodElapse, and install the package using:

``` r
install.packages("postcodElapse_0.1.4.tar.gz")
```

If you are using RStudio, you can also install via the *Packages* pane:

1. Open the *Packages* pane and click *Install*.
2. Set *Install from* to *Package Archive File (.zip; .tar.gz)*.
3. Use the file picker to navigate to the downloaded postcodElapse release.
4. Select the file an click *Install*.

## Example

``` r
library(postcodelapse)

postcodElapse(c("8917DD", "9712CP"), "bag-light.gpkg")
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

Above we estimated the pollution concentration in two postcodes with BAG. All
air pollutant statistics are in µg/m<sup>3</sup>. The `n` column contains how
many buildings where found per postcode. When using PC6 the output has the same
structure, any missing data is marked with *NA*.

## Spacial plotting
For visualization, we recommend using the [tidyverse](https://tidyverse.org/)
ecosystem in conjunction with
[tidyterra](https://dieghernan.github.io/tidyterra/). Further details and
examples are provided in the [spacial plotting](https://griac-bioinformatics.github.io/postcodElapse/articles/Spacial-plotting.html)
article.

# FAQ
## I am getting null-pointer errors!
```
Error in .Call(list(name = "CppField__get", address = <pointer: (nil)>,  : 
  NULL value passed as symbol address
```
Remove the currently loaded ELAPSE variable from your environment with `rm()`.
And run `loadElapse()` again.

ELAPSE is loaded as an spatraster which contains a reference to the files
containing the actual data. This reference also called an pointer it is not
saved in .Rdata when restarting R or Rstudio, thus you get the null-pointer
errors. In the future ensure you don't save any instances of spatrasters in your
.Rdata and or at the end off your scripts run `rm(<your elapse varabele>)`.
