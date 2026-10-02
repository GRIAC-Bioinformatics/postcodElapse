# postcodElapse

Estimate PM<sub>2.5</sub>, BC, NO<sub>2</sub> and O<sub>3</sub> concentrations
for Dutch postal codes. Trough
the [ELAPSE](https://doi.org/10.1016/j.envint.2018.07.036) model in addition with
a postcode database containing the geographic location of every postcode in the
Netherlands. My thanks go to [Kees de
Hoogh](https://orcid.org/0000-0001-5974-2007) for developing & allowing the use
of [ELAPSE](https://doi.org/10.1016/j.envint.2018.07.036) in this package.

## Quick start

### R-spatial
Ensure you have the [terra](https://rspatial.github.io/terra/index.html) R-package
correctly installed for you OS. See [their guide](https://rspatial.github.io/terra/index.html#installation)

### Postcode database

postcodElapse **requires** an extra database containing the location of Dutch postcodes. 
Two are supported, download at-least one:

- [Basisregistratie Adressen en Gebouwen](https://service.pdok.nl/lv/bag/atom/bag.xml)(BAG) 
  Note 8Gigabyte in size.
- [Postcode6](https://service.pdok.nl/cbs/postcode6/atom/postcode6_volledige_postcode.xml)(PC6)
  Only 0.5Gigabyte.

### Install
Download the latest 
[release](https://github.com/GRIAC-Bioinformatics/postcodElapse/releases)of
postcodElapse, run the command below pointing at the package install file.

``` r
install.packages("postcodElapse_0.1.0.tar.gz")
```

If you are using Rstudio you can use the packages tab, nativate there press the
"Install" button. Change "Install from:" to "Package Archive ...", open the file
picker. Navigate to and open the downloaded postcodElapse release. Press "Install",
and youre done.

## Examples

The example below shows how to get air pollution estimates using the `postcodElapse()`
function, using the BAG database. The same command works for PC6 just change the path.

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

Both postcodes are public locations!
```

Postcodes must be four numbers two letters an example: `1234AB`. postcodElapse
will remove any added spaces and capitalize all letters, keep this in mind when
joining data.

# FAQ
## I am getting null-pointer errors!
```
Error in .Call(list(name = "CppField__get", address = <pointer: (nil)>,  : 
  NULL value passed as symbol address
```
Remove the currently loaded ELAPSE variable from your environment with `rm()`.
And run `loadElapse()` again. 

ELAPSE is loaded as an spatraster which contains a reference to the files 
containing the actual data. This reference also called an pointer it is not saved 
in .Rdata when restarting R or Rstudio, thus you get the null-pointer errors. 
In the future ensure you don't save any instances of spatrasters in your .Rdata
and or at the end off your scripts run `rm(<your elapse varabele>)`.

## I want to plot elapse
I recommend you use the [tidyverse](https://tidyverse.org/) & [tidyterra](https://dieghernan.github.io/tidyterra/)
packages. See `vignette("Spacial-plotting")` for more info on plotting.
