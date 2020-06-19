rm(list=ls())
setwd("~/Documents/belajaR/Bukan Infografis/milo tokopedia")
library(rvest)
library(dplyr)

# ambil dbase links 
link = readLines('~/Documents/belajaR/Bukan Infografis/milo tokopedia/links dbase/links.txt')
link = unique(link)
dummy = data.frame(id = c(1:length(link)),
                   url = link)

dummy = 
  dummy %>% 
  filter(!grepl('promo/v1/clicks',url))
url = dummy$url

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

for(i in 130:length(url)){
  temp = scrap(url[i])
  data = rbind(data,temp)
}

data$waktu.scrape = Sys.time()
raw = data

# proses perapihan 
head(data)

data = data %>% filter(grepl('terjual',terjual,ignore.case = T)) %>%
  mutate(terjual = gsub('Terjual ','',terjual,fixed = T))

save(data,raw,file = 'hasil scrape.rda')
data %>% openxlsx::write.xlsx('milo tokopedia.xlsx')
