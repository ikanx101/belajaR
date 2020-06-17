setwd("~/Documents/belajaR/Bukan Infografis/covid jakarta kantor/covid_jakarta")

rm(list=ls())

library(dplyr)
library(readr)
library(ggplot2)

data_jabar = read_csv('Data COVID-19 Jawa Barat.csv')
data_jabar$X15 = NULL

data_jabar = 
  data_jabar %>% 
  select(tanggal,nama_kab,odp,pdp,positif,sembuh,meninggal)

load('all files.rda')
save(data_jabar,data_covid_provinsi,file='all files.rda')