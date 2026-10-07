# Format strings as Dutch postcodes.

This attempts to format any given string as an Dutch postcodes. IE. four
numbers followed by two capital letters, no spaces between each
character. `formatPostcode()` removes any spaces in a given string and
capitalizes all letters. In addition checks for unwanted extra numbers
and letters, errors in case one is found.

## Usage

``` r
formatPostcode(postcodes)
```

## Arguments

- postcodes:

  Strings to be formatted as postcode

## Value

Strings formatted as postcodes

## Examples

``` r
formatPostcode("8 9 3 3 DV", "9 713 Gz", "1071 xx")
#> Error in formatPostcode("8 9 3 3 DV", "9 713 Gz", "1071 xx"): unused arguments ("9 713 Gz", "1071 xx")
```
