# EAB
library(tidyverse)
library(sf)

### land cover -------
temp <- tempfile()
temp2 <- tempfile()

download.file(
  "https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_mda/env_emerald_ash_borer/shp_env_emerald_ash_borer.zip",
  destfile = temp
)
unzip(zipfile = temp, exdir = temp2)
list.files(temp2)
eab <-
  sf::read_sf(paste0(temp2, pattern = "/eab_trees.shp")) %>%
  # filter()
  st_transform(4326) 


usethis::use_data(eab, overwrite = TRUE)

# fs::file_delete("biota_marschner_presettle_veg.gpkg")
# save(historic_veg, file = "historic_veg.rda")

library(leaflet)

leaflet() %>%
addCircles(
  # Markers(
  data = eab,
  group = "EAB",
  radius = 20,
  fill = T,
  stroke = TRUE,
  weight = 2,
  color = "red", #councilR::colors$transitRed,
  fillColor = "red"# councilR::colors$transitRed,
) 