# Selamat datang di R
## Perkenalan tentang tipe data
### Data ada banyak tipenya, contoh: bisa berupa character, numerik, logic (boolean).

## Ada banyak object di R
### ada yang berupa single variable
a=7
b<-3
a+b
c=a+b
kalimat='saya suka pergi ke pasar' #jika variabelnya berupa text

### Ada berupa array atau vector
ikang=c(1,3,6,5,4,7)
a=c(1:10) #contoh generating sequence
a=seq(1,10,0.5) #contoh generating sequence by 0.5
sample(100,5,replace=F) #generating random number
kalimat = 'saya pergi ke rawabali lalu ke cibitung'
pecah.kata=strsplit(kalimat,' ') #pecah kalimat menjadi kata dan mengubahnya menjadi array

#### Beberapa fungsi penting di array
length(a)
a[2]
summary(a)
#### Operasi aritmatika pada array
a+3
a*6

### Logical operator atau boolean expression
1==2
ifelse(1+2==3,'anda benar','anda salah')
ifelse(1+2!=3,'anda benar','anda salah')
ifelse(1+2<=3,'anda benar','anda salah')
ifelse(1+2>=3,'anda benar','anda salah')
ifelse(1+2<3,'anda benar','anda salah')
ifelse(1+2>3,'anda benar','anda salah')

### Bentuk object lain di R bisa berupa matriks, data.frame, tibble, dan list.
### pembahasan mengenai objects lain ini akan dibahas pada materi selanjutnya.

## Some useful function
### Generate sequential number
nomor=c(1:100)
nomor_2=seq(1,100,0.5)

### Mengenal paste
nama.toko=paste('toko',nomor,sep='-')

### Mengenal print
nomor=c(1:100)
print(nomor)

### Generate random number 
suhu=sample(100,50,replace=T)
cacat=sample(10,50,replace=T)

### Membuat histogram
hist(suhu)

### Another useful functions
str(suhu)
summary(suhu)
length(suhu)
head(suhu,5) #menampilkan data 5 teratas
tail(suhu,5) #menampilkan data 5 terbawah
View(suhu)
suhu[1]

is.na(suhu) #melihat ada yang kosong
!is.na(suhu) #melihat pasti terisi

rm(list=ls()) #digunakan untuk membersihkan global data environment

### Set working directory
setwd('D:/Project_R/Belajar R/sharing session')

### Memanggil library
library(plyr)

### Memulangkan library
detach(plyr)

# Sampai sini ada pertanyaan?

#################
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
