rm(list=ls())

library(readxl)
library(dplyr)

setwd("~/Documents/belajaR/Bukan Infografis/covid jakarta kantor/covid_jakarta")

load('scrape covid.rda')

data = janitor::clean_names(data)
data = data[-1,]
data = data[-35:-37,]
colnames(data)[2] = 'last_update'
colnames(data)[3] = 'major_city'
colnames(data)[4] = 'confirmed'
colnames(data)[5] = 'recovered'
colnames(data)[6] = 'deaths'
colnames(data)[7] = 'active'

data =
  data %>% 
  mutate(confirmed = gsub('\\,','',confirmed),
         recovered = gsub('\\,','',recovered),
         deaths = gsub('\\,','',deaths),
         active = gsub('\\,','',active),
         cases_per_million_population_f = gsub('\\,','',cases_per_million_population_f),
         recovery_rate = gsub('\\%','',active),
         fatality_rate = gsub('\\%','',active),
         confirmed = as.numeric(confirmed),
         recovered = as.numeric(recovered),
         deaths = as.numeric(deaths),
         active = as.numeric(active),
         cases_per_million_population_f = as.numeric(cases_per_million_population_f),
         recovery_rate = as.numeric(recovery_rate),
         fatality_rate = as.numeric(fatality_rate)
  )

data_covid_provinsi = data

save(data_covid_provinsi,file='all files.rda')
