rm(list=ls())

library(rvest)
library(dplyr)

url = "https://wumard.wordpress.com"

blog = 
  read_html(url) %>% 
  html_nodes("a") %>% 
  html_attr("href")

blog = data.frame(id = 1,url = blog)

blog = 
  blog %>%
  filter(grepl("2020",url)) %>% 
  filter(!grepl("files",url)) %>% 
  distinct()

blog = blog[-21:-25,]

scrape = function(url){
  url %>% 
    read_html() %>% 
    html_nodes("p") %>% 
    html_text()
}

blog$isi = sapply(blog$url,scrape)
