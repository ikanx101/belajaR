rm(list=ls())
library(dplyr)

# ambil dbase links 
link = readLines('links.txt')
link = unique(link)
dummy = data.frame(id = c(1:length(link)),
                   url = link)

dummy = 
  dummy %>% 
  filter(!grepl('promo/v1/clicks|search',url)) %>% 
  filter(grepl('novel|book|buku|repro|kw',url,ignore.case = T)) %>% 
  filter(!grepl("facebook",url))
url = dummy$url
