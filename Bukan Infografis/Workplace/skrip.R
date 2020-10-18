setwd("~/belajaR/Bukan Infografis/Workplace")

rm(list=ls())

library(dplyr)
library(rvest)

data = read_html("web 2.html") %>% html_nodes("a._4kk6._5b6s") %>% html_text(trim = T)
data

url = "https://bangbeni.bsn.go.id/barang-ber-sni"

read_html(url) %>% html_table(fill=T)
