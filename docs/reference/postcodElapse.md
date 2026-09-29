# Get the air pollution data for a given postcode.

Get the air pollution data for a given postcode.

## Usage

``` r
postcodElapse(postcodes, db_path, db_type, elapse_path)
```

## Arguments

- postcodes:

  string or vector of strings Containing PC6 postcodes i.e. '1234AB'.

- db_path:

  string Path to database containing postcode data.

- db_type:

  *optional* string Type of the database, BAG or PC6.

- elapse_path:

  *optional* string Path to ELAPSE expected as single tiff image.

## Value

data.frame Containing air pollution statistics for the given
`postcodes`.

## BAG

Basisregistratie Adressen en Gebouwen (BAG) is a database published by
kadaster containing the geolocation and postcode of all buildings in the
Netherlands. Used to acquire geolocation so air pollution data can be
extracted from ELAPSE. Download via [this
link](https://service.pdok.nl/lv/bag/atom/bag.xml), note it's 8gigabyte.

## PC6

Postcode6 is a database published by CBS containing the geographic area
and statistics on all postcodes in the Netherlands. Again used to
acquire geolocations so air pollution data can be extracted from ELAPSE.
Download via [this
link](https://service.pdok.nl/cbs/postcode6/atom/postcode6_volledige_postcode.xml)
