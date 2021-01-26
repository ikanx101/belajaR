rm(list=ls())

library(dplyr)
library(jsonlite)

link_new = gsub("/item/","/shop/",url,fixed = T)
link_new = unique(link_new)

ambil_toko = function(url){
  tes = read_json(url)
  data = data.frame(
    nama_toko = tes$data$name,
    lokasi = tes$data$place,
    banyak_item_sold = tes$data$item_count,
    official = tes$data$is_official_shop,
    rating = tes$data$rating_star)
  return(data)
}

i = 1
data = ambil_toko(link_new[i])

for(i in 1837:length(link_new)){
  temp = tryCatch({ambil_toko(link_new[i])},
                  error = function(e){
                    temp = data.frame(nama_toko = NA,
                                      lokasi = NA,
                                      banyak_item_sold = NA,
                                      official = NA,
                                      rating = NA)
                  })
  data = rbind(data,temp)
  print(paste0('Alhamdulillah ',i,' sudah didapatkan...'))
}


data$link = link
data$link_new = link_new

data_toko_soapy = data
save(data_toko_soapy,file = "soapy toko.rda")