# Load ELAPSE form given file or extdata.

Expects ELAPSE as a single tiff grey-scale image containing multiple
layers. When path argument is not given loads ELAPSE from
inst/ELAPSE.tif otherwise uses the given path.

## Usage

``` r
loadElapse(path)
```

## Arguments

- path:

  *optional* Path to .tif image containing ELAPSE

## Value

terra spatraster
