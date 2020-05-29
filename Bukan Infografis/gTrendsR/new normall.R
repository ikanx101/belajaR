rm(list = ls())

library(gtrendsR)
library(dplyr)
library(ggplot2)

data = gtrends(c('new normal','new world order','konspirasi'),geo = 'ID')

data_1 = data$interest_over_time
