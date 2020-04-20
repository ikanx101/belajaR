# PAS Banget Dashboard

rm(list=ls())

setwd("/cloud/project/Bukan Infografis/PAS Banget")

library(readxl)
library(dplyr)
library(ggplot2)
library(ggpubr)

excel_sheets('Data Orderan.xlsx')

data = read_excel('Data Orderan.xlsx',sheet = 'Rekap') 
colnames(data) = janitor::make_clean_names(colnames(data)) 
nama_var = colnames(data)
data$id = c(1:length(data$tanggal))

data_1 = data %>% select(nama_var[1:6],id)
data_2 = data %>% select(nama_var[7:23],id) %>%
  mutate_if(is.character,as.numeric)


data = merge(data_1,data_2)

data =
  data %>% 
  filter(!is.na(tanggal),
         !is.na(nama_pelanggan)) %>%
  mutate(
    tanggal = lubridate::date(tanggal),
    hari = lubridate::wday(tanggal, label=T)
    )


data[is.na(data)] = 0

rekap = 
data %>% 
  mutate(transfer_cash = ifelse(transfer_cash == 'Cash',
                                1,
                                0),
         total_belanja_212_mart = as.numeric(total_belanja_212_mart),
         bagi_hasil_ojek_80_percent = as.numeric(bagi_hasil_ojek_80_percent),
         ) %>%
  group_by(tanggal) %>%
  summarise(order = n(),
            n_ojek = length(unique(ojek)),
            pelanggan = length(unique(nama_pelanggan)),
            pembayaran_cash = round(sum(transfer_cash)/n()*100,1),
            trans_212 = sum(x212_mart),
            trans_nusantara = sum(pasar_nusantara),
            trans_lainnya = sum(other),
            total_212 = sum(total_belanja_212_mart),
            total_nusantara = sum(total_belanja_pasar_nusantara),
            total_others = sum(total_belanja_others),
            total_all = sum(total_belanja_semua),
            fee_ojek = sum(bagi_hasil_ojek_80_percent),
            donasi = sum(donasi_pelanggan)
            )

chart_1 = 
  rekap %>%
  ggplot() +
  geom_line(aes(x = tanggal,
                y = order),
            group = 1,
            color = 'darkred') +
  geom_label(aes(x = tanggal,
                 y = order,
                 label = paste0(order,' order')),
             size = 2,
             color = 'darkred') +
  geom_line(aes(x = tanggal,
                y = n_ojek),
            group = 1,
            color = 'steelblue') +
  geom_label(aes(x = tanggal,
                 y = n_ojek,
                 label = paste0(n_ojek,' org ojek')),
             size = 2,
             color = 'steelblue') +
  theme_minimal() +
  labs(title = 'Rekap Harian',
       x = 'Tanggal',
       subtitle = 'Merah: Banyaknya order\nBiru: Banyaknya ojek yang terlibat') +
  theme(axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank())

chart_2 = 
  data %>%
  group_by(tanggal) %>%
  summarise(rata = mean(total_belanja_semua),
            min = min(total_belanja_semua),
            max = max(total_belanja_semua)) %>%
  ggplot() +
  geom_col(aes(x = tanggal,
               y = rata),
           size = 1,
           color = 'steelblue',
           fill = 'orange',
           alpha = .2) +
  geom_errorbar(aes(x = tanggal,
                    ymin = min,
                    ymax = max),
                size=.8,
                width = .25) +
  geom_label(aes(x = tanggal,
                 y = rata,
                 label = paste0('Rp',round(rata/1000,1),' ribu')),
             size = 2) +
  theme_minimal() +
  labs(title = 'Rata-Rata Transaksi Belanja Harian',
       x = 'Tanggal',
       subtitle = 'Garis menunjukkan range (min - max) belanjaan pada hari tersebut') +
  theme(axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank())

chart_3 = 
  rekap %>%
  ggplot() +
  geom_line(aes(x = tanggal,
                y = fee_ojek),
            group = 1,
            color = 'darkred') +
  geom_label(aes(x = tanggal,
                 y = fee_ojek,
                 label = paste0('Rp',round(fee_ojek/1000,1),' ribu')),
             size = 2,
             color = 'darkred') +
  geom_line(aes(x = tanggal,
                y = donasi),
            group = 1,
            color = 'steelblue') +
  geom_label(aes(x = tanggal,
                 y = donasi,
                 label = paste0('Rp',round(donasi/1000,1),' ribu')),
             size = 2,
             color = 'steelblue') +
  theme_minimal() +
  labs(title = 'Fee Ojek dan Donasi Harian',
       x = 'Tanggal',
       subtitle = 'Merah: Total fee ojek\nBiru: Total donasi pelanggan') +
  theme(axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank())

chart_4 =
  rekap %>%
  select(tanggal,trans_212,trans_nusantara,trans_lainnya) %>%
  reshape2::melt(id.vars = 'tanggal') %>%
  mutate(variable = case_when(variable == 'trans_212' ~ '212 Mart',
                              variable == 'trans_nusantara' ~ 'Pasar Nusantara',
                              variable == 'trans_lainnya' ~ 'Lainnya')) %>%
  rename(toko = variable,
         trans = value) %>%
  ggplot(aes(x = tanggal,
             y = trans)) +
  geom_col(aes(fill = toko),
           color = 'steelblue',
           size = .7,
           alpha = .3) +
  theme_minimal() +
  labs(title = 'Berapa Banyak Toko yang Terlibat',
      subtitle = 'Dalam real number',
      x = 'Tanggal',
      fill = 'Jenis Toko') +
  theme(axis.title.y = element_blank())


chart_5 = 
  rekap %>%
  mutate(transfer = 100 - pembayaran_cash) %>%
  select(tanggal,pembayaran_cash,transfer) %>%
  reshape2::melt(id.vars = 'tanggal') %>%
  mutate(variable = case_when(variable == 'pembayaran_cash' ~ 'Cash',
                              variable == 'transfer' ~ 'Transfer')) %>%
  ggplot(aes(x = tanggal,
             y = value)) +
  geom_col(aes(fill = variable),
           color = 'steelblue',
           size = .7,
           alpha = .3) +
  theme_minimal() +
  labs(title = 'Cara Pembayaran Pelanggan',
       subtitle = 'Dalam persentase',
       x = 'Tanggal',
       fill = 'Cara Pembayaran') +
  theme(axis.title.y = element_blank())

koor_pasar =
  data %>%
  group_by(tanggal) %>%
  summarise(fee_pasar = sum(bagi_hasil_koord_pasar_80_percent))

chart_6 = 
  data %>%
  group_by(tanggal,ojek) %>%
  summarise(donasi = sum(donasi_pelanggan),
            fee = sum(bagi_hasil_ojek_80_percent)) %>%
  ungroup() %>%
  mutate(fee_total = donasi + fee) %>%
  select(tanggal,ojek,fee_total) %>% 
  merge(koor_pasar) %>%
  mutate(final = ifelse(ojek=='Indri',
                        fee_total+fee_pasar,
                        fee_total)) %>%
  ggplot() +
  geom_line(aes(x = tanggal,
                y = final),
            color = 'steelblue') +
  geom_label(aes(x = tanggal,
                 y = final,
                 label = paste0('Rp',round(final/1000,1),' ribu')),
             size = 2) +
  facet_wrap(~ojek,nrow=2,ncol=2) +
  theme_minimal() +
  labs(title = 'Fee Masing-Masing Driver Ojek',
       x = 'Tanggal') +
  theme(axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank()) +
  theme(strip.background = element_rect(colour="steelblue", fill="white", 
                                        size=1.5, linetype="solid"))

item_1 = ggarrange(chart_1,chart_3,chart_6,ncol=3,nrow=1,widths = c(.5,.5,1))
item_2 = ggarrange(chart_2,chart_4,chart_5,ncol=3,nrow=1)
ggarrange(item_1,item_2,ncol=1,nrow=2,heights = c(1.25,.8))
ggsave('pas.png',width = 14,height=6,dpi=500)