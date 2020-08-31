rm(list=ls())
library(dplyr)
library(jsonlite)

load('hasil scrape.rda')

# bikin fungsi scrape
scrape_shopee = function(url){
  # buka json
  tes = read_json(url)
  #bentuk data frame
  data = data.frame(
    nama = tes$item$name,
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
  temp = scrape_shopee(url[i])
  data = rbind(data,temp)
  print(paste0('Alhamdulillah ',i,' sudah didapatkan...'))
}

data$waktu.scrape = Sys.time()
data = distinct(data)

raw = rbind(raw,data)

save(raw,url,file = 'hasil scrape.rda')