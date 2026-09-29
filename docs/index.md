# postcodElapse

postcodElapse provides air pollution estimates for the Netherlands from
Duch postal codes. It does this by querying a given postcodes
geolocation from public databases. Subsequently this postition
imformation is used to extract air pollution estimates from the Effects
of Low-Level Air Pollution: A Study in Europe (ELAPSE) model.

## Installation

### Setup

#### R-spatial

postcodElapse requires
[terra](https://rspatial.github.io/terra/index.html) witch you might
have to install beforehand, for Windows and Mac run the command below.

``` r

install.packages('terra', repos='https://rspatial.r-universe.dev')
```

When R prompts: “Do you want to install from sources…” awnser **no**
then it should install the package. If in doubt check the [installation
guide](https://rspatial.github.io/terra/index.html#installation) of
terra.

### Databases

One of the extra databases below is **required**, chose one or both.

- [Basisregistratie Adressen en
  Gebouwen](https://service.pdok.nl/lv/bag/atom/bag.xml)(BAG), Note
  8Gigabyte in size.
- [Postcode6](https://service.pdok.nl/cbs/postcode6/atom/postcode6_volledige_postcode.xml)(PC6)
  Only 0.5Gigabyte.

The ELAPSE model is optional it is included in postcodElapse, if you
wish use your own that is possible. It is expected as an single tiff
image containing multiple layers representing air pollution
concentration.

### Install

To install download the postcodElapse source package onto your device.
Run the command below, ensure you are pointing at the file!

``` r

install.packages("postcodElapse_0.0.0.9610.tar.gz")
```

You can also use the Rstudio packages tab, navigate there press the
“Install” button. Change “Install from:” to “Package Archive …”, open
the file picker. Navigate to and open the postcodElapse package
download. Press “Install”, and youre done.

## Example

The example below shows how to get air pollution estimates using the
[`postcodElapse()`](reference/postcodElapse.md) function, using the BAG
database. The same command works for PC6 just change the path.

``` r

library(postcodelapse)

postcodElapse(c("8917DD", "9712CP"), "./bag-light.gpkg")
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

# Both postcodes are public locations!
```

The “n” column contains the amount of buildings in the given postcodes.
The rest of the variables are the mean, maximum & minimum air pollutant
concentration for all layers in ELAPSE.

# FAQ

## I am getting null-pointer errors!

    Error in .Call(list(name = "CppField__get", address = <pointer: (nil)>,  :
      NULL value passed as symbol address

Remove the currently loaded ELAPSE variable from your environment with
[`rm()`](https://rdrr.io/r/base/rm.html). And run
[`loadElapse()`](reference/loadElapse.md) again.

ELAPSE is loaded as an spatraster which contains a reference to the
files containing the actual data. This reference also called an pointer
it is not saved in .Rdata when restarting R or Rstudio, thus you get the
null-pointer errors. In the future ensure you don’t save any instances
of spatrasters in your .Rdata and or at the end off your scripts run
`rm(<your elapse varabele>)`.

## I want to plot elapse

I recommend you use the [tidyverse](https://tidyverse.org/) &
[tidyterra](https://dieghernan.github.io/tidyterra/) packages. See
[`vignette("postcodElapse")`](articles/postcodElapse.md) for more info
on plotting.
