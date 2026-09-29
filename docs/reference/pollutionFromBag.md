# Get air pollution data for a postcode with BAG database.

`pollution_from_bag()` extracts the geolocation of all building assigned
the given postcodes form BAG. With the geolocation the air pollution
data can be extracted from ELAPSE.

## Usage

``` r
pollutionFromBag(postcodes, bag_path, elapse_path, ...)
```

## Arguments

- postcodes:

  string or vector of strings Containing PC6 postcodes.

- bag_path:

  string Path to the BAG database.

- elapse_path:

  *optional* string Path to the ELAPSE database.

## BAG

Basisregistratie Adressen en Gebouwen or BAG contains the geolocation of
all buildings in the Netherlands with an address. You can download it
from
[pdok](https://www.pdok.nl/introductie/-/article/basisregistratie-adressen-en-gebouwen-ba-1).
At the time of writing the file is 8gig.

## ELAPSE

This function automaticly loads the ELAPSE dataset included in the
addrElapsR package. When given elapse_path this func loads that ELAPSE
dataset.
