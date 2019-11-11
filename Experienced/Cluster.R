rm(list = ls())
library(officer)
library(tidyverse)
setwd('D:/Project_R/Data Ardy/LMen/Hasil Gabungan All Parent with Scaling')
doc <- read_pptx('template.pptx')

#bikin powerpoint
doc <- add_slide(doc,layout = "Title Slide", master = "Office Theme")
doc <- ph_with(x=doc,"Clustering Analysis Menggunakan Data Selling Out LMen", location = ph_location_type(type = "ctrTitle"))
doc <- ph_with(x=doc,"Diskusi Temuan", location = ph_location_type(type = "subTitle"))

#general knowledge
dummy=c('Setelah melakukan pengelompokkan outlet RKA menggunakan data all product NFI. Dirasakan perlu untuk mengelompokkan outlet RKA menggunakan data selling out khusus untuk produk - produk LMen saja.','Untuk perhitungannya, produk LMen akan dikelompokkan berdasarkan pengelompokkan yang dilakukan oleh tim Brand.')
#halaman berikutnya
doc <- add_slide(doc,layout = "Title and Content", master = "Office Theme")
doc <- ph_with(x=doc,"Tujuan Analisa", location = ph_location_type(type = "title"))
doc <- ph_with(x=doc,value=dummy, location = ph_location_type(type = "body"))

#langkah kerja
dummy=c('Data collecting & cleaning','Data dikumpulkan oleh tim sales. Data yang digunakan adalah data total selling out RKA selama 2018 per item (tanpa item pruning)','Data Preparation','Item produk dikelompokkan terlebih dahulu. Kemudian dihitung total sales per kelompok produk per parent.','Data Analytics','Pengelompokkan dilakukan menggunakan metode K-Means Cluster')
ul <- unordered_list(
  level_list = c(1,2,1,2,1,2),
  str_list = dummy)

doc <- add_slide(doc,layout = "Title and Content", master = "Office Theme")
doc <- ph_with(x=doc,"Langkah Kerja", location = ph_location_type(type = "title"))
doc <- ph_with(x=doc,value=ul, location = ph_location_type(type = "body"))


setwd('D:/Project_R/Data Ardy')

#ambil data
library(readxl)

library(gridExtra)
dataset=read_excel('Data RKA Parent-Outlet-Item.xlsx')

#Benerin nama variabel
head(dataset)
judul=colnames(dataset)
judul=tolower(judul)
judul=gsub(' ','.',judul)
colnames(dataset)=judul

#powerpoint berikutnya
tabel.2=qplot(1:20, 1:20, geom = "blank") + theme_bw() + theme(line = element_blank(), text = element_blank()) + annotation_custom(grob = tableGrob(head(dataset,13)))
doc <- add_slide(doc,layout = "Title and Content", master = "Office Theme")
doc <- ph_with(x=doc,"Data yang digunakan", location = ph_location_type(type = "title"))
doc <- ph_with(x=doc,value=tabel.2, location = ph_location_type(type = "body"))


#Gabung dengan parent Lenny
data.parent=read_excel('Parent items.xlsx')

#Benerin nama variabel di data.parent
colnames(data.parent)=c('item.group','parent.lenny','parent.ikanx','parent.lmen')


#Catatan penting
dummy=c('Data tersebut tidak bisa langsung dianalisa karena:','Struktur datanya belum sesuai','Nilai total sales value antar parent tidak bisa langsung dibandingkan','Oleh karena itu harus dilakukan data preparation.')
ul <- unordered_list(
  level_list = c(1,2,2,1),
  str_list = dummy)

doc <- add_slide(doc,layout = "Title and Content", master = "Office Theme")
doc <- ph_with(x=doc,"Catatan", location = ph_location_type(type = "title"))
doc <- ph_with(x=doc,value=ul, location = ph_location_type(type = "body"))

#Pengelompokkan parent - informasi
dummy.tabel=data.parent[-2:-3]
dummy.tabel=dummy.tabel %>% filter(!is.na(parent.lmen)) %>% arrange(parent.lmen)
tabel.new.1=qplot(1:20, 1:20, geom = "blank") + theme_bw() + theme(line = element_blank(), text = element_blank()) + annotation_custom(grob = tableGrob(dummy.tabel))
doc <- add_slide(doc,layout = "Title and Content", master = "Office Theme")
doc <- ph_with(x=doc,"Pengelompokkan produk yang digunakan", location = ph_location_type(type = "title"))
doc <- ph_with(x=doc,value=tabel.new.1, location = ph_location_type(type = "body"))


#gabung
dataset=merge(dataset,data.parent)
dataset=dataset %>% filter(!is.na(parent.lmen))


#hitung per masing2 parent
#pakai parent lmen
#library(tidyverse)
new=dataset %>% group_by(customer.so.parent,parent.lmen) %>% summarize(sum.sales=sum(sales.value.netto)) %>% split(.,.$customer.so.parent)
n=length(new)
setwd('D:/Project_R/Data Ardy/LMen/per parent')
for (i in 1:n)
{
write.csv(new[i],paste('parent ke',i,'csv',sep='.'))
}


#kedua bikin scale 1-5
file_list <- list.files()
n=length(file_list)
for (i in 1:n)
{
setwd('D:/Project_R/Data Ardy/LMen/per parent')
temp=read.csv(file_list[i])
temp=temp[-1]
colnames(temp)=c('so.parent','item.parent','sum.sales')
temp$sales.cat=cut(temp$sum.sales,breaks=5,labels=c(1,2,3,4,5))
setwd('D:/Project_R/Data Ardy/LMen/hasil scaling')
write.csv(temp,paste('hasil scaling parent ke',i,'csv',sep='.'))
rm(temp)
}

#gabung hasil scaling semua parent
setwd('D:/Project_R/Data Ardy/LMen/hasil scaling')
file_list <- list.files()
n=length(file_list)
dataset <- read.csv(file_list[1], header=TRUE)
dataset=dataset[-1]
for (i in 2:n)
{
        temp_dataset <-read.csv(file_list[i], header=TRUE)
	temp_dataset = temp_dataset[-1]
        dataset<-rbind(dataset, temp_dataset)
        rm(temp_dataset)
}
setwd('D:/Project_R/Data Ardy/LMen/Hasil Gabungan All Parent with Scaling')
write.csv(dataset,'All Parent.csv')


#Cara scaling
dummy=c('Rentang scaling yang digunakan sama dengan rentang pada saat scaling RKA, yakni dari 1 - 5.','Kenapa tidak menggunakan rentang yang lebih rendah mengingat kategori LMen hanya ada 3?','Jika dibuat rentang scale 1 - 3, kita tidak akan bisa membedakan dua kategori LMen (daily performers dan serious gymmers) karena nilai salesnya akan masuk rentang yang sama.','Setelah dilakukan beberapa kali iterasi, rentang 1 - 5 memberikan hasil yang lebih baik.')
ul <- unordered_list(
  level_list = c(1,1,2,1),
  str_list = dummy)

doc <- add_slide(doc,layout = "Title and Content", master = "Office Theme")
doc <- ph_with(x=doc,"Cara scaling", location = ph_location_type(type = "title"))
doc <- ph_with(x=doc,value=ul, location = ph_location_type(type = "body"))


#powerpoint berikutnya - hasil scaling
tabel.new.1=qplot(1:20, 1:20, geom = "blank") + theme_bw() + theme(line = element_blank(), text = element_blank()) + annotation_custom(grob = tableGrob(head(dataset,10)))
doc <- add_slide(doc,layout = "Title and Content", master = "Office Theme")
doc <- ph_with(x=doc,"Hasil scaling data selling out LMen", location = ph_location_type(type = "title"))
doc <- ph_with(x=doc,value=tabel.new.1, location = ph_location_type(type = "body"))


#mulai clustering analysis
setwd('D:/Project_R/Data Ardy/LMen/Hasil Gabungan All Parent with Scaling')

dataset=read.csv('All Parent.csv')
library(factoextra)

#create contingency table
mytable=with(dataset, tapply(sales.cat, list(so.parent=so.parent,item.parent=item.parent), mean) )
table(is.na(mytable)) #cek ada yang NA atau gak
mytable[is.na(mytable)] <- 0 #replace NA dengan nilai nol
table(is.na(mytable)) #cek ada yang NA atau gak



#########################################################################
#########################################################################
#########################################################################
#########################################################################
#SAMPAI SINI DULU YAH
#########################################################################
#########################################################################
#########################################################################
#########################################################################

#Correspondence Analysis
library(ca)
fit <- ca(mytable)
print(fit)
plot(fit)
plot3d.ca(fit)


#Clustering analysis
#fungsi untuk mencari ada berapa cluster di data
library(cluster)
elbow=fviz_nbclust(mytable, kmeans, method = "wss") #elbow method
ggsave(elbow,file='elbow method.png',width=16,height=9, units='in',dpi=150)

siluet=fviz_nbclust(mytable, kmeans, method = "silhouette") #siluet method hasil: 2 dan 6
ggsave(siluet,file='sillhoutte method.png',width=16,height=9, units='in',dpi=150)


gap_stat <- clusGap(mytable, FUN = kmeans, nstart = 25,K.max = 10, B = 190)
gap=fviz_gap_stat(gap_stat) #gap stat method
ggsave(gap,file='gap stat method.png',width=16,height=9, units='in',dpi=150)


#Membuat ppt terkait dengan banyaknya cluster
doc <- add_slide(doc,layout = "Section Header", master = "Office Theme")
doc <- ph_with(x=doc,"Menggunakan 3 metode, yakni:", location = ph_location_type(type = "body"))
doc <- ph_with(x=doc,"Bagaimana menentukan banyaknya cluster?", location = ph_location_type(type = "title"))

doc <- add_slide(doc,layout = "Title and Content", master = "Office Theme")
doc <- ph_with(x=doc,"Elbow Method", location = ph_location_type(type = "title"))
doc <- ph_with(x = doc, value = elbow, location = ph_location_type(type = "body"))

doc <- add_slide(doc,layout = "Title and Content", master = "Office Theme")
doc <- ph_with(x=doc,"Sillhouette Method", location = ph_location_type(type = "title"))
doc <- ph_with(x = doc, value = siluet, location = ph_location_type(type = "body"))

doc <- add_slide(doc,layout = "Title and Content", master = "Office Theme")
doc <- ph_with(x=doc,"Gap-Stat Method", location = ph_location_type(type = "title"))
doc <- ph_with(x = doc, value = gap, location = ph_location_type(type = "body"))


#isi potensial cluster di mari
potensi.cluster=c(5,7,9)

doc <- add_slide(doc,layout = "Section Header", master = "Office Theme")
doc <- ph_with(x=doc,"Kemungkinan banyaknya cluster:", location = ph_location_type(type = "title"))
doc <- ph_with(x=doc,value=rbind(potensi.cluster), location = ph_location_type(type = "body"))

setwd('D:/Project_R/Data Ardy/LMen/Hasil Gabungan All Parent with Scaling/hasil akhir')


#running cluster dari potensi.cluster
for (i in potensi.cluster){
judul1=paste('Hasil.cluster',i,'csv',sep='.')
judul2=paste('Toko.cluster',i,'csv',sep='.')
judul3=paste('Toko.cluster',i,'png',sep='.')
judul4=paste('Proporsi Toko per Cluster jika banyaknya cluster k=',i,sep='')
judul5=paste('Proporsi Toko per Cluster',i,'png',sep='.')

#halaman pembuka masing2 section
doc <- add_slide(doc,layout = "Section Header", master = "Office Theme")
doc <- ph_with(x=doc,paste("Analisa Menggunakan k=",i,sep=''), location = ph_location_type(type = "title"))
doc <- ph_with(x=doc,"K-Means Clustering", location = ph_location_type(type = "body"))

final <- kmeans(mytable, i, nstart = 25)
#print(final)
graf=fviz_cluster(final, data = mytable)
ggsave(graf,file=judul3,width=16,height=9, units='in',dpi=150)

cluster.toko=data.frame(final$cluster)
cluster.toko$so.parent=attributes(cluster.toko)$row.names
x=round(prop.table(table(cluster.toko$final.cluster))*100,2)
x=data.frame(x)
colnames(x)=c('cluster','share')
x$cluster=paste('Cluster',x$cluster,sep=' ')

pie = ggplot(x, aes(x="", y=share, fill=cluster, label=paste(cluster,': ',share,'%',sep=''))) + geom_bar(stat="identity", width=1)+geom_text(size = 5.5, position = position_stack(vjust = 0.5))+scale_fill_brewer(palette = "Set1")+ coord_polar("y", start=0)
pie = pie + labs(title = judul4)
pie = pie + labs(x = NULL, y = NULL, fill = NULL)
pie = pie + theme_classic() + theme(axis.line = element_blank(),axis.text = element_blank(),axis.ticks = element_blank())
pie = pie + theme(legend.position = "none") 
ggsave(pie,file=judul5,width=9,height=9, units='in',dpi=150)


doc <- add_slide(doc,layout = "Two Content", master = "Office Theme")
doc <- ph_with(x=doc,value=judul4, location = ph_location_type(type = "title"))
doc <- ph_with(x = doc, value = pie, location = ph_location_left())
doc <- ph_with(x = doc, value = graf, location = ph_location_right())

tabel.1=qplot(1:10, 1:10, geom = "blank") + theme_bw() + theme(line = element_blank(), text = element_blank()) + annotation_custom(grob = tableGrob(round(final$centers,2)))
doc <- add_slide(doc,layout = "Title and Content", master = "Office Theme")
doc <- ph_with(x=doc,"Karakteristik masing-masing cluster", location = ph_location_type(type = "title"))
doc <- ph_with(x = doc, value = tabel.1, location = ph_location_type(type = "body"))

write.csv(final$centers,judul1)
write.csv(cluster.toko,judul2)
}

#lampiran
doc <- add_slide(doc,layout = "Section Header", master = "Office Theme")
doc <- ph_with(x=doc,"Lampiran", location = ph_location_type(type = "title"))
doc <- ph_with(x=doc,"Grafik sales value vs sales level -- All SO parent", location = ph_location_type(type = "body"))

#########################################################################
#########################################################################
#Bikin graphic yah
library(ggplot2)
library(ggrepel)
setwd('D:/Project_R/Data Ardy/LMen/Hasil Gabungan All Parent with Scaling')
dataset=read.csv('All Parent.csv')

brand=unique(dataset$item.parent)
n=length(brand)
setwd('D:/Project_R/Data Ardy/LMen/Chart Final')

for(i in 1:n){
temp=dataset %>% filter(item.parent==as.character(brand[i]))
judul=paste(brand[i])
judul_csv=paste('kuadran.terbaik',brand[i],'csv',sep='.')
new=temp %>% filter(sum.sales>=mean(sum.sales),sales.cat>=mean(sales.cat))
write.csv(new,judul_csv)

p=ggplot(temp, aes(x=sales.cat, y=sum.sales)) +  geom_point() + geom_text_repel(aes(label = temp$so.parent), size = 2) + scale_y_continuous(labels = scales::comma) + labs(title = judul)+geom_vline(xintercept = mean(temp$sales.cat)) + geom_hline(yintercept = mean(temp$sum.sales))
doc <- add_slide(doc,layout = "Title and Content", master = "Office Theme")
doc <- ph_with(x=doc,judul, location = ph_location_type(type = "title"))
doc <- ph_with(x = doc, value = p, location = ph_location_type(type = "body"))

rm(temp)
rm(p)
rm(new)
}

#lampiran
doc <- add_slide(doc,layout = "Section Header", master = "Office Theme")
doc <- ph_with(x=doc,"Lampiran", location = ph_location_type(type = "title"))
doc <- ph_with(x=doc,"Grafik sales value vs sales level -- All SO parent PER CLUSTER", location = ph_location_type(type = "body"))

#########################################################################
#########################################################################
#Bikin graphic yah
#tapi percluster
setwd('D:/Project_R/Data Ardy/LMen/Hasil Gabungan All Parent with Scaling/hasil akhir')
cluster=read.csv('Toko.cluster.5.csv')

dataset=dataset[-1]
dataset=merge(dataset,cluster)
dataset=dataset[-5]
colnames(dataset)=c('so.parent','item.parent','sum.sales','sales.cat','cluster.baru')


brand=unique(dataset$item.parent)
n=length(brand)
cluster=unique(dataset$cluster.baru)
m=length(cluster)

setwd('D:/Project_R/Data Ardy/LMen/Chart per cluster')

for(j in 1:m){
for(i in 1:n){
temp=dataset %>% filter(cluster.baru==j) %>% filter(item.parent==as.character(brand[i]))
judul=paste('Cluster ke',j,brand[i],sep=' ')

p=ggplot(temp, aes(x=sales.cat, y=sum.sales)) +  geom_point() + geom_text_repel(aes(label = temp$so.parent), size = 2) + scale_y_continuous(labels = scales::comma) +geom_vline(xintercept = mean(temp$sales.cat)) + geom_hline(yintercept = mean(temp$sum.sales))
doc <- add_slide(doc,layout = "Title and Content", master = "Office Theme")
doc <- ph_with(x=doc,judul, location = ph_location_type(type = "title"))
doc <- ph_with(x = doc, value = p, location = ph_location_type(type = "body"))

}
}

#Ending
doc <- add_slide(doc,layout = "Section Header", master = "Office Theme")
doc <- ph_with(x=doc,"Thanks", location = ph_location_type(type = "title"))
doc <- ph_with(x=doc,"This presentation is made by R", location = ph_location_type(type = "body"))

setwd('D:/Project_R/Data Ardy/LMen')
print(doc, target = "draft LMEN.pptx") 
