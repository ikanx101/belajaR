# Materi Training Replikasi @nutrifood - GIZ

Folder ini berisi skrip dan latihan untuk training replikasi dari GIZ. Khusus utk peserta replikasi GIZ yah.

Materi yang akan disampaikan:
1. Intro to R
2. Korelasi
3. Regresi (_extracting insight_)
4. Optimasi (_take action from insight_)

Tgkyu __@lenny.wibisana__ utk tambahan materi dan data untuk latihan regresinya.

###### __i k A n x__

# Selamat datang di R
## Materi 1: Intro to R (express version)
## Materi 2: Korelasi
```
#define variabel
a=7
b<-3
a+b
c=a+b
kalimat='saya suka pergi ke pasar' #jika variabelnya berupa text

#define array atau vector
tes_vector=c(1,3,6,5,4,7)
a=c(1:10) #contoh generating sequence
a=seq(1,10,0.5) #contoh generating sequence by 0.5
sample(100,5,replace=F) #generating random number
kalimat = 'saya biasa pergi ke kantor setiap jam 7 pagi'
pecah.kata=strsplit(kalimat,' ') #pecah kalimat menjadi kata dan mengubahnya menjadi array

#Yang penting di array
length(a)
a[2]
summary(a)

#operasi aritmatika pada array
a+3
a*6

#boolean expression
1==2
ifelse(1+2==3,'anda benar','anda salah')
ifelse(1+2!=3,'anda benar','anda salah')
ifelse(1+2<=3,'anda benar','anda salah')
ifelse(1+2>=3,'anda benar','anda salah')
ifelse(1+2<3,'anda benar','anda salah')
ifelse(1+2>3,'anda benar','anda salah')

#mengenal paste
nomor=c(1:100)
nama.toko=paste('toko',nomor,sep='-')

#mengenal print
nomor=c(1:100)
print(nomor)

#bridging utk ke data frame
suhu=sample(100,50,replace=T)
cacat=sample(10,50,replace=T)
hist(suhu)

cor(suhu,cacat) #korelasi antara suhu dan cacat
plot(suhu,cacat)

#membuat data frame
data=data.frame(suhu,cacat)

#yang penting di data frame
str(data)
summary(data)
length(data)
head(data,5) #menampilkan data 5 teratas
tail(data,5) #menampilkan data 5 terbawah
View(data)
data[1]
data[,1]
data[2]
data[,2]

data[1,1] #melihat data di posisi row,column
data[1,2] #melihat data di posisi row,column
data[1,1]=NA #menghapus data di posisi row,column

data$suhu
data$cacat
data.baru=data[-1]

is.na(data) #melihat ada yang kosong
!is.na(data) #melihat pasti terisi

data.baru <- data[complete.cases(data), ] #jika mau menghapus baris2 yang ada NA nya! 

data$suhu=ifelse(data$suhu<50,NA,data$suhu) #menghapus data suhu yang aneh (di bawah 50'C)
cor.test(data.baru$suhu,data.baru$cacat)
cor(data.baru$suhu,data.baru$cacat) #hitung korelasi data

#sorting data
sorted.data=data.baru[order(data.baru$suhu),] #descending
sorted.data=data.baru[order(-data.baru$suhu),] #ascending

rm(list=ls()) #digunakan untuk membersihkan global data environment

#set working directory
setwd('D:/nama folder')
```

## Materi 3: Regresi Linear
```
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
  stat_regline_equation(label.y = 7,
  aes(label =  paste(..eq.label.., ..rr.label.., sep = "~~~~"))) +
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
```

## Materi 4: Optimasi
Pertanyaan dari model tersebut adalah, mungkinkan kita menghitung harga yang menyebabkan omset paling tinggi?
```
model_reg
data_new = data.frame(harga=seq(10,20,0.1),qty=1)
str(data_new)

data_new$qty.new = predict(model_reg,newdata = data_new)
data_new %>% 
  mutate(omset = harga * qty.new) %>%
  filter(omset == max(omset))
```
