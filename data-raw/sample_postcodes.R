# This script is used to build the oneHunderdAddresses demo-dataset.
# It contains 100 postal addresses common between the BAG and PC6 GeoPackages.
library(sf)
library(tidyverse)

# load all postcodes form both databases
bag <- st_read("../data/bag-light.gpkg",
        query = "SELECT postcode FROM verblijfsobject")

pc6 <- st_read("../data/cbs_pc6_2024.gpkg",
        query = "SELECT postcode6 FROM postcode6")

# De-duplicate the postcodes
bag <- distinct(bag)
pc6 <- distinct(pc6)

# find all postcodes that exist in both GeoPackages
both <- intersect(bag$postcode, pc6$postcode6)

# Randomly sample them. You can change this to add more.
oneHunderdAddresses <- sample(both, 100)

# usethis::use_data(oneHunderdAddresses) # Un-comment to update the demo-data.
