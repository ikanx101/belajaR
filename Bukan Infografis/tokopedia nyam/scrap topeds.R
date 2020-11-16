rm(list=ls())
library(rvest)
library(dplyr)

# PART 1
# input loc
# ambil semua txt links
input_loc = "~/belajaR/Bukan Infografis/tokopedia nyam/Links/"
setwd(input_loc)
nama_file = list.files()
dbase_link = data.frame(sumber = c(),url = c())
for(i in 1:length(nama_file)){
  temp = readLines(nama_file[i])
  dbase_temp = data.frame(sumber = nama_file[i],
                          url = temp)
  dbase_link = rbind(dbase_link,dbase_temp)
}

# bebersih links 
dbase_link = 
  dbase_link %>% 
  mutate(sumber = gsub(".txt","",sumber)) %>% 
  filter(!grepl("mitra-toppers",url)) %>% 
  filter(!grepl("promo",url)) %>% 
  filter(grepl("tokopedia.com/",url)) %>% 
  filter(!grepl("discovery",url,ignore.case = T)) %>% 
  filter(!grepl("deal",url,ignore.case = T)) %>% 
  mutate(penanda = stringr::str_length(url)) %>% 
  arrange(penanda) %>% 
  filter(penanda >= 50)


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
data = scrap(dbase_link$url[i])
data$keterangan = dbase_link$sumber[i]

for(i in 2:length(dbase_link$url)){
  temp = scrap(dbase_link$url[i])
  temp$keterangan = dbase_link$sumber[i]
  data = rbind(data,temp)
  print(paste0('ambil data ke ',
               i,
               ' done - alhamdulillah'))
}

data$waktu.scrape = Sys.time()
data = distinct(data)

setwd("~/belajaR/Bukan Infografis/tokopedia nyam")
load("hasil scrape.rda")
raw = rbind(raw,data)
save(raw,file = 'hasil scrape.rda')