rm(list=ls())

library(readxl)

setwd("~/Documents/belajaR/Bukan Infografis/covid jakarta kantor/covid_jakarta")

data = read.csv('data-penambahan-kasus-covid-19-bulan-juni-tahun-2020.csv')

data_detail_jkt = janitor::clean_names(data)

data_detail_jkt
