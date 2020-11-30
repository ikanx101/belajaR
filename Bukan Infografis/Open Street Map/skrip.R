# install gdal
# lakukan di terminal
  # sudo add-apt-repository ppa:ubuntugis/ppa
  # sudo apt-get update
  # sudo apt-get install gdal-bin
  # ogrinfo --version
  # sudo apt-get install libgdal-dev

library(tidyverse)
library(osmdata)
library(sf)
library(ggmap)
library(leaflet)

# melihat fitur2 yang ada
available_features() 

# melihat tags dari fitur yang ada
available_tags("amenity")


hasil = 
  getbb("bekasi") %>%
  opq() %>%
  add_osm_feature("amenity", "dentist")
str(hasil)

cinema <- osmdata_sf(hasil)
cinema
data = cinema$osm_points

data = 
  data %>% 
  mutate(longlat = as.character(geometry)) %>%
  separate(longlat,into = c("long","lat"),sep = ",") %>% 
  mutate(long = gsub("c(","",long,fixed = T),
         lat = gsub("\\)","",lat),
         long = as.numeric(long),
         lat = as.numeric(lat))



leaflet() %>% addTiles() %>% addCircles(data$long,
                                        data$lat,
                                        popup = paste0(data$name))
