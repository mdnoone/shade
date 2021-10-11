
library(sf)
library(tidyverse)
library(tigris)

######
# export for GEE
#####
nhood_list %>%  
  sf::st_write(., "/Users/escheh/Documents/GitHub/planting.shade/storymap-info/shapefiles/neighborhoods.shp", append = FALSE)

#######
# exporting things for the storymap
######

#frogtown shapefile
nhood_list %>%
  filter(GEO_NAME == "Thomas-Dale/Frogtown") %>%
  sf::st_write(., "/Users/escheh/Documents/GitHub/planting.shade/storymap-info/shapefiles/frogtown.shp", append = FALSE)

#st. paul neighborhoods
nhood_list %>%  
  filter(city == "St. Paul") %>%
  rename(Neighborhood = GEO_NAME) %>%
  sf::st_write(., "/Users/escheh/Documents/GitHub/planting.shade/storymap-info/shapefiles/stpaul_nhoods.shp", append = FALSE)

#trees in tracts
mn_tracts %>%
  rename(tract_string = GEOID) %>%
  right_join(eva_data_main %>%
  filter(variable == "canopy_percent") %>%
  select(raw_value, tract_string) %>%
  mutate(`Canopy coverage` = raw_value * 100)) %>%
  select(tract_string, `Canopy coverage`) %>%
  rename(`Tract id` = tract_string) %>%
  sf::st_write(., "/Users/escheh/Documents/GitHub/planting.shade/storymap-info/shapefiles/tree_tracts.shp", append = FALSE)

#bipoc in tracts
mn_tracts %>%
  rename(tract_string = GEOID) %>%
  right_join(eva_data_main %>%
               filter(variable == "pbipoc") %>%
               select(raw_value, tract_string) %>%
               mutate(`Percent BIPOC` = raw_value * 100)) %>%
  select(tract_string, `Percent BIPOC`) %>%
  rename(`Tract id` = tract_string) %>%
  sf::st_write(., "/Users/escheh/Documents/GitHub/planting.shade/storymap-info/shapefiles/bipoc_tracts.shp", append = FALSE)


# #trees in blocks
# #blocks are just SO messy, it's not really worth it. Plus the census is unreliable at the block level anyhow
# #for some reason not working to dl off site: https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_metc/society_census2010realign/
# blocks <- sf::read_sf(("/Users/escheh/Documents/GitHub/planting.shade/storymap-info/shapefiles/realign blocks/Census2010RealignBlock.shp")) %>%
#   filter(ALAND10 > 0,
#          Acres > 1) %>%
#   mutate(ratio = ALAND10 / AWATER10) %>%
#   filter(ratio > .05)
# blocks %>% arrange(ALAND10) %>% head() %>% data.frame()
# 
# leaflet() %>%
#   addTiles() %>%
#   addPolygons(data = filter(blocks, BLK10 == "270370608061012") %>% st_transform(4326))

# tree in block groups
tigris::block_groups(state = "MN", county = c("Ramsey", "Hennepin", "Dakota", "Carver", "Scott", "Anoka", "Washington"), year = 2010) %>%
  right_join(read_csv("./data-raw/TreeAcres_blockgroups_year2020.csv", 
                      col_types = list("GEOID10" = "c"))) %>%
  transmute(tract_string = GEOID10,
            canopy_percent = `1` / ALAND10) %>%
  sf::st_write(., "/Users/escheh/Documents/GitHub/planting.shade/storymap-info/shapefiles/trees_blockgroups.shp", append = FALSE)
  


usethis::use_data(ctu_list, overwrite = TRUE)




mn_tracts %>%
  rename(tract_string = GEOID) %>%
  right_join(eva_data_main %>%
               filter(variable == "canopy_percent") %>%
               select(raw_value, tract_string) %>%
               mutate(`Canopy coverage` = raw_value * 100)) %>%
  select(tract_string, `Canopy coverage`) %>%
  rename(`Tract id` = tract_string) %>%
  sf::st_write(., "/Users/escheh/Documents/GitHub/planting.shade/storymap-info/shapefiles/tree_tracts.shp", append = FALSE)