rm(list=ls())
setwd("~/Documents/belajaR/Bukan Infografis/covid jakarta kantor/covid_jakarta")

library(dplyr)

data_dunia = read.csv('owid-covid-data.csv')

data_dunia =
  data_dunia %>% 
  select(location,new_cases,total_cases,new_deaths,total_deaths,total_cases_per_million,total_tests,total_tests_per_thousand,population,
         median_age,gdp_per_capita,diabetes_prevalence)

load('all files.rda')
save(data_covid_provinsi,data_dunia,data_jabar,data_jakarta,file = 'all files.rda')