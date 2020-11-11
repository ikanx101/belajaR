# settings
rm(list=ls())
library(dplyr)
library(rvest)

# getting the links
url = "https://wumard.wordpress.com"

blog = url %>% read_html %>% html_nodes("a") %>% html_attr("href")

data = data.frame(
  id = 1,
  url = blog
) %>%
  filter(!grepl("files",url)) %>%
  filter(grepl("2020",url)) %>%
  mutate(penanda = stringr::str_length(url)) %>%
  filter(penanda > 37) %>%
  filter(!grepl("\\#",url)) %>%
  distinct()
  
# scrape the contents
scrape = function(url){
  url %>%
      read_html() %>%
      html_nodes("p") %>%
      html_text()
}

data$isi_blog = sapply(data$url,scrape)

# gabung semua artikel
isi = data$isi_blog[1]
for(i in 2:10){
  isi = paste(isi,data$isi_blog[i])
}

# bebersih
isi = gsub("\\n","",isi,fixed = T)
isi = gsub("\\r","",isi,fixed = T)
isi = gsub("\\t","",isi,fixed = T)
isi = gsub("\\,","",isi)
isi = strsplit(isi,split = "\\.")
isi = unlist(isi)
isi = janitor::make_clean_names(isi)
isi = gsub("\\_"," ",isi)

# blog
data_blog = data.frame(
  id = c(1:510),
  kalimat = isi,
  label = "CEO"
) %>%
  filter(!grepl("logout",kalimat)) %>%
  filter(!grepl("account",kalimat)) %>%
  filter(!grepl("commenting",kalimat))

# export to csv
write.csv(data_blog,"wordpress.csv")
