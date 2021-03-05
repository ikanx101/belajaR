setwd("~/Documents/belajaR/Bukan Infografis/multi Vitamin/Shopee")
rm(list=ls())
library(dplyr)
library(jsonlite)

load('hasil scrape new.rda')

# bikin fungsi scrape
scrape_shopee = function(url){
  # buka json
  tes = read_json(url)
  #bentuk data frame
  data = data.frame(
    nama = tes$item$name,
    kategori = ifelse(is.null(tes$item$categories[[1]]$display_name),NA,tes$item$categories[[1]]$display_name),
    terjual = tes$item$historical_sold,
    merek = ifelse(is.null(tes$item$brand),'Tidak Ada Merek',tes$item$brand),
    harga = tes$item$price,
    harga_normal = tes$item$price_before_discount,
    link = url
  )
  return(data)
}

i = 1
data = scrape_shopee(url[i])

for(i in 2:length(url)){
  temp = tryCatch({scrape_shopee(url[i])},
                  error = function(e){
                    temp = data.frame(nama = NA,
                                      kategori = NA,
                                      terjual = NA,
                                      merek = NA,
                                      harga = NA,
                                      harga_normal = NA,
                                      link = url)
                  })
  data = rbind(data,temp)
  print(paste0('Alhamdulillah ',i,' sudah didapatkan...'))
}

data$waktu.scrape = Sys.Date()
data = distinct(data)
raw = rbind(raw,data)

save(raw,url,file = 'hasil scrape new.rda')