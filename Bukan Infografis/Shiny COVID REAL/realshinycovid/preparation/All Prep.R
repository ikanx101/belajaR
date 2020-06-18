rm(list=ls())
setwd("~/Documents/belajaR/Bukan Infografis/Shiny COVID REAL/realshinycovid/preparation")

# panggil library
library(readxl)
library(dplyr)

data_dunia = read.csv('~/Documents/belajaR/Bukan Infografis/Shiny COVID REAL/realshinycovid/DaMen/owid-covid-data.csv')

data_dunia =
  data_dunia %>% 
  select(location,new_cases,total_cases,new_deaths,total_deaths,total_cases_per_million,total_tests,total_tests_per_thousand,population,
         median_age,gdp_per_capita,diabetes_prevalence)

