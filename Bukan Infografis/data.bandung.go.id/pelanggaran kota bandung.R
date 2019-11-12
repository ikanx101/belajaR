rm(list=ls())
setwd('/cloud/project/Bukan Infografis/data.bandung.go.id')

#kita ambil datanya
url = 'http://data.bandung.go.id/dataset/a68cea38-6021-43ec-91fd-f3bc80230ec8/resource/d032b43a-2da9-41eb-87cf-e716530e1c8d/download/pelanggaran---desember-2018.csv'
data = read.csv(url)
colnames(data) = tolower(colnames(data))
str(data)

#kita bebersih format dulu yah
library(dplyr)
data = 
data %>% mutate(tgl = as.character(tgl),
                tgl = lubridate::date(tgl),
                simpang = as.character(simpang))
write.csv(data,'pelanggaran kota bandung.csv')

#kita buat visualisasinya yah
library(ggplot2)
library(ggthemes)