rm(list=ls())
setwd('/cloud/project/Bukan Infografis/data.bandung.go.id')

#kita ambil datanya
url = 'http://data.bandung.go.id/dataset/a68cea38-6021-43ec-91fd-f3bc80230ec8/resource/d032b43a-2da9-41eb-87cf-e716530e1c8d/download/pelanggaran---desember-2018.csv'
data = read.csv(url)
colnames(data) = tolower(colnames(data))
str(data)

#kita bebersih format dulu yah
library(dplyr)
data = 
data %>% mutate(tgl = as.character(tgl),
                tgl = lubridate::date(tgl),
                simpang = as.character(simpang))

#bebersih penulisan simpang
library(tidytext)
data = 
  data %>% select(no,simpang) %>% unnest_tokens(words,simpang,to_lower = T) %>% 
  group_by(no) %>%
  summarise(simpang = stringr::str_c(words,collapse = ' ')) %>% 
  mutate(simpang=ifelse(simpang=='buahbatu','buah batu',simpang),
         simpang=ifelse(simpang=='cikapayang ptz','cikapayang',simpang)) %>%
  View()

#ini utk ngecek yah
data %>% select(no,simpang) %>% unnest_tokens(words,simpang,to_lower = T) %>% group_by(no) %>%
  summarise(simpang = stringr::str_c(words,collapse = ' ')) %>% View()
write.csv(data,'pelanggaran kota bandung.csv')

#kita buat visualisasinya yah
library(ggplot2)
library(ggthemes)
library(ggpubr)

#pertama
data %>% select(simpang,waktu,total.pelanggaran) %>% group_by(simpang,waktu) %>% 
  summarise(total.pelanggaran=sum(total.pelanggaran)) %>% 
  ggplot(aes(x=simpang,y=total.pelanggaran)) + 
  geom_col(color='steelblue',fill='white') +
  geom_label(aes(label=total.pelanggaran),size=1) +
  facet_wrap(~waktu,ncol = 1,nrow = 2) +
  theme_pubclean() +
  theme(axis.title = element_blank(),
        axis.text.x = element_text(angle=90))
ggsave('')