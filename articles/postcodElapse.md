# postcodElapse - Usage guide

The goal of postcodElapse is to estimate air pollutant (PM_(2.6), BC,
NO₂ & O₃) concentration for Dutch postal codes. As a alternative to at
location measurements. This is achieved trough getting geo-location data
from one of two postcode databases. And mapping those locations to
ELAPSE an air quality model for Europe. Estimating postcode-level air
quality.

## Postcode databases

As said the geographic location or area is **required** to estimate air
pollutant concentration. This data is expected as geopackage (.gpkg)
databases which specialize in storing spacial data. postcodElapse
support two geopackages:

1.  [Postcode6](https://service.pdok.nl/cbs/postcode6/atom/postcode6_volledige_postcode.xml)
    by CBS mapping postcodes to geographic areas.
2.  Kadaster’s [Basisregistratie Adressen en
    Gebouwen(BAG)](https://service.pdok.nl/lv/bag/atom/bag.xml)
    containing the postcode and geo-location for every building in the
    Netherlands.

Enshure you downloat at-least one of threse.

## Effects of Low-Level Air Pollution: A Study in Europe

Or just ELAPSE is a Land Use Regression model. Estimating concentration
of PM_(2.6), BC, NO₂ & O₃ air pollutants, across Europe at 100x100meter
resolution. ELAPSE was published by [Kees de
Hoogh](https://orcid.org/0000-0001-5974-2007) whom allowed it’s use in
postcodElapse. The model itself is stored as an Tiff grey-scale image
with multiple layers:

- BCFULL
- NO2FULL
- O3FULLa
- O3FULLc
- O3FULLw
- PM25FULLt

ELAPSE contains three layers for O₃ due to it’s prescience in the
atmosphere being affected by the seasons. Typically in warmer(w) climate
O₃ concentration tend higher. In the layer names *w* is warm, *c* is
cold and *a* is the average.

The concentrations stored in ELAPSE all use the unit: µg/m³.

## postcodElapse

Now you have an idea of what postcodElapse does lets get some pollution
estimates. For this demo I will assume you have downloaded both postcode
database and postcodElapse itself.

The main function is
[`postcodElapse()`](https://griac-bioinformatics.github.io/postcodElapse/reference/postcodElapse.md)
pass a postcode and database and it return pollution estimates. Ill be
using BAG and the postcode of UMCG Gronningen. See the code below, yes
it is that simple. It does take a minute, before you get your data.

``` r

library(postcodElapse)

postcodElapse("9713AV", "../../data/bag-light.gpkg")
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

Oke the function tells you what it thinks the database is. It only
recognizes BAG or PC6, you can manually override the guessing by passing
a databases acronym in the *database_type* argument.

The pollution estimates are output as a data.frame. In the columns all
layers of ELAPSE have been split across an average(avg), minimum(min)
and maximum(max) pollution concentration, each row contains a single
postcode. The *n* column is the amount of buildings found in that
postcode.

Now lets do an 100 postcodes which are included in the package. See the
code below to load them.

``` r

# The demo data is stored in extdata/postcod100.rda
path <- system.file("extdata/postcode100.rda", package = "postcodElapse")
load(path)

# Its an 100 postcodes common between BAG & PC6.
length(postcode100)
#> [1] 100
head(postcode100)
#> [1] "2694BH" "9686NH" "2514LX" "6835MH" "9717LD" "3723EK"

estimates <- postcodElapse(postcode100, "../../data/cbs_pc6_2024.gpkg") #Here I use PC6
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

Even tough I used PC6 the output is the same as BAG. If you want to test
with more postcodes the file `postcodes1000.rda` is also present in
extdata.
