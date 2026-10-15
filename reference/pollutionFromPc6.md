# Estimate air pollution concentrations in a postcode with PC6 database.

[Postcode6(PC6)](https://service.pdok.nl/cbs/postcode6/atom/postcode6_volledige_postcode.xml)
by the CBS, contains the geographic region of every postal address in
the Netherlands. `PollutionFromPc6()` estimates air pollutant levels for
a given set of postal addresses by: Querying the spacial region of all
given postal addresses from PC6. Subsequently extracting and calculating
Mean, minimum & maximum air pollutant levels for every postcode from
ELAPSE.

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

data.frame containing a row for every postcode with the following
columns:

- The postal address

- Number of buildings in thta postcode **n**.

- Mean, minimum & maximum concentration for all air pollutants, in
  µg/m3.

## Examples

``` r
if (FALSE) { # \dontrun{
## Packages used in plotting
library(tidyverse)
library(tidyterra)

## Get the spacial area's associated with postcodes.
data("oneHunderdAddresses")

pc6 <- pollutionFromPc6(oneHunderdAddresses, "./data/cbs_pc6_2024.gpkg")

head(pc6, 5)

## Plot the spacial features, and NO2 concentration across the Netherlands.
elapse <- loadElapse()

ggplot() +
  geom_spatraster(data = elapse$NO2FULL) +
  geom_sf(data = pc6, aes(geometry = geom), colour = "purple") +
  scale_fill_grass_c(transform = "log10")
} # }
```
