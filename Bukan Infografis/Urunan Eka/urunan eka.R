# Laporan Keuangan Urunan Untuk Eka 
# SMAN 1 Bekasi angkatan 2004

rm(list=ls())
setwd("/cloud/project/Bukan Infografis/Urunan Eka")

# kita ambil datanya yah
data = read.csv('OHAMMADR2186_1729801.CSV',skip=4)
saldo_awal = 13495.26

library(dplyr)
library(ggplot2)
library(ggpubr)
library(ggrepel)
library(reshape2)

colnames(data) = janitor::make_clean_names(colnames(data))
data = data %>% filter(!is.na(saldo)) %>%
  mutate(tanggal = case_when(tanggal=="'08/01"~'8 Jan',
                             tanggal=="'09/01"~'9 Jan',
                             tanggal=="'PEND "~'10 Jan'))

# kita buat chart pertama
chart_1 = 
  data %>% mutate(saldo = saldo - saldo_awal,id = c(1:length(tanggal))) %>%
  select(tanggal,id,saldo) %>%
  ggplot(aes(x=id,y=saldo,color=tanggal)) + geom_line() +
  geom_text_repel(aes(label = paste(round(saldo/1000000,2),'juta',sep=' ')),size=3) +
  theme_minimal() +
  labs(title='Laporan Penambahan Saldo Urunan',
       subtitle='SMAN 1 Bekasi - 2004',
       caption='last update: 10 Jan 2020 11:30',
       color='Tanggal:') +
  theme(axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        plot.title = element_text(size=20,face='bold.italic'))
#chart_1

# kita buat chart kedua
chart_2 = 
  data %>% select(tanggal,jumlah) %>% group_by(tanggal) %>%
  summarise(jumlah = sum(jumlah)) %>% 
  mutate(tanggal=factor(tanggal,levels = c('8 Jan','9 Jan','10 Jan'))) %>%
  ggplot(aes(x=tanggal,y=jumlah)) + geom_col(color='steelblue',fill='white') +
  theme_minimal() +
  labs(title = 'Penambahan Saldo Harian') +
  geom_label(aes(label = paste(round(jumlah/1000000,2),'juta',sep=' ')),size=4) +
  theme(axis.title = element_blank(),
        axis.text.y = element_blank(),
        plot.title = element_text(size=10,face='bold.italic'))
#chart_2  

# kita buat chart ketiga
chart_3 = 
  data %>% select(tanggal,jumlah) %>% group_by(tanggal) %>%
  summarise(jumlah = n()) %>% 
  mutate(tanggal=factor(tanggal,levels = c('8 Jan','9 Jan','10 Jan'))) %>%
  ggplot(aes(x=tanggal,y=jumlah)) + geom_col(color='steelblue',fill='white') +
  theme_minimal() +
  labs(title = 'Transaksi Masuk') +
  geom_label(aes(label = paste(jumlah,'trx',sep=' ')),size=4) +
  theme(axis.title = element_blank(),
        axis.text.y = element_blank(),
        plot.title = element_text(size=10,face='bold.italic'))
#chart_3  

gabung_1 = ggarrange(chart_3,chart_2,ncol=1,nrow=2)
gabung = ggarrange(gabung_1,chart_1,ncol=2,nrow=1,widths=c(1,3))

ggsave(gabung,file='final eka.png',width=10,height=7,dpi=150)
