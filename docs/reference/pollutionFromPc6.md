# Get air pollution data for a postcode with Postcode6 database.

Get air pollution data for a postcode with Postcode6 database.

## Usage

``` r
pollutionFromPc6(postcodes, pc6_path, elapse_path, ...)
```

## Arguments

- postcodes:

  string or vector of strings Containing PC6 postcodes.

- pc6_path:

  string Path to the Postcode6 database.

- elapse_path:

  *optional* string Path to the ELAPSE database.

## Value

data.frame containing avrage, minimum & maximum air pollutant
concentrations and areas per postcode.
