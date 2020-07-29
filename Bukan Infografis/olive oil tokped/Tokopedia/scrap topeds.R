rm(list=ls())
library(rvest)
library(dplyr)

# ambil dbase links 
load('hasil scrape.rda')

scrap = function(url){
  data = 
    read_html(url) %>% {
      tibble(
        nama = html_nodes(.,'.css-x7lc0h') %>% html_text(),
        harga = html_nodes(.,".css-c820vl") %>% html_text(),
        seller = html_nodes(.,'.css-xmjuvc') %>% html_text(),
        terjual = html_nodes(.,'b') %>% html_text(),
        link = url
        )
    }
  return(data)
}

i = 1
data = scrap(url[i])

for(i in 106:length(url)){
  temp = scrap(url[i])
  data = rbind(data,temp)
  print(paste0('ambil data ke ',
               i,
               ' done - alhamdulillah'))
}

data$waktu.scrape = Sys.time()
data = distinct(data)

raw = rbind(raw,data)

save(raw,url,file = 'hasil scrape.rda')