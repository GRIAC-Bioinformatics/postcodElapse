# This script was used to build the demo datasests included in extdata,
# containing a random sample of postcods exising in both GeoPackages.
library(sf)
library(tidyverse)

# load all postcodes form both databases
bag <- st_read("../data/bag-light.gpkg",
        query = "SELECT postcode FROM verblijfsobject")

pc6 <- st_read("../data/cbs_pc6_2024.gpkg",
        query = "SELECT postcode6 FROM postcode6")


# Deduplicate the data
bag <- distinct(bag)
pc6 <- distinct(pc6)

# find all postcodes that exist in both GeoPackages
both <- intersect(bag$postcode, pc6$postcode6)

# Randomly sample them.
postcode100 <- sample(both, 100)
postcode1000 <- sample(both, 1000)
