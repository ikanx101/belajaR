rm(list=ls())
#setwd('D:/Project_R/SNI Midi')
library(rvest)
library(dplyr)
library(tidyr)

#halaman depan webnya:
#http://sispk.bsn.go.id/SNI/DaftarList
#di save as html dulu yah
#gunanya agar bisa diextract link nya aja
#simpan as SNI.html

url = read_html('SNI.html') %>% 
  html_nodes('.text-left+ .text-center a') %>% 
  html_attr('href')


scrap = function(url){
  data = 
    read_html(url) %>% {
    tibble(
      judul = html_nodes(.,'.form-group:nth-child(1) .judul') %>%
        html_text(),
      isi = html_nodes(.,'.form-group:nth-child(8) .isi') %>%
        html_text(),
      status = html_nodes(.,'.form-group:nth-child(9) .isi') %>%
        html_text(),
      ics = html_nodes(.,'.form-group:nth-child(11) td:nth-child(2)') %>%
        html_text(),
      judul_ina = html_nodes(.,'.form-group:nth-child(11) td:nth-child(3)') %>%
        html_text()
    )
  }
  return(data)
}

data = scrap(url[1])

for(i in 2:length(url)){
  temp = scrap(url[i])
  data = rbind(data,temp)
}
openxlsx::write.xlsx(data,'SNI dari 100 entry.xlsx')
