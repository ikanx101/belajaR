library(rvest)
library(dplyr)

links = readLines("links.txt")

scrape = function(url){
  read_html(url) %>% {tibble(
    nama = html_nodes(.,".cmp-breadcrumb__item--active strong") %>% html_text(),
    bahan = html_nodes(.,".m-recipeDetailList__item p") %>% html_text()
  )}
}

i = 1
data = scrape(links[i])

for(i in 2:34){
  temp = scrape(links[i])
  data = rbind(data,temp)
}

stop_id = readLines("https://raw.githubusercontent.com/ikanx101/ID-Stopwords/master/id.stopwords.02.01.2016.txt")

sensor = c("potong","goreng","sesuai","selera","iris","diiris","dikupas","dipotong",
           "dicincang","bumbu","cincang","halus","kupas","digoreng","ekor","parut","rebus","dibelah",
           "direndam","gelas","kasar","utuh","dicuci","matang","menumis","panggang","pilihan",
           "ukuran","apapun","bungkus","cangkir","diganti","digantikan","dikukus","gantikan","hidangan",
           "memarkan","mendidih","mengganti","menit","tipis","tumis","15cm","5sdm","bersih","berukuran",
           "cepat","cocok","cuci")

library(tidytext)
library(tidyr)

data %>% 
  unnest_tokens("words",bahan) %>% 
  group_by(words) %>% 
  summarise(n = n()) %>%
  ungroup() %>% 
  arrange(desc(n)) %>% 
  mutate(penanda = as.numeric(words)) %>% 
  filter(is.na(penanda)) %>% 
  mutate(penanda = stringr::str_length(words)) %>% 
  filter(penanda > 3) %>% 
  filter(!words %in% stop_id) %>% 
  filter(!words %in% sensor) %>% 
  filter(n>1) %>% 
  View()
