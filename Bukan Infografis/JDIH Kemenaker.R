rm(list=ls())
setwd('D:/Project_R/Kamis Data/BPJS')
#manggil library
library(dplyr)
library(rvest)

#list url-nya yah
url = c('https://jdih.kemnaker.go.id/peraturan-menaker.html',
        paste('https://jdih.kemnaker.go.id/jdih.php?hal=semuaperaturanpermen&halartikel=',c(2:9),sep=''))

#fungsi scrap datanya
scrap = function(url){
  data = read_html(url) %>% html_table(fill=T)
  data = data[[2]]
  return(data)
}

#mulai iterasi ambil datanya
i=1
data = scrap(url[i])

for(i in 2:9){
  temp = scrap(url[i])
  data = rbind(data,temp)
}
#export datanya
openxlsx::write.xlsx(data,'JDIH Kemnaker.xlsx')
