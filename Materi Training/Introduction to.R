#Selamat datang di R
#ada banyak object di R
#define variabel
a=7
b<-3
a+b
c=a+b
kalimat='saya suka pergi ke pasar' #jika variabelnya berupa text

#define array
ikang=c(1,3,6,5,4,7)
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

#mengenal paste dan print
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

####################################################################################
#create dummy data utk reshape2
a=sample(LETTERS,10,replace=T)
b=sample(LETTERS,10,replace=T)
c=sample(LETTERS,10,replace=T)
d=sample(LETTERS,10,replace=T)
e=sample(9,10,replace=T)
f=sample(9,10,replace=T)
nama.produk=paste(a,b,c,d,e,f,sep='')
#nama.produk=gsub(' ','',nama.produk) #digunakan untuk menghapus spasi 

urut=c(1:1000)
nama.dc=paste('toko_',urut,sep='')

x=matrix(sample(100,300,replace=T),300,1000)
data=data.frame(x)
for(i in 1:1000)
{
data[i]=sample(100,300,replace=T)
}

colnames(data)=nama.dc
data=data.frame(nama.produk,data)
write.csv(data,'Contoh Data SO.csv')
####################################################################################


#membuat tabular dari bentuk seperti ini
rm(list=ls()) #digunakan untuk membersihkan global data environment
data=read.csv('Contoh Data SO.csv')
library(reshape2)
tabular=melt(data,id.vars = 'nama.produk')
colnames(tabular)=c() #ganti nama variabel dalam data tabular


#memanggil library
library(plyr)

#memulangkan library
detach(plyr)

#Sampai sini ada pertanyaan?


###########################################################################################
#kita masuk ke bagian serunya yah...

rm(list=ls())
setwd('D:/Project_R/Belajar R/sharing session/Research Dive/Grup EComm/data mentah')

library(readxl)
data <- read_excel("Agustus.xlsx", skip = 3)
View(data)

#Coba cari tau, proporsi status transaksinya gimana?
table(data$`Order Status`)
prop.table(table(data$`Order Status`))
prop.table(table(data$`Order Status`))*100

#coba cek nomor telepon konsumen
#ternyata ada yang NA
table(is.na(data$`Customer Phone`))


###########################################################################################
#Menggabungkan data excel yang ada 

setwd('D:/Project_R/Belajar R/sharing session/Research Dive/Grup EComm/data mentah')
#sebelumnya coba cek dulu, apakah ada beda antara file tersebut

rm(list=ls())
file_list <- list.files()
n=length(file_list)

dataset <- read_excel(file_list[1], skip = 3)
head(data)

for (i in 2:n)
{
        temp_dataset = read_excel(file_list[i], skip = 3)
	dataset = rbind(dataset, temp_dataset)
        rm(temp_dataset)
}
dataset

###########################################################################################
#mari kita siapkan datanya
#pertama
str(dataset) #liat dulu jenis2 datanya apa

#ubah harga
table(is.na(dataset$`Price (Rp.)`)) #cek dulu, ada yg NA atau tidak
harga=dataset$`Price (Rp.)`
harga=gsub('Rp ','',harga)
harga=as.numeric(harga)
harga=harga*1000
dataset$`Price (Rp.)`= harga
rm(harga)

#cek Quantity
table(is.na(dataset$Quantity))
dataset$Quantity=as.numeric(dataset$Quantity)

#Cek Date
dataset$Date=as.numeric(dataset$Date)

#mari kita bereskan yg NA di nomor teleponnya.
table(is.na(dataset$`Customer Phone`))
telp=dataset$`Customer Phone`
n=length(telp)

#induksi dulu yah biar dapet feelnya
head(telp)
telp[1]
telp[2]

telp[2]=ifelse(is.na(telp[2]),telp[1],telp[2])

#dibuat loop-nya
for(i in 1:n-1)
{
    telp[i+1]=ifelse(is.na(telp[i+1]),telp[i],telp[i+1])
}

#kembalikan ke dataset
dataset$`Customer Phone`=telp
rm(telp)

#cek kembali deh
table(is.na(dataset$`Customer Phone`))

###########################################################################################
#Ganti nama kolom yuk
#kepanjangan kayaknya
colnames(dataset)=c('tgl','bln','status','id.produk','nama.produk','qty','sku','harga','telp')

data=dataset

#mengenal filter
#filter --> selecting in variabel
data %>% filter(bln=='Sep')

#mengenal select variabel / select kolom
data %>% select(contains('produk'))


#mengetahui grepl
grepl('selesai',data$status)
table(grepl('selesai',data$status))

#sekarang kita cek dulu order status
table((data$status))
#ternyata ada yg komplain. Mana aja yg komplain?
filter(data,grepl('komplain',status))

#hitung total qty jualan produk
qty.produk=data %>% group_by(nama.produk) %>% summarize(total.qty=sum(qty))

#ordering dari yang tertinggi
top.produk=qty.produk[order(-top.produk$total.qty),]

#gimana dapet top 20 produk?
top.produk=head(top.produk,20)
