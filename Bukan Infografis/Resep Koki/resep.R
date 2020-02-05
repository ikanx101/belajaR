rm(list=ls())
library(rvest)
library(dplyr)

utama = 'https://resepkoki.id/category/kue-roti/'
read_html(utama) %>% html_nodes('a') %>% html_attr('href')


url='https://resepkoki.id/resep/resep-putri-mandi/'


read_html(url) %>% html_nodes('.ingredient-action+ td') %>% html_text()
