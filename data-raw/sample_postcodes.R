# Load both gpkg files get all postcodes that are common to both and sample them.
library(sf)
library(tidyverse)

# load all postcodes form both databases
bag <- st_read("../data/bag-light.gpkg",
        query = "SELECT postcode FROM verblijfsobject")

pc6 <- st_read("../data/cbs_pc6_2024.gpkg",
        query = "SELECT postcode6 FROM postcode6")


# I just need the distinct ones
bag <- distinct(bag)
pc6 <- distinct(pc6)

# Only the postcodes common to both
both <- intersect(bag$postcode, pc6$postcode6)

postcode100 <- sample(both, 100)
postcode1000 <- sample(both, 1000)
