setwd("~/Documents/belajaR/Bukan Infografis/covid jakarta kantor/covid_jakarta")

rm(list=ls())

data_april = read.csv('Data-ODP-PDP-dan-Positif-Covid-19-DKI-Jakarta-Per-Kecamatan-Bulan-April-2020.csv')
data_mei = read.csv('Data-ODP-PDP-dan-Positif-Covid-19-DKI-Jakarta-Per-Kecamatan-Bulan-Mei-2020.csv')
data_maret = read.csv('Data-ODP-PDP-dan-Positif-Covid-19-DKI-Jakarta-Per-Kecamatan-Bulan-Maret-2020.csv')
data_juni = read.csv('Data-ODP-PDP-dan-Positif-Covid-19-DKI-Jakarta-Per-Kecamatan-Bulan-Juni-2020.csv')

data_jakarta = rbind(data_april,data_mei)
data_jakarta = rbind(data_jakarta,data_maret)
data_jakarta = rbind(data_jakarta,data_juni)

load('all files.rda')
save(data_jabar,data_covid_provinsi,data_jakarta,file='all files.rda')