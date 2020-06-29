rm(list=ls())
library(rvest)
setwd("~/Documents/belajaR/Bukan Infografis/Harga Gula")

# data 3 tahun belakang
tahun = c(2017,2018,2019)
bulan = c('01','02','03','04','05','06','07','08','09','10','11','12')
z = 1
url = c()
for(i in 1:3){
  for(j in 1:12){
    url[z] = paste('https://www.isosugar.org/prices.php?pricerange=',
                   tahun[i],'-',bulan[j],'-01',sep='')
    z = z+1
  }
}

url_final = url

# data tahun 2020 only (sampai bulan 05)

tahun = c(2020)
bulan = c('01','02','03','04','05')
z = 1
url = c()
for(i in 1:1){
  for(j in 1:5){
    url[z] = paste('https://www.isosugar.org/prices.php?pricerange=',
                   tahun[i],'-',bulan[j],'-01',sep='')
    z = z+1
  }
}

url_final = c(url_final,url)

gula = function(url){
  data = read_html(url) %>% html_table(fill=T)
  data = data[[1]]
  return(data)
}

i = 1
gula_1 = gula(url_final[i])

for(i in 2:41){
  temp = gula(url_final[i])
  gula_1 = rbind(gula_1,temp)
}

data_harga_gula = gula_1

tambahan_url = 'https://www.isosugar.org/prices.php?pricerange=currentmonth'
data_last = gula(tambahan_url)
data_harga_gula_final = rbind(data_harga_gula,data_last)

save(data_harga_gula,data_harga_gula_final,file = 'data_gula.rda')