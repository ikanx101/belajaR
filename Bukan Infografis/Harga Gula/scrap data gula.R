rm(list=ls())
library(rvest)
setwd('D:/Project_R/Harga Gula')
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

gula = function(url){
  data = read_html(url) %>% html_table(fill=T)
  data = data[[1]]
  return(data)
}

i = 1
gula_1 = gula(url[i])

for(i in 2:36){
  temp = gula(url[i])
  gula_1 = rbind(gula_1,temp)
}

data_harga_gula = gula_1

tambahan_url = 'https://www.isosugar.org/prices.php?pricerange=currentmonth'
data_last = gula(tambahan_url)
data_harga_gula_final = rbind(data_harga_gula,data_last)

save(data_harga_gula,data_harga_gula_final,file = 'data_gula.rda')