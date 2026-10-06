# postcodElapse - Usage guide

## Overview

The goal of postcodElapse package is to estimate concentrations of fine
particulate matter (PM_(2.5)), black carbon (BC), nitrogen dioxide (NO₂)
& ozone (O₃) for Dutch postcodes, as an alternative to on-site
measurements.

This is achieved by:

1.  Obtaining geo-location information (points or areas) from one of two
    supported postcodes databases.
2.  Linking these locations to the ELAPSE air quality model.
3.  Calculate postcode-level air pollutant concentration estimates.

This vignette is a guide on setting up, running and utilizing
postcodElapse.

## Postcode databases

As described above, the geographic location or area of an postcode is
**required** in order to estimate air pollutant concentrations.
postcodElapse expects this data to be provided as GeoPackage (.gpkg)
files, a format commonly used for storing spatial data.

Currently, postcodElapse supports two GeoPackages:

1.  [BAG (Basisregistratie Adressen en
    Gebouwen](https://service.pdok.nl/lv/bag/atom/bag.xml)\
    The bag data set contains for every building in the Netherlands its
    location & postcode. Size 8GB

2.  [PC6
    (Postcode6)](https://service.pdok.nl/cbs/postcode6/atom/postcode6_volledige_postcode.xml)\
    provides the geographic area for every Dutch postcode. Size 0.6GB

The package assumes that these GeoPackages have been stored locally in a
location accessible to your R session.

## Estimating exposures

To estimate air pollutant concentration, call the main function
[`postcodElapse()`](https://griac-bioinformatics.github.io/postcodElapse/reference/postcodElapse.md)
with a postcode (can also be a vector) and the path to the relevant
GeoPackage.

``` r

library(postcodElapse)

postcodElapse("9713AV", "bag-light.gpkg")
#> Guessed db type to be: BAG
#>   postcode n BCFULL_avg NO2FULL_avg O3FULLa_avg O3FULLc_avg O3FULLw_avg
#> 1   9713AV 1   1.878818    31.10718    60.04483     44.7972    77.85616
#>   PM25FULLt_avg BCFULL_min NO2FULL_min O3FULLa_min O3FULLc_min O3FULLw_min
#> 1       15.4238   1.878818    31.10718    60.04483     44.7972    77.85616
#>   PM25FULLt_min BCFULL_max NO2FULL_max O3FULLa_max O3FULLc_max O3FULLw_max
#> 1       15.4238   1.878818    31.10718    60.04483     44.7972    77.85616
#>   PM25FULLt_max
#> 1       15.4238
#> Guessed db type to be: BAG
#>   postcode n BCFULL_avg NO2FULL_avg O3FULLa_avg O3FULLc_avg O3FULLw_avg
#> 1   9713AV 1   1.878818    31.10718    60.04483     44.7972    77.85616
#>   PM25FULLt_avg BCFULL_min NO2FULL_min O3FULLa_min O3FULLc_min O3FULLw_min
#> 1       15.4238   1.878818    31.10718    60.04483     44.7972    77.85616
#>   PM25FULLt_min BCFULL_max NO2FULL_max O3FULLa_max O3FULLc_max O3FULLw_max
#> 1       15.4238   1.878818    31.10718    60.04483     44.7972    77.85616
#>   PM25FULLt_max
#> 1       15.4238
```

In this example, the BAG GeoPackage is use. The output structure is
identical when using PC6; only the database path needs adjusting.
[`postcodElapse()`](https://griac-bioinformatics.github.io/postcodElapse/reference/postcodElapse.md)
returns a data frame in which each row corresponds to a postcode.
Columns include:

- The postcode
- Number of buildings in that postcode `n`.
- Mean, minimum & maximum air pollutant concentration in µg/m³.

If you wish to experiment with lager sets of postcodes, the files
`postcode100.rda` & `postcode1000.rda` are available in the package’s
extdata. See below for an example.

``` r

path <- system.file("extdata/postcode100.rda", package = "postcodElapse")
load(path)

head(postcode100)
#> [1] "2694BH" "9686NH" "2514LX" "6835MH" "9717LD" "3723EK"

estimates <- postcodElapse(postcode100, "cbs_pc6_2024.gpkg")
#> Guessed db type to be: PC6

head(estimates, 5)
#>   postcode   n BCFULL_avg NO2FULL_avg O3FULLa_avg O3FULLc_avg O3FULLw_avg
#> 1   1055LZ  30   2.152679    47.92073    48.13478    36.28936    52.74254
#> 2   1068BS  25   1.701343    36.03498    54.87814    39.16438    66.80187
#> 3   1075CR  20   2.121569    42.52370    54.33167    37.15707    65.54469
#> 4   1186GP 115   1.619018    34.56064    57.31758    38.56885    74.62107
#> 5   1222RP  15   1.727729    35.62143    54.20006    37.05156    74.62482
#>   PM25FULLt_avg BCFULL_min NO2FULL_min O3FULLa_min O3FULLc_min O3FULLw_min
#> 1      18.69952   1.982936    44.26031    46.24104    36.21948    52.32673
#> 2      16.28975   1.696246    35.90311    54.85917    38.97618    66.73665
#> 3      17.36451   2.106007    41.10803    54.12944    37.04370    65.19234
#> 4      15.61553   1.592608    33.22308    56.70871    38.11225    73.97521
#> 5      16.37185   1.700418    35.40251    53.54480    36.60494    73.98518
#>   PM25FULLt_min BCFULL_max NO2FULL_max O3FULLa_max O3FULLc_max O3FULLw_max
#> 1      18.43949   2.322422    51.58115    50.02851    36.35924    53.15836
#> 2      16.27069   1.706440    36.16685    54.89712    39.35259    66.86710
#> 3      17.22134   2.126170    42.77146    55.67873    38.16626    66.79316
#> 4      15.35053   1.646049    35.88888    57.72419    38.98361    74.98950
#> 5      16.29307   1.787439    36.75730    54.89755    37.45749    76.16751
#>   PM25FULLt_max
#> 1      18.95955
#> 2      16.30882
#> 3      17.53084
#> 4      15.79089
#> 5      16.56795
```

## Further information

With the material above, you can utilize postcodElapse for basic
exposure estimations. For plotting spacial data an extra
[article](https://griac-bioinformatics.github.io/postcodElapse/articles/Spacial-plotting.html)
is provided.
