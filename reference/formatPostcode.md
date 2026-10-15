# Format strings as Dutch postcodes.

Attempts to format any given string as Dutch postal addresses which
contain: Four numbers followed by two capital letters and no spaces, for
example 9713GZ. `formatPostcode()` removes any spaces in given
postcodes, capitalizes all letters. Additionally it checks for malformed
postal addresses, that miss characters.

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
formatPostcode(c("8 9 3 3 DV", "9 713 Gz", "1071 xx"))
#> [1] "8933DV" "9713GZ" "1071XX"
```
