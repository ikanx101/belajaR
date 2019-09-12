rm(list=ls())
setwd('D:/Project_R/Kamis Data/Cipularang')

#panggil library
library(leaflet)
library(googleway)
library(dplyr)
library(ggplot2)
library(ggthemes)

#key to API
key='' #your google API key here
set_key(key)

#points di purbaleunyi
data = data.frame(ket=c('A','B','C','D','E','F','G','H','I','J','K','L','M','O','P','Q','R','S','T'),
           lat=c(-6.673573,-6.670742,-6.667926,-6.665601,-6.663423,-6.660200,-6.657844,-6.656495,
                 -6.654965,-6.652640,-6.649542,-6.647344,-6.644747,-6.642562,-6.640517,-6.638402,
                 -6.636857,-6.634787,-6.633165),
           lon=c(107.439955,107.441143,107.442087,107.441866,107.440645,107.437549,107.434671,107.431164,
                 107.428249,107.426921,107.427141,107.428154,107.428980,107.428906,107.428476,107.427596,
                 107.425988,107.424893,107.424723))

#cari tahu elevasi via Google Elevation AI
hasil = google_elevation(df_locations = data,simplify = T)
point = as.character(data$ket)
data = hasil[[1]] 
data$point = point

#bikin peta
leaflet() %>% addTiles() %>%  # Add default OpenStreetMap map tiles
  addCircleMarkers(lng=data$location$lng, lat=data$location$lat, label = point,
                   labelOptions = labelOptions(noHide = T))

#bukan infografik
png('Elevasi.png',width = 1500,height = 900,res=120)
data %>% mutate(point=factor(point,levels = c('A','B','C','D','E','F','G','H','I','J','K','L','M','O','P','Q','R','S','T'))) %>%
  ggplot(aes(x=point,y=elevation,label=round(elevation,1))) + geom_line(size=2,group=1,color='darkred') + 
  theme_gdocs() +
  labs(x='Point di peta',y='Elevation: Ketinggian di Atas Permukaan Laut') + geom_text(size=5) +
  theme(axis.text.y = element_blank(),axis.title.x = element_text(size=15,face='bold')) +
  theme(axis.title.y = element_text(size=15,face='bold')) + geom_abline(intercept = 550, slope = -12, color='black',size=1.2,alpha=.2)+
  labs(title = 'Hati - hati di Tol Purbaleunyi KM 97 - KM 92') + theme(plot.title = element_text(size=30,face='bold')) +
  labs(subtitle = 'Banyak orang yang tidak sadar ada `turunan` di sana...') + theme(plot.subtitle = element_text(face='italic')) +
  labs(caption = 'Created using R and Google Elevation AI\ni k A n x') + theme(plot.caption = element_text(size=8,face='italic'))
dev.off()         
         
