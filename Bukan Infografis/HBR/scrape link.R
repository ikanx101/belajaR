setwd("~/belajaR/Bukan Infografis/HBR")

rm(list=ls())

library(rvest)
library(dplyr)

load("artikel hbr.rda")

url = read_html("https://hbr.org/") %>% html_nodes(".hed a") %>% html_attr("href")

scrape = function(url){
  read_html(url) %>% html_nodes("p") %>% html_text(trim = T)
}

data = data.frame(id = c(1:length(url)),
                  url = paste0("https://hbr.org/",url)) %>% 
  mutate(baca = sapply(url, scrape))

for(i in 1:length(url)){
  tes = data$baca[[i]]
  tes = unlist(tes)
  tes = stringr::str_c(tes,collapse = " ")
  data$baca_new[i] = tes
}

data$baca = NULL

temp = rbind(temp,data) %>% distinct()

save(temp,file = "artikel hbr.rda")