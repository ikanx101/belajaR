#Selamat datang di R

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
cor(data.baru$suhu,data.baru$cacat) #hitung korelasi baru

#sorting data
sorted.data=data.baru[order(data.baru$suhu),] #descending
sorted.data=data.baru[order(-data.baru$suhu),] #ascending

rm(list=ls()) #digunakan untuk membersihkan global data environment

#set working directory
setwd('D:/Project_R/Belajar R/sharing session')
