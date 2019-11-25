rm(list=ls())

library(dplyr)
library(ggplot2)
library(tidyr)

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
ifelse(normal_qty$p.value < 0.05,'Tolak H0','H0 tidak ditolak')

#untuk harga
normal_harga = shapiro.test(data$harga)
ifelse(normal_harga$p.value < 0.05,'Tolak H0','H0 tidak ditolak')

#####################################
# TEMUAN SEMENTARA
# Ditemukan bahwa data harga tidak normal