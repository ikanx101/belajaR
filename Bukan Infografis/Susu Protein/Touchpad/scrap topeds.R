setwd("~/belajaR/Bukan Infografis/Susu Protein/Touchpad")

rm(list=ls())
library(rvest)
library(dplyr)

# PART 1
# input URL
url = readLines("all available links.txt")

# bebersih links
dbase_link = 
  data.frame(
    id = 1,
    url = url
  ) %>% 
  filter(!grepl("mitra-toppers",url)) %>% 
  filter(!grepl("promo",url)) %>% 
  filter(grepl("tokopedia.com/",url)) %>% 
  filter(!grepl("discovery",url,ignore.case = T)) %>% 
  filter(!grepl("deal",url,ignore.case = T)) %>% 
  mutate(penanda = stringr::str_length(url)) %>% 
  arrange(penanda) %>% 
  filter(penanda >= 50) %>% 
  distinct()

url = dbase_link$url

# PART 2
# Fungsi scrape data
scrap = function(url){
  data = tryCatch(
    read_html(url) %>% {
      tibble(
        nama = html_nodes(.,'.css-x7lc0h') %>% html_text(),
        harga = html_nodes(.,".css-c820vl") %>% html_text(),
        seller = html_nodes(.,'.css-xmjuvc') %>% html_text(),
        terjual = html_nodes(.,'b') %>% html_text(),
        lokasi = html_nodes(.,".css-1s83bzu span") %>% html_text(),
        link = url
      )
    },
    error = function(e){
      data = tibble(
        nama = NA,
        harga = NA,
        seller = NA,
        terjual = NA,
        lokasi = NA,
        link = url
      )
    }
  )
  return(data)
}


i = 1
data = scrap(url[i])

for(i in 2:length(url)){
  temp = scrap(url[i])
  data = rbind(data,temp)
  print(paste0('ambil data ke ',
               i,
               ' done - alhamdulillah'))
}

data$waktu.scrape = Sys.time()
data = distinct(data)

load("hasil scrape.rda")
raw = rbind(raw,data)
save(raw,file = 'hasil scrape.rda')