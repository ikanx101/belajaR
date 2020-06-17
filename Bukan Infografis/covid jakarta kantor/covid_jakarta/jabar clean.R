setwd("~/Documents/belajaR/Bukan Infografis/covid jakarta kantor/covid_jakarta")

rm(list=ls())

library(dplyr)
library(readr)

data_jabar = read_csv('Data COVID-19 Jawa Barat.csv')
