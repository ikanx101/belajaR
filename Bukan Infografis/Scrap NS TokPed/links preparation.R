rm(list=ls())
setwd("~/Documents/belajaR/Bukan Infografis/olive oil tokped")
library(dplyr)

# ambil dbase links 
link = readLines('~/Documents/belajaR/Bukan Infografis/olive oil tokped/all available links.txt')
link = unique(link)
dummy = data.frame(id = c(1:length(link)),
                   url = link)

dummy = 
  dummy %>% 
  filter(!grepl('promo/v1/clicks',url)) %>% 
  filter(grepl('minyak|olive|oil|zaitun',url,ignore.case = T))
url = dummy$url

save(url,file='all data.rda')