setwd('D:/Project_R/Kamis Data/Gaikindo')
rm(list=ls())

url='https://raw.githubusercontent.com/ikanx101/belajaR/master/All%20Func.R'
library(devtools)
source_url(url)

library(pdftools)

#data 2019
shade <- pdf_text(".../2-gaikindo_brand_data_janjul2019.pdf")
tabel=shade[[1]]
tabel = gsub('\\,','',tabel)
tabel = gsub('MITSUBISHI MOTORS','MITSUBISHI_MOTORS',tabel)
tabel = gsub('MITSUBISHI FUSO','MITSUBISHI_FUSO',tabel)
tabel <- gsub(" * ","|", tabel)
writeLines(tabel, "tab1.txt")

retail <- read.delim("tab1.txt", sep = "|", nrows = 30, skip = 35)
retail = retail[8:20,]
colnames(retail) = c('d1','no','brand','jan','feb','mar','apr','may','jun','jul','agt','sep','okt','nov','dec','total','share','tahun')
retail$tahun=2019
retail$d1=NULL
retail.2019 = retail

#data 2018
shade <- pdf_text(".../2-gaikindo_brand_data_jandec2018-rev-honda.pdf")
tabel=shade[[1]]
tabel = gsub('\\,','',tabel)
tabel = gsub('MITSUBISHI MOTORS','MITSUBISHI_MOTORS',tabel)
tabel = gsub('MITSUBISHI FUSO','MITSUBISHI_FUSO',tabel)
tabel <- gsub(" * ","|", tabel)
writeLines(tabel, "tab1.txt")

retail <- read.delim("tab1.txt", sep = "|", nrows = 30, skip = 35)
retail = retail[5:16,]
colnames(retail) = c('d1','no','brand','jan','feb','mar','apr','may','jun','jul','agt','sep','okt','nov','dec','total','share')
retail$tahun=2018
retail$d1=NULL
retail.2018 = retail

#data 2017
shade <- pdf_text(".../2-gaikindo_brand_data_jandec2017-rev-mb-kia-renault-ud-truck.pdf")
tabel=shade[[1]]
tabel = gsub('\\,','',tabel)
tabel = gsub('MITSUBISHI MOTORS','MITSUBISHI_MOTORS',tabel)
tabel = gsub('MITSUBISHI FUSO','MITSUBISHI_FUSO',tabel)
tabel <- gsub(" * ","|", tabel)
writeLines(tabel, "tab1.txt")

retail <- read.delim("tab1.txt", sep = "|", nrows = 70, skip = 11)
retail = retail[43:56,]
colnames(retail) = c('d1','no','brand','jan','feb','mar','apr','may','jun','jul','agt','sep','okt','nov','dec','total','share')
retail$tahun=2017
retail$d1=NULL
retail.2017 = retail

#gabung semua retail
retail.2017 = retail.2017 %>% mutate_if(is.factor,as.character)
retail.2018 = retail.2018 %>% mutate_if(is.factor,as.character)
retail.2019 = retail.2019 %>% mutate_if(is.factor,as.character)
retail = rbind(retail.2017,retail.2018)
retail = rbind(retail,retail.2019)

#bikin csv
write.csv(retail,'retail gabung.csv')

#baca lagi datanya
retail = read.csv('retail gabung.csv')
retail$share = as.numeric(gsub('%','',as.character(retail$share)))

brand.terpilih=c('NISSAN','DATSUN','MAZDA','WULING')

#bikin melt
retail = retail %>% filter(brand %in% brand.terpilih)
retail = melt(retail,id.vars = c('brand','tahun'))
retail = retail %>% filter(variable!='no' & variable!='total' & variable!='share')

png('wuling.png',width = 1800,height = 1000,res=120)
retail %>% mutate(bulan=paste(variable,tahun,sep='-')) %>%
  mutate(bulan=factor(bulan,levels=c('jan-2017','feb-2017','mar-2017','apr-2017','may-2017','jun-2017',
                                     'jul-2017','agt-2017','sep-2017','okt-2017','nov-2017','dec-2017',
                                     'jan-2018','feb-2018','mar-2018','apr-2018','may-2018','jun-2018',
                                     'jul-2018','agt-2018','sep-2018','okt-2018','nov-2018','dec-2018',
                                     'jan-2019','feb-2019','mar-2019','apr-2019','may-2019','jun-2019',
                                     'jul-2019','agt-2019','sep-2019','okt-2019','nov-2019','dec-2019'))) %>% 
  ggplot(aes(x=bulan,y=value)) + geom_line(aes(group=brand,color=brand,linetype=brand),size=1.2) + 
  theme_wsj() + theme(axis.text.x = element_text(angle=90,face='bold')) +
  scale_linetype_manual(values=c("dashed","dashed","dashed","solid")) +
  labs(color='Brand',linetype='Brand') +
  theme(axis.title.x = element_blank()) +
  theme(axis.text.y = element_text(size=10)) +
  labs(y = 'Banyaknya Mobil yang Diproduksi') +
  theme(axis.title.y = element_text(size=15,face='bold')) +
  labs(title='Saat Wuling Menikung Mature Brands') +
  theme(plot.title = element_text(size=25,face='bold')) +
  geom_vline(xintercept = 14,color='darkred') +  geom_vline(xintercept = 26,color='darkred') +
  annotate(geom="text", x=11, y=1750,label="Hanya jualan Confero",size=5,color="darkred") +
  annotate(geom="text", x=20, y=2000,label="Mulai jualan Confero dan Cortez",size=5,color="darkred") +
  annotate(geom="text", x=31, y=2400,label="Mulai jualan Confero, Cortez, dan Almaz",size=5,color="darkred") +
  labs(subtitle = 'source: Data GAIKINDO') +
  theme(plot.subtitle = element_text(size=17,face = 'italic')) +
  labs(caption = 'Created using R by\ni k A n x') +
  theme(plot.caption = element_text(size=8))
dev.off()
