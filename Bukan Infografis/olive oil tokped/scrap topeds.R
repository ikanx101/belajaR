rm(list=ls())
setwd("~/Documents/belajaR/Bukan Infografis/olive oil tokped")
library(rvest)
library(dplyr)

# ambil dbase links 
load('all data.rda')

scrap = function(url){
  data = 
    read_html(url) %>% {
      tibble(
        nama = html_nodes(.,'.css-x7lc0h') %>% html_text(),
        harga = html_nodes(.,".css-c820vl") %>% html_text(),
        seller = html_nodes(.,'.css-xmjuvc') %>% html_text(),
        terjual = html_nodes(.,'b') %>% html_text()
        )
    }
  return(data)
}

i = 1
data = scrap(url[i])

for(i in 2:length(url)){
  temp = scrap(url[i])
  data = rbind(data,temp)
  print(paste0('ambil data ke ',
               i,
               'done - alhamdulillah'))
}

data$waktu.scrape = Sys.time()

raw = data

save(raw,url,file = 'hasil scrape.rda')