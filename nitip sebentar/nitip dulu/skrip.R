# clean the environment
rm(list=ls())

# panggil maha function
source('/cloud/project/All Func.R')

# set working directory
setwd("/cloud/project/nitip sebentar/nitip dulu")

# open the powerpoint
doc = read_pptx('template.pptx')

# bikin slide pertama
tambahin.slide.judul.donk('Time Series Decomposition','Granger Causality')

#kita ambil datanya
url = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vRnPxduyaDGHSqR_Wz39y_bSsN-4rO4hZQoRkd6HXNviSw4eEE3mp71kzdmm2eDbxIolzWaPIMyYtMB/pubhtml'
data = read_html(url) %>% html_table()
data = data[[1]]
colnames(data) = data[1,]
data = data[-1,]

tes = 
  data %>%
  group_by(parent,brand,tahun) %>%
  summarise(sum(as.numeric(value))) %>%
  arrange(brand)

ts=ts(dummy$sales,start=c(min(dummy$year),1),frequency=12)
decompose=stl(ts,s.window='periodic')
decompose=data.frame(decompose$time.series)
dummy$seasonal=decompose$seasonal
dummy$trend=decompose$trend
dummy$remainder=decompose$remainder

tambahin.slide.ending.donk()
export.powerpoint.saya.donk('hasil sementara')