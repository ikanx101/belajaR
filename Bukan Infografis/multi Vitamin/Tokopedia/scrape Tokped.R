setwd("~/Documents/belajaR/Bukan Infografis/multi Vitamin/Tokopedia")	
rm(list=ls())	
library(rvest)	
library(dplyr)

load("hasil scrape.rda")

setwd("~/Documents/belajaR/Bukan Infografis/multi Vitamin/Tokopedia/saved html")
pages = list.files(pattern = "html")

# function
scrape_donk = function(file){
  data = read_html(file) %>% {
    tibble(
      nama = html_nodes(.,".css-v7vvdw") %>% html_text(),	
      terjual = html_nodes(.,".items div:nth-child(1)") %>% html_text(),	
      harga = html_nodes(.,".price") %>% html_text(),	
      toko = html_nodes(.,"#pdp_comp-shop_credibility h2") %>% html_text(),	
      asal = "tidak"
    )
  }
}

i = 1	
data = scrape_donk(pages[i])

for(i in 2:length(pages)){	
  temp = scrape_donk(pages[i])
  data = rbind(data,temp)	
  print(paste0("Alhamdulillah ",i))
}

data$waktu.scrape = Sys.Date()	
data = distinct(data)

raw = rbind(raw,data)

setwd("~/Documents/belajaR/Bukan Infografis/multi Vitamin/Tokopedia")
save(raw,file = 'hasil scrape.rda')