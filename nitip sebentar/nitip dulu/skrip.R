rm(list=ls())

source('/cloud/project/All Func.R')

setwd("/cloud/project/nitip sebentar/nitip dulu")
doc = read_pptx('template.pptx')

tambahin.slide.judul.donk('Time Series Decomposition','Granger Causality')
tambahin.slide.ending.donk()
export.powerpoint.saya.donk('hasil sementara')

#url = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vRL852_gyp0amEAte68bxRQG7cXbg8fFo6RV7bbSmTM2TaPodbKWFk33MMORFaT1w/pubhtml'

read_html(url) %>% html_table()


ts=ts(dummy$sales,start=c(min(dummy$year),1),frequency=12)
decompose=stl(ts,s.window='periodic')
decompose=data.frame(decompose$time.series)
dummy$seasonal=decompose$seasonal
dummy$trend=decompose$trend
dummy$remainder=decompose$remainder
