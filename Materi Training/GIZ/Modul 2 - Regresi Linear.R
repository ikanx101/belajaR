rm(list=ls())

#load libraries
library(dplyr) #for data carpentry
library(ggplot2) #for graphic
library(tidyr) #tambahan dari dplyr
library(ggpubr) #untuk tambahan reg line pada ggplot2

# set working directory
setwd("/cloud/project/Materi Training/GIZ")

#####################################
# AMBIL DATA
# yuk kita mulai untuk ambil datanya
data = read.csv('latihan regresi.csv')

#####################################
# DESCRIPTIVE ANALYSIS
# kita liat sebarannya dulu yuk
# sebaran qty
# histogram
data %>% ggplot(aes(x=qty)) + geom_histogram(aes(y=..density..)) + geom_density()
#boxplot
data %>% ggplot(aes(y=qty)) + geom_boxplot()

# sebaran harga
# histogram
data %>% ggplot(aes(x=harga)) + geom_histogram(aes(y=..density..)) + geom_density()
#boxplot
data %>% ggplot(aes(y=harga)) + geom_boxplot()

#####################################
# UJI KENORMALAN
# hyphotheses testing
# H0 = data berdistribusi normal
# H1 = data tidak berdistribusi normal
# tolak H0 jika p-value < 0.05

#untuk qty
normal_qty = shapiro.test(data$qty)
ifelse(normal_qty$p.value < 0.05,'Tolak H0 -- tidak normal','H0 tidak ditolak -- normal')

#untuk harga
normal_harga = shapiro.test(data$harga)
ifelse(normal_harga$p.value < 0.05,'Tolak H0 -- tidak normal','H0 tidak ditolak -- normal')

#####################################
# TEMUAN SEMENTARA
# Ditemukan bahwa data harga tidak normal
# Pertanyaannya, apakah data harus berdistribusi normal untuk dilakukan annaisa regresi?

#####################################
# Mari kita bangun model regresinya
model_reg = lm(qty~harga,data = data)

# memanggil modelnya
model_reg

# melihat keseluruhan model
summary(model_reg)

# sekarang kita lihat goodness of fit dari modell regresi
# pertama R-squared, diambil dari nilai multiple R-squared 
# atau bisa juga dihitung menggunakan:
r_squared = modelr::rsquare(model_reg,data)
# apa arti dari r_squared?

# lalu ada p-value ~ 0
# karena p-value < 0.05 artinya model berpengaruh terhadap sales qty-nya

# ada yang namanya mean absolut error
mean_absolut_error = modelr::mae(model_reg,data) #harus  bernilai kecil

#####################################
# METODE LAIN
# cara membangun model regresi menggunakan visual grafis
data %>% ggplot(aes(x=harga,y=qty)) + 
  geom_point() + 
  geom_smooth(method='lm') +
  theme_pubclean() + 
  stat_regline_equation(label.y = 7,aes(label =  paste(..eq.label.., ..rr.label.., sep = "~~~~"))) +
  labs(title = 'Model Regresi: Price Elasticity Index',
                          subtitle = 'Data harga vs sales qty',
                          caption = 'Created using R',
                          x = 'Harga produk (dalam ribu rupiah)',
                          y = 'Sales Qty') +
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(size=25,face='bold.italic'),
        plot.caption = element_text(size=10,face='italic'))
ggsave('hasil regresi linear.png',width = 13, height = 7, dpi = 450)

# CONTOH LAINNNYA
# alternatif data: https://raw.githubusercontent.com/rc-dbe/bigdatacertification/master/dataset/Salary_Data.csv
