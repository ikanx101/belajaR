rm(list=ls())
setwd('D:/Project_R/Kamis Data/TSP Jarak')

#ambil libraries
library(rvest)
library(dplyr)
library(tidyr)
library(tidytext)
library(ggplot2)
library(googleway)
library(ggmap)

#key
key = ''
#alamat
alamat = c('Bluebell Summarecon Bekasi',
           'SDIT Al Insan Bekasi Timur',
           'SD Islam Labschool Bani Saleh',
           'SD Quba Islamic School Bekasi',
           'Gema Nurani Integrated Islamic School',
           'SDIT Salsabila Bekasi',
           'Jalan Mahoni 4 blok B2 nomor 44 Bekasi Jaya Indah',
           'Summarecon Mall Bekasi',
           'SDIT Thariq Bin Ziyad Jatimulya',
           'jalan cemara v jatimulya bekasi',
           'Nutrifood Rawabali Pulo Gadung Jakarta')
init_data = data.frame(id=c(1:length(alamat)),alamat)

for(i in 1:max(init_data$id)){
  hasil = google_geocode(alamat[i],key = key)
  lat = hasil$results$geometry$location$lat
  long = hasil$results$geometry$location$lng
  init_data$lat[i] = lat[1]
  init_data$long[i] = long[1]
}

init_data$latlon = paste(init_data$lat,init_data$long,sep='+')
write.csv(init_data,'data awal.csv')

#hitung jarak dengan gmapsdistance
library(gmapsdistance)
set.api.key("")
jarak = gmapsdistance(origin = init_data$latlon,
                      destination = init_data$latlon,
                      combinations = 'all',
                      mode='driving')

jarak = jarak$Distance
jarak = jarak[,-1]

#bikin matrix jarak
distances = as.matrix(jarak) / 1000
colnames(distances) = init_data$id
rownames(distances) = init_data$id
distances <- as.dist(distances)

library(TSP)
tsp <- as.ATSP(distances)
tour = solve_TSP(tsp)
tour_order = as.integer(tour)
tour_length = tour_length(tour)
addresses = init_data[tour_order,]

library(leaflet)
leaflet() %>% addTiles() %>% 
  addCircles(lat=addresses$lat,lng = addresses$long,radius=50) %>%
  addPolylines(lat = addresses$lat, lng = addresses$long) 