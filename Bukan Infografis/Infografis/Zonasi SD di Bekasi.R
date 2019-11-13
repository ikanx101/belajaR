rm(list=ls())
library(rvest)
setwd('D:/Project_R/Kamis Data/SD Bekasi')

#mencari SD di Kecamatan Bekasi Timur
url = 'https://referensi.data.kemdikbud.go.id/index11.php?kode=026500&level=2'

text = read_html(url) %>% html_nodes('a') %>% html_text()
links = read_html(url) %>% html_nodes('a') %>% html_attr('href')

data = data.frame(text,links)
data = data %>% filter(grepl('kec.',text,ignore.case = T)) %>%
  mutate(links = paste('https://referensi.data.kemdikbud.go.id/',links,sep=''))

i=1
data.new = read_html(data$links[i]) %>% html_table(fill=T)
data.new = data.new[[2]]

for(i in 2:length(data$links)){
  dummy = read_html(data$links[i]) %>% html_table(fill=T)
  dummy = dummy[[2]]
  data.new = rbind(data.new,dummy)
}

#ambil fungsi
library(devtools)
url='https://raw.githubusercontent.com/ikanx101/belajaR/master/All%20Func.R'
source_url(url)

#bersihin colnames
colnames(data.new) = tolong.bersihin.judul.donk(data.new)

#ambilin sd
data.new = data.new %>% filter(status!='SWASTA') %>% filter(grepl('sd',nama.satuan.pendidikan,ignore.case = T))

#liat titiknya
alamat = paste(data.new$nama.satuan.pendidikan,data.new$alamat,data.new$kelurahan,' kota bekasi, indonesia',sep=',')

#mulai fun parts nya
library(googleway)
lat = c()
long = c()
key = #ENTER YOUR KEY HERE
for(i in 1:length(alamat)){
  hasil = google_geocode(address = alamat[i],key = key)
  if(length(hasil$results)!=0){
    lat[i] = hasil$results$geometry$location$lat
    lng[i] = hasil$results$geometry$location$lng
  } else {
    lat[i] = NA
    lng[i] = NA
  }
}
#satukan hasilnya
result = data.frame(data.new$nama.satuan.pendidikan,alamat,lat,lng)

#yuk bikin map
library(leaflet)
map = leaflet() %>% addTiles() %>% addCircles(lat=result$lat,lng=result$lng,radius=1000)
library(htmlwidgets)
saveWidget(map,'Zonasi di Bekasi.html')

#passingthroughresearcher.wordpress.com
