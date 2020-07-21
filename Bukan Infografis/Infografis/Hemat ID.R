rm(list=ls())

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

# tulis semua pages yang mungkin
url = c('https://www.hemat.id/katalog/makanan-minuman/',
        paste('https://www.hemat.id/katalog/makanan-minuman/?page=',
              c(2:30),sep=''))

# bikin fungsi
scrap_links = function(url){
  link = read_html(url) %>% html_nodes('a') %>% html_attr('href')
  data = tibble(
    id = c(1:length(link)),
    url_produk = link
  ) %>% filter(grepl('harga',link,ignore.case = T))
  return(data)
}

# bikin looping
i=1
data = scrap_links(url[i])
for(i in 2:30){
  temp = scrap_links(url[i])
  data = rbind(data,temp)
  kata = paste0('Scrape link dari page ke-',i)
  print(kata)
}

#ditambahkan alamat site awal
data = data %>% 
  mutate(url_produk = paste('https://www.hemat.id',
                            url_produk,
                            sep=''))

# fungsi berikutnya
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

# Looping All
i = 1
data_produk = scrap_info_produk(data$url_produk[i])
data_produk$id = i
data_produk$url_ref = data$url_produk[i]
for(i in 2:length(data$url_produk)){
  temp_produk = scrap_info_produk(data$url_produk[i])
  temp_produk$id = i
  temp_produk$url_ref = data$url_produk[i]
  data_produk = rbind(data_produk,temp_produk)
  kata = paste0('Ambil data detail dari link produk ke-',i)
  print(kata)
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
