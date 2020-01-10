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
  labs(title='Penambahan Saldo Urunan utk Eka',
       subtitle='SMAN 1 Bekasi - 2004',
       caption='last update: 10 Jan 2020 11:12',
       color='Tanggal:') +
  theme(axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        plot.title = element_text(size=20,face='bold.italic'))

# kita buat chart kedua
chart_2 = 
  data %>% select(tanggal,jumlah) %>% group_by(tanggal) %>%
  summarise(jumlah = sum(jumlah)) %>%
  ggplot(aes(x=tanggal,y=jumlah)) + geom_col(color='steelblue',fill='white') +
  theme_minimal() +
  labs(title = 'Saldo Harian Urunan utk Eka',
       subtitle = 'SMAN 1 Bekasi - 2004') +
  geom_label(aes(label = round(jumlah/1000000,2)),size=4) +
  theme(axis.title = element_blank(),
        axis.text.y = element_blank(),
        plot.title = element_text(size=13,face='bold.italic'))
chart_2  
