rm(list=ls())
setwd("/cloud/project/Bukan Infografis/Twitter Pak Presiden")

#libraries
library(rtweet)
library(dplyr)
library(tidytext)
library(tidyr)

#bagian ini adalah saat scrap data twitter pak jokowi
data.nfi = get_timelines('jokowi', n = 9000)
save(data.nfi,file='Twit Pak Jokowi.rda') #save for later

#kita mulai analisanya yah
analisa.1=data.nfi %>% mutate(tahun = lubridate::year(created_at)) %>% group_by(tahun,source) %>% summarise(total=n())


library(ggplot2)
analisa.1 %>% ggplot(aes(x=tahun,y=total,group=source)) + geom_line(aes(color=source))
