rm(list=ls())
setwd("~/Documents/belajaR/Bukan Infografis/milo tokopedia")
library(rvest)
library(dplyr)

# ambil dbase links 
link = readLines('~/Documents/belajaR/Bukan Infografis/milo tokopedia/links dbase/links.txt')


link = 
data %>% mutate_if(is.factor,as.character) %>% 
  filter(grepl('tropicana',Anchor.Text,ignore.case = T)) %>%
  distinct() %>%
  select(Link)

url = link$Link

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
}

data %>% select(-terjual) %>% write.csv('tropicana slim tokopedia.csv')
data %>% write.csv('tropicana slim tokopedia complete.csv')
