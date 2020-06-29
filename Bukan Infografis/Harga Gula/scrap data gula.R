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

data = 
  data_harga_gula_final %>% 
  janitor::clean_names() %>% 
  tidyr::separate(isa_daily_price,
                  into = c('harga','unit'),
                  sep = '\\ ') %>% 
  mutate(harga = as.numeric(harga),
         harga = ifelse(harga == 0, 12.56, harga)) %>% 
  tidyr::separate(date,into = c('tgl','bln','thn'),sep='\\ ') %>% 
  select(tgl,bln,thn,harga) %>%
  mutate(bln = case_when(bln == 'Jan' ~ 1,
                         bln == 'Feb' ~ 2,
                         bln == 'Mar' ~ 3,
                         bln == 'Apr' ~ 4,
                         bln == 'May' ~ 5,
                         bln == 'Jun' ~ 6,
                         bln == 'Jul' ~ 7,
                         bln == 'Aug' ~ 8,
                         bln == 'Sep' ~ 9,
                         bln == 'Oct' ~ 10,
                         bln == 'Nov' ~ 11,
                         bln == 'Dec' ~ 12)) %>%
  mutate(new_tanggal = paste(bln,tgl,thn,sep='/'),
         new_tanggal = lubridate::mdy(new_tanggal)) %>%
  arrange(new_tanggal) %>% 
  select(new_tanggal,harga)

save(data,file = 'data_gula.rda')