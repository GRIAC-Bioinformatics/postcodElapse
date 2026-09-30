# Loads ELAPSE from the given path or from extdata.

Load the ELAPSE dataset, expected as a single .tif image containing all
layers off ELAPSE. When given no path the func loads the ELAPSE model
stored in the package.

## Usage

``` r
loadElapse(path)
```

## Arguments

- path:

  *optional* Path to folder containing ELAPSE dataset.

## Value

terra spatraster
