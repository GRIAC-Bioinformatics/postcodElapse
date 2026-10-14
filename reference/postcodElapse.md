# Estimate air pollutant concentraions for a given Dutch postcode.

Estimates air pollutant concentration for given Dutch postcodes. Using
ELAPSE (included) and a postcode database (not-included). Two postcode
databases formatted as Geopackage (.gpkg) are supported
[Postcode6(PC6)](https://service.pdok.nl/cbs/postcode6/atom/postcode6_volledige_postcode.xml)
and [Basisregistratie Adressen en
Gebouwen(BAG)](https://service.pdok.nl/lv/bag/atom/bag.xml) download one
of these and point the `database ` argument to it's location.
PostcodElapse automatically guesses the `type` argument, which you can
set to "PC6" or "BAG".

## Usage

``` r
postcodElapse(postcodes, database_path, database_type = "GUESS", elapse_path)
```

## Arguments

- postcodes:

  String containing Dutch postcode (1234AB) can also be a vector.

- elapse_path:

  When empty ELAPSE stored in extdata is used. Otherwise use the one
  provided.

- database:

  Path to the postcode database, see Postcode database below.

- type:

  Type of the postcode database, defaults to "GUESS" where postcodElapse
  fills type in as "BAG" for Basisregistratie Adressen en Gebouwen or
  "PC6" for Postcode6.

## Examples

``` r
if (FALSE) { # \dontrun{
## Estimate air pollutant levels at NHLstenden Leeuwarden
## and Rijksuniversiteit Gronningen
postcodElapse(c("8917DD", "9712CP"), "~/home/data/bag-light.gpkg")

## Load the demo-data "oneHunderdAddresses" estimate the air pollution levels
## for all the postcodes.
data("oneHunderdAddresses")

head(oneHunderdAddresses)

estimates <- postcodElapse(oneHunderdAddresses, "cbs_pc6_2024.gpkg")

head(estimates, 5)
} # }
```
