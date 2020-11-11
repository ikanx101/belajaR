rm(list=ls())

library(rvest)
library(dplyr)

# artikel
setwd("~/belajaR/Bukan Infografis/CEO Talks/Artikel")
artikel = list.files()

dbase_artikel = data.frame(
  url = c(),
  sumber = c()
)

for(file in artikel){
  url = readLines(file)
  temp = data.frame(url,sumber = file)
  dbase_artikel = rbind(dbase_artikel,temp)
}

dbase_artikel = 
  dbase_artikel %>% 
  filter(!grepl("sponsor",url))

# fungsi scrape
scrape = function(url){
  read_html(url) %>% html_nodes("p") %>% html_text(trim = T)
}

# kita scrape artikelnya
artikel = c()
for(i in 1:193){
  temp = scrape(dbase_artikel$url[i])
  artikel = c(artikel,temp)
  print(i)
}
