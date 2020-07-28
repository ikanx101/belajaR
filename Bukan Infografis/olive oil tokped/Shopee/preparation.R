setwd("~/Documents/belajaR/Bukan Infografis/olive oil tokped/Shopee")
rm(list=ls())
library(dplyr)

# ambil dbase links 
link = readLines('link produk.txt')
link = unique(link)
dummy = data.frame(id = c(1:length(link)),
                   url = link,
                   asli = link) %>% 
  filter(grepl('-i',url)) %>% 
  tidyr::separate(url,into = c('hapus','pakai'),sep = '-i.') %>% 
  tidyr::separate(pakai, into = c('info1','info2'),sep = '\\.') %>%
  mutate(link_final = paste0('https://shopee.co.id/api/v2/item/get?itemid=',
                             info2,
                             '&shopid=',
                             info1))

url = dummy$link_final
save(url,file = 'hasil scrape.rda')
