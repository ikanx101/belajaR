rm(list=ls())
setwd("~/Documents/belajaR/Bukan Infografis/BPOM")

library(rvest)
library(dplyr)
library(tidyr)

library(furrr)
plan(multisession)

url = 'Cek Produk BPOM - BPOM RI.html'
data = read_html(url) %>% {
  tibble(
    ket = html_nodes(.,'td:nth-child(2)') %>% html_text(),
    md = html_nodes(.,'td:nth-child(1)') %>% html_text(),
    pt = html_nodes(.,'td~ td+ td') %>% html_text()
  )
}

new = 
  data %>% 
  separate(ket,into=c('ket','merk'),sep='Merk:') %>% 
  separate(merk,into=c('merk','kemasan'),sep='Kemasan:') %>% 
  separate(pt,into=c("pt","prov"),sep="\\,") %>% 
  separate(pt,into=c('pt','kota'),sep="Kota") %>% 
  separate(pt,into=c('pt','kabupaten'),sep="Kab.") %>% 
  distinct()

save(data,new,file = "bpom.rda")
