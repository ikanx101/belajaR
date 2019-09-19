rm(list=ls())
setwd('D:/Project_R/Kamis Data/IPM Bekasi')

#Panggil All Func dari Cloud
library(devtools)
url='https://raw.githubusercontent.com/ikanx101/belajaR/master/All%20Func.R'
source_url(url)

#web scrap dari wikipedia
library(rvest)
url = 'https://id.wikipedia.org/wiki/Daftar_kabupaten_dan_kota_di_Jawa_Barat'
tabel = read_html(url) %>% html_table(fill=T)
tabel = tabel[[1]]

#bersihin data dulu
colnames(tabel) = tolong.bersihin.judul.donk(tabel)
tabel = data.frame(kab.kota = tabel$kabupaten.kota,
                   luas = tabel$`luas.wilayah.km2[1]`,
                   jml = tabel$`jumlah.penduduk.2017[1]`,
                   kec = tabel$kecamatan)
tabel = ubahin.data.dari.faktor.ke.karakter.donk(tabel)
tabel$luas = gsub('\\.','',tabel$luas)
tabel$luas = gsub('\\,','.',tabel$luas)
tabel$jml = gsub('\\.','',tabel$jml)

#ubahin ke dalam numerik
tabel$luas = as.numeric(tabel$luas)
tabel$jml = as.numeric(tabel$jml)

#hitung mean
mean.luas = mean(tabel$luas)
mean.jml = mean(tabel$jml)

library(ggrepel)
library(ggthemes)
png('Jawa Barat Wilayah Penduduk.png',width = 7500,height = 4500,res=700)
tabel %>% ggplot(aes(x=luas,y=jml,label=kab.kota)) + geom_point(aes(size=kec,color=kec)) + 
  geom_text_repel(size=3) + geom_vline(xintercept = mean.luas) +
  geom_hline(yintercept = mean.jml) + theme_gdocs() + labs(x='Luas Wilayah (km2)') +
  labs(y='Jumlah Penduduk (2017)') + theme(axis.text.x = element_blank(),axis.text.y = element_blank()) +
  theme(legend.position = 'none') + labs(subtitle = 'Luas Wilayah VS Jumlah Penduduk',title = 'Jawa Barat') +
  theme(plot.title = element_text(size=20,face='bold')) +
  theme(plot.subtitle = element_text(size=16,face='italic')) +
  theme(axis.title.y = element_text(face='bold')) +
  theme(axis.title.x = element_text(face='bold'))
dev.off()
