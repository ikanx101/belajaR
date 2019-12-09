rm(list=ls())

#library
library(gtrendsR)
library(ggplot2)
library(dplyr)

#ambil data
brands = c('big data','machine learning','artificial intelligence','visual analytics')
data = gtrends(brands,geo = '',time = "2010-01-01 2019-12-01")

png('this topics.png',width = 900, height = 480,res=100)
plot(data)
dev.off()