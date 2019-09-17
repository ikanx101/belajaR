setwd('D:/Project_R/Kamis Data/Karhootla')
rm(list=ls())

url='https://raw.githubusercontent.com/ikanx101/belajaR/master/All%20Func.R'
library(devtools)
source_url(url)

library(pdftools)
library(rvest)

#ambil data luas wilayah provinsi
url='https://id.wikipedia.org/wiki/Provinsi_di_Indonesia'
data = read_html(url) %>% html_table(fill=T)
data = data[[3]]
colnames(data) = tolong.bersihin.judul.donk(data)
data = data.frame(provinsi=data$provinsi,luas.km2=data$luas.total.km2)
data$luas.km2 = data$luas.km2*1000
data$luas.hektar = data$luas.km2*100
luas.prov = data

#Ambil data dari KLHK
#luas terbakar
url = 'http://sipongi.menlhk.go.id/hotspot/luas_kebakaran'
tabel = read_html(url) %>% html_table(fill=T)
tabel = tabel[[1]]
colnames(tabel) = c('no','provinsi',2014,2015,2016,2017,2018,2019)
tabel = tabel[-1,]
tabel = reshape2::melt(tabel,id.vars='provinsi')
tabel = tabel %>% filter(variable!='no') %>% mutate(value=gsub(',','',value)) %>%
  mutate(value=gsub('\\.','',value)) %>% mutate(value=gsub('-',0,value)) %>%
  mutate(value=as.numeric(value))
colnames(tabel) = c('provinsi','tahun','luas.terbakar')
tabel$luas.terbakar = tabel$luas.terbakar/100
tabel = tabel %>% filter(provinsi!='TOTAL')

#select provinsi
prov = tabel %>% filter(tahun==2019) %>% arrange(luas.terbakar) %>% tail(9)
prov = prov$provinsi

png('Tren Provinsi.png',width = 1900,height = 1000,res=190)
tabel %>% filter(provinsi %in% prov) %>%
  mutate(provinsi=factor(provinsi,levels=prov)) %>%
  arrange((provinsi)) %>% 
  ggplot(aes(x=tahun,y=luas.terbakar)) + geom_bar(stat='identity',aes(fill=provinsi)) +
  theme_minimal() + geom_text(aes(label=round(luas.terbakar/1000,2)),size=2.2) +
  labs(title='Tren Luas Lahan Terbakar per Tahun') + 
  labs(subtitle='Top 9 Provinsi dengan Lahan Terbakar Terluas di 2019\nsource: SIPONGI KEMENLHK') +
  labs(y='Luas lahan terbakar (dalam ribu hektar)') +
  scale_y_continuous(labels = scales::comma) +
  theme(plot.title = element_text(size=20,face='bold'),plot.subtitle = element_text(size=13,face='italic')) +
  theme(axis.title.x = element_blank()) +
  theme(axis.title.y = element_text(size=9,face='bold')) +
  labs(caption='Created using R\ni k A n x') +
  theme(plot.caption = element_text(size=8,face='bold')) +
  facet_wrap(~provinsi) + 
  theme(strip.background = element_rect(colour="black", fill="white",size=1.5, linetype="solid")) +
  theme(legend.position = 'none') +
  theme(axis.text.y = element_blank())
dev.off()

#gabung data
luas.prov$provinsi=as.character(luas.prov$provinsi)
tabel$provinsi = gsub('DKI ','',tabel$provinsi)
new=merge(luas.prov,tabel)
new = new %>% mutate(persen.terbakar = round((luas.terbakar/luas.hektar*100),2))

#ambil titik api
url='http://sipongi.menlhk.go.id/hotspot/matrik_tahunan'
titik.api = read_html(url) %>% html_table()
titik.api = titik.api[[1]]

titik.api = 
  titik.api %>% filter(Provinsi %in% prov) %>% reshape2::melt(id.vars='Provinsi') %>% filter(variable!='Okt') %>%
  filter(variable!='Nov') %>% filter(variable!='Des') 

titik.api$value = as.numeric(titik.api$value)
titik.api$value = ifelse(is.na(titik.api$value),0,titik.api$value)

png('Titik Api.png',width = 1900,height = 1000,res=190)
titik.api %>% filter(Provinsi %in% c('Kalimantan Tengah','Kalimantan Barat','Jambi','Riau')) %>% 
  ggplot(aes(x=variable,y=value,group=Provinsi)) +geom_line(stat='identity',size=1,aes(color=Provinsi,linetype=Provinsi)) +
  scale_linetype_manual(values=c("dotted","dotted","dotted",'solid')) + theme_minimal() +
  labs(title='Apa yang membuat Riau menjadi `Spesial`?') +
  labs(subtitle = '4 Provinsi dengan titik panas terbanyak di bulan September 2019\nsource: SIPONGI KEMENLHK') +
  theme(plot.title = element_text(size=20,face='bold'),plot.subtitle = element_text(size=13,face='italic')) +
  theme(axis.title.x = element_blank()) +
  theme(axis.title.y = element_text(size=9,face='bold')) +
  labs(caption='Created using R\ni k A n x') +
  theme(plot.caption = element_text(size=8,face='bold')) +
  labs(y='Banyaknya Titik Panas')
dev.off()

#notes:
#beberapa code lines seperti kurang rapi dan simpel
#mohon maklum, dikerjain sambil buru2
