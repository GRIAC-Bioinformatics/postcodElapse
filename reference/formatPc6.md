# Format an string or vec of strings as PC6.

This function attempts to format a given string or vec of strings as
Dutch postal addresses i.e. postcode6. Which is 4 numbers followed by
two uppercase letters: "1234AB". The function removes extra spaces from
the given postal codes and makes the letters uppercase. If it finds
extra numbers or letters it errors.

## Usage

``` r
formatPc6(postcodes)
```

## Arguments

- postcodes:

  string or vec containing strings To be formatted as postcodes

## Value

string or vec of srings Containing postcode6 formatted postal addresses.
