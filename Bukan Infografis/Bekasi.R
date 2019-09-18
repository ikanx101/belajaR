rm(list=ls())
setwd('D:/Project_R/Kamis Data/IPM Bekasi')
library(dplyr)

#kita ambil data Jawa Barat yah
#sumbernya pdf dari
# https://ipm.bps.go.id/data/provinsi/metode/baru/3200

library(pdftools)
#DATA Index Pembangunan Manusia
shade <- pdf_text("D:/Project_R/Kamis Data/IPM Bekasi/raw/Pembangunan Manusia _ Provinsi Jawa Barat.pdf")
tabel=shade[1]
tabel <- gsub(" * ","|", tabel)
writeLines(tabel, "tab1.txt")
tabel.1 <- read.delim("tab1.txt", sep = "|", nrows = 30, skip = 0) #halaman pertama dari pdf

tabel=shade[2]
tabel <- gsub(" * ","|", tabel)
writeLines(tabel, "tab2.txt")
tabel.2 <- read.delim("tab2.txt", sep = "|", nrows = 30, skip = 0) #halaman kedua dari pdf

#gabung data IPM
data.ipm=rbind(tabel.1,tabel.2)
data=reshape2::melt(data.ipm,id.vars='Wilayah')
data=data %>% filter(variable!='X') %>% filter(variable!='Id_wilayah')

area=c('Jawa Barat','Kota Bandung','Kota Depok','Kota Bekasi','Kota Bogor')
png('IPM Jawa Barat.png',width = 2300,height = 1500,res=200)
data %>% filter(Wilayah %in% area) %>% 
  mutate(variable=gsub('Tahun.','',variable)) %>%
  ggplot(aes(x=variable,y=value,group=Wilayah,color=Wilayah)) + 
  geom_line(aes(size=Wilayah)) +
  scale_size_manual(values=c(3,1,2,1,1)) +
  scale_color_manual(values=c('darkred','black','steelblue','green','orange')) +
  geom_label_repel(aes(label=value),size=3) +
  theme_economist_white() +
  theme(axis.title.x = element_blank(),axis.title.y = element_blank(),axis.text.y = element_blank()) +
  theme(legend.text = element_text(size=10,face='bold')) +
  theme(legend.title = element_text(size=11,face='bold')) +
  theme(legend.background = element_rect(size=0.5, linetype="solid",colour ="darkblue")) +
  labs(title='Indeks Pembangunan Manusia per Tahun') +
  labs(subtitle = 'Selected Cities in West Java') +
  labs(caption = 'Created using R\ni k A n x\nsource: ipm.bps.go.id') +
  theme(plot.title = element_text(size=20,face = 'bold')) +
  theme(plot.subtitle = element_text(size=14,face='italic')) +
  theme(plot.caption = element_text(size=8,face='bold'))
dev.off()

png('IPM 2018.png',width = 1400,height = 2000,res=220)
data %>% filter(variable=='Tahun.2018') %>%
  mutate(pembeda=ifelse(value>=71.30,'Above avg Jabar','Below avg Jabar')) %>%
  filter(Wilayah!='Jawa Barat') %>%
  ggplot(aes(x=reorder(Wilayah,value),y=value,label=value,color=pembeda)) + 
  geom_point(stat='identity',size=11) +
  geom_segment(aes(y = 0,x = Wilayah,yend = value,xend = Wilayah),size=2) +
  scale_color_manual(values=c('steelblue','darkred')) +
  geom_text(aes(fontface=2),color="white", size=2.5) +
  coord_flip() +
  labs(color='Keterangan IPM') +
  theme(axis.title.x = element_blank(),axis.title.y = element_blank(),axis.text.x = element_blank()) +
  theme(axis.text.y = element_text(size=9,face='bold')) +
  theme(panel.grid = element_blank(),panel.background = element_blank()) +
  theme(strip.text = element_text(size=13,face='italic')) +
  theme(axis.ticks.x = element_blank()) +
  labs(title='Indeks Pembangunan Manusia Kab/Kota\ndi Jawa Barat 2018') +
  theme(plot.title = element_text(size=18,face='bold')) +
  labs(subtitle = 'Source: ipm.bps.go.id') + theme(plot.subtitle = element_text(size=14,face='italic')) +
  labs(caption = 'Created using R\ni k A n x') + theme(plot.caption = element_text(size=8,face='bold'))
dev.off()
