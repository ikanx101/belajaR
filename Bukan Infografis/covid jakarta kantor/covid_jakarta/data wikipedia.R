# Scrape data COVID Indonesia Terakhir

rm(list=ls())
setwd("~/Documents/belajaR/Bukan Infografis/covid jakarta kantor/covid_jakarta")

library(readxl)
library(dplyr)
library(rvest)

url = 'https://en.wikipedia.org/wiki/COVID-19_pandemic_in_Indonesia'
data = read_html(url) %>% html_table(fill=T)
data = data[[5]]

data = janitor::clean_names(data)
data = data[-1,]
data = data[-35:-37,]
colnames(data)[2] = 'last_update'
colnames(data)[3] = 'major_city'
colnames(data)[4] = 'confirmed'
colnames(data)[5] = 'recovered'
colnames(data)[6] = 'deaths'
colnames(data)[7] = 'active'
colnames(data)[8] = 'cases_per_mil_pop'

raw = data
data =
  raw %>% 
  mutate(confirmed = gsub('\\,','',confirmed),
         recovered = gsub('\\,','',recovered),
         deaths = gsub('\\,','',deaths),
         active = gsub('\\,','',active),
         cases_per_mil_pop = gsub('\\,','',cases_per_mil_pop),
         recovery_rate = gsub('\\%','',recovery_rate),
         fatality_rate = gsub('\\%','',fatality_rate),
         confirmed = as.numeric(confirmed),
         recovered = as.numeric(recovered),
         deaths = as.numeric(deaths),
         active = as.numeric(active),
         cases_per_mil_pop = as.numeric(cases_per_mil_pop),
         recovery_rate = as.numeric(recovery_rate),
         fatality_rate = as.numeric(fatality_rate)
  )

data_covid_provinsi = data
data_covid_provinsi$last_update = NULL
data_covid_provinsi$major_city = NULL
save(data_covid_provinsi,file='all files.rda')
