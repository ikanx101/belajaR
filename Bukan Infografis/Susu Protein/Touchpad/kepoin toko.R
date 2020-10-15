# kepo-in toko

rm(list=ls())
library(dplyr)
library(rvest)
library(tidyr)

load("hasil scrape.rda")

data = 
  raw %>% 
  select(seller,link) %>% 
  group_by(seller) %>% 
  mutate(id = c(1:length(link))) %>% 
  ungroup() %>% 
  filter(id == 1) %>% 
  mutate(link = gsub("https://www.tokopedia.com/","",link)) %>% 
  separate(link,into = c("id_seller","dummy"),sep = "\\/") %>% 
  mutate(link = paste0("https://www.tokopedia.com/",id_seller)) %>% 
  select(seller,link)

scrape = function(url){
  barang = read_html(url) %>% html_nodes(".css-1ty3vwd") %>% html_text()
  return(barang)
}

data$barang = "Kosong"

data$barang[21:282] = sapply(data$link[21:282],scrape)

save(data,file = "hasil kepoin toko.rda")