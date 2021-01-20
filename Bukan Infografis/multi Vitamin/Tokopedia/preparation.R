rm(list=ls())
setwd("~/Documents/belajaR/Bukan Infografis/multi Vitamin/Tokopedia")

library(dplyr)

data = readLines("links.txt")

data = data.frame(
  id = 1,
  link = data
) %>% 
  filter(!grepl("indocafe|wasir|tanaman|daging|ayam|sayur|black|tumbuh|tinggi|peninggi|langsing|kurus|pengurus",link)) %>% 
  distinct()

url = unique(data$link)
write.table(paste(url,collapse = "\n"),file = "link final.txt",row.names = F,col.names = F)
