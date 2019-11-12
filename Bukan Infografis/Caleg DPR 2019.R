rm(list=ls())
library(tidyverse)
library(janitor)

#Scrap data
caleg_dpr_2019 <- read_delim("https://raw.githubusercontent.com/seuriously/caleg_dpr_2019/master/caleg_dpr.csv", delim = "|", na = c("", "NA", "-"))

caleg_dpr_2019 <-
  caleg_dpr_2019 %>%
  select(
    partai,
    provinsi,
    Dapil,
    No..Urut,
    Nama.Lengkap,
    Jenis.Kelamin,
    Gelar.Akademis.Depan,
    Gelar.Akademis.Belakang,
    Pendidikan,
    Pekerjaan,
    kota_tinggal,
    Tempat.Lahir,
    Tanggal.Lahir,
    umur,
    Agama,
    Status.Perkawinan,
    Jumlah.Anak,
    Motivasi,
    Status.Khusus
  ) %>%
  clean_names()

data = caleg_dpr_2019
#Kode di atas saya ambil dari github kamisdataR

setwd('D:/Project_R/Kamis Data/Caleg DPR')

#Ambil all func
library(devtools)
url='https://raw.githubusercontent.com/ikanx101/belajaR/master/All%20Func.R'
source_url(url)

#cleaning
colnames(data) = tolong.bersihin.judul.donk(data)
data = data %>% filter(!is.na(no.urut))

#per provinsi
png('Sebaran Umur Caleg.png',width = 850, height = 450)
data %>% filter(umur<90) %>% ggplot(aes(x=provinsi,y=umur)) + geom_boxplot() + theme_fivethirtyeight() +
  theme(axis.text.x = element_text(angle=90)) +
  labs(title = 'Sebaran Umur Caleg per Provinsi',subtitle = 'source: KPU') +
  theme(plot.subtitle = element_text(face = 'italic'))
dev.off()

#per partai
png('Sebaran Umur Caleg per partai.png',width = 850, height = 450)
data %>% filter(umur<90) %>% ggplot(aes(x=partai,y=umur)) + geom_boxplot() + theme_economist() +
  theme(axis.text.x = element_text(angle=90)) +
  labs(title = 'Sebaran Umur Caleg per Partai',subtitle = 'source: KPU') +
  theme(plot.subtitle = element_text(face = 'italic'))
dev.off()

data %>% filter(umur<90) %>% ggplot(aes(x=umur,y=jumlah.anak)) + geom_point() + theme_economist() +
  theme(axis.text.x = element_text(angle=90)) +
  labs(title = 'Sebaran Umur Caleg per Partai',subtitle = 'source: KPU') +
  theme(plot.subtitle = element_text(face = 'italic'))
