# Load ELAPSE from given file or internal.

ELAPSE is a model representing air pollutant concentrations across
Europe, published by Kees de Hoogh. This function expects it as a tiff
grey-scale image with multiple layers per modeled air pollutant. When no
file is given the internal verion is loaded.

## Usage

``` r
loadElapse(path)
```

## Arguments

- path:

  *optional* Path to .tif image containing ELAPSE

## Value

terra spatraster
