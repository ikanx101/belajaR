rm(list=ls())
#setwd('D:/Project_R/Kamis Data/Nutrimart')

#panggil libs
if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}
if(!require(rvest)){
  install.packages("rvest")
  library(rvest)
}
if(!require(tidyr)){
  install.packages("tidyr")
  library(tidyr)
}
if(!require(tidytext)){
  install.packages("tidytext")
  library(tidytext)
}
if(!require(openxlsx)){
  install.packages("openxlsx")
  library(openxlsx)
}
if(!require(reshape2)){
  install.packages("reshape2")
  library(reshape2)
}
print('Proses sedang berjalan... Harap sabar yah...')
url = c('https://www.hemat.id/katalog/makanan-minuman/',
        paste('https://www.hemat.id/katalog/makanan-minuman/?page=',
              c(2:30),sep=''))

#bikin fungsi scrap link produk
scrap_links = function(url){
  link = read_html(url) %>% html_nodes('a') %>% html_attr('href')
  data = tibble(
    id = c(1:length(link)),
    url_produk = link
  ) %>% filter(grepl('harga',link,ignore.case = T))
  return(data)
}

#mulai iterasi
i=1
data = scrap_links(url[i])
for(i in 2:30){
  temp = scrap_links(url[i])
  data = rbind(data,temp)
}

#hasil finalnya adalah
data = data %>% mutate(url_produk = paste('https://www.hemat.id',
                                          url_produk,
                                          sep=''))

#kita bikin fungsi scrap per url_produk
scrap_info_produk = function(url_dummy){
  new.data = read_html(url_dummy) %>% {
    tibble(
      toko = html_nodes(.,'em') %>% html_text(),
      produk = html_nodes(.,'.req .title') %>% html_text(),
      start.date = html_nodes(.,'.start .date') %>% html_text(),
      end.date = html_nodes(.,'.end .date') %>% html_text(),
      label = html_nodes(.,'.label:nth-child(1)') %>% html_text(),
      isi = html_nodes(.,'.req .desc') %>% html_text()
    )
  }
  return(new.data)
}

#mulai iterasi untuk url produk
i = 1
data_produk = scrap_info_produk(data$url_produk[i])
data_produk$id = i

for(i in 2:length(data$url_produk)){
  temp_produk = scrap_info_produk(data$url_produk[i])
  temp_produk$id = i
  data_produk = rbind(data_produk,temp_produk)
}

#kita unmelt manual yah
#soalnya isinya character, bukan numerik
dummy = unique(data_produk$label)

rapihin = function(dummy){
  tes.fungsi = data_produk %>% filter(label %in% dummy) %>% mutate(label=NULL)
  colnames(tes.fungsi)[length(tes.fungsi)-1] = dummy
  return(tes.fungsi)
}

i=1
final_data = rapihin(dummy[i])

for(i in 2:length(dummy)){
  final_temp = rapihin(dummy[i])
  final_data = merge(final_data,final_temp,all=T)
}

final_data = final_data %>% distinct() %>% mutate(id=NULL)

#sekarang bebersih format
final_data = final_data %>% mutate(
  toko = gsub('di ','',toko,fixed = T),
  `Berlaku di` = gsub('\n','',`Berlaku di`,fixed = T),
  `Berlaku di` = gsub('  ','',`Berlaku di`,fixed = T),
  `Harga Promo` = gsub('\n','',`Harga Promo`,fixed = T),
  `Harga Promo` = gsub('  ','',`Harga Promo`,fixed = T)
)

openxlsx::write.xlsx(final_data,file='Promo Makanan dan Minuman dalam minggu ini.xlsx')
print('Proses sudah selesai, silakan cek my document. Ada file baru bernama: Promo Makanan dan Minuman dalam minggu ini.xlsx')
