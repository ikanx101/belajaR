rm(list=ls())
setwd("~/Documents/belajaR/Bukan Infografis/Shiny COVID REAL/realshinycovid")

# panggil library
library(readxl)
library(dplyr)
library(rvest)

# data dunia
# sumber url
# https://ourworldindata.org/coronavirus

data_dunia = read.csv('~/Documents/belajaR/Bukan Infografis/Shiny COVID REAL/realshinycovid/DaMen/owid-covid-data.csv')

data_dunia =
  data_dunia %>% 
  mutate(date = as.Date(date)) %>% 
  filter(location != 'World',
         location != 'International') %>% 
  select(date,continent,location,new_cases,total_cases,new_deaths,total_deaths,total_cases_per_million,total_tests,total_tests_per_thousand,population,
         median_age,gdp_per_capita,diabetes_prevalence)

url = 'https://developers.google.com/public-data/docs/canonical/countries_csv'
longlat = read_html(url) %>% html_table(fill=T)
longlat = longlat[[1]]
longlat = longlat %>% select(name,longitude,latitude) %>% rename(location = name)
data_dunia = merge(data_dunia,longlat)

# data pikobar
# sumber url
# https://pikobar.jabarprov.go.id/table-case

data_jabar = readr::read_csv('~/Documents/belajaR/Bukan Infografis/Shiny COVID REAL/realshinycovid/DaMen/Data COVID-19 Jawa Barat.csv')
data_jabar$X15 = NULL

data_jabar = 
  data_jabar %>% 
  select(tanggal,nama_kab,odp,pdp,positif,sembuh,meninggal)

# data kawalcovid19
# sumber url
# http://sinta.ristekbrin.go.id/covid/datasets
# sheet pertama
data_1 = read_excel('~/Documents/belajaR/Bukan Infografis/Shiny COVID REAL/realshinycovid/DaMen/COVID-19 di Indonesia @kawalcovid19.xlsx',
                    sheet = 'Statistik Harian')
data_1 = janitor::clean_names(data_1)
data_1 = 
  data_1 %>% 
  select(x1,kasus_baru,total_kasus,sembuh,meninggal_dunia,pdp,odp,jumlah_orang_diperiksa,
         negatif,positif_c) %>% 
  rename(tanggal = x1)

data_1[is.na(data_1)] = 0
data_nasional_harian = data_1

# sheet kedua
data_1 = read_excel('~/Documents/belajaR/Bukan Infografis/Shiny COVID REAL/realshinycovid/DaMen/COVID-19 di Indonesia @kawalcovid19.xlsx',
                    sheet = 'Kasus per Provinsi',
                    skip = 1)
data_1 = janitor::clean_names(data_1)
data_1 = 
  data_1 %>% 
  select(provinsi_asal_2,kasus,sembuh,kematian)
data_1 = data_1[1:34,]
data_prov_total = data_1

# sheet ketiga
data_1 = read_excel('~/Documents/belajaR/Bukan Infografis/Shiny COVID REAL/realshinycovid/DaMen/COVID-19 di Indonesia @kawalcovid19.xlsx',
                    sheet = 'Timeline')

data_1 = read_excel("Bukan Infografis/Cawal Kovid/CawalKovid/COVID-19 di Indonesia @kawalcovid19.xlsx", 
                    sheet = "Timeline", col_types = c("date", 
                                                      "numeric", "text", "text", "text", "text", 
                                                      "text", "text", "text", "text", "text", 
                                                      "text", "text", "text", "text", "text", 
                                                      "text", "text", "text", "text", "text", 
                                                      "text", "text", "text", "text", "text", 
                                                      "text", "text", "text", "text", "text", 
                                                      "text", "text", "text", "text", "text"))


# simpan semua datasets yang ada
save(data_dunia,data_jabar,data_nasional_harian,
     file = '~/Documents/belajaR/Bukan Infografis/Shiny COVID REAL/realshinycovid/all files.rda')
