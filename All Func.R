print('===============================================================================================================')
print('Syarat dan ketentuan berlaku')
print('Pastikan library berikut ini sudah terinstall yah:')
print('readxl, dplyr, officer, gridExtra, ggplot2, expss, foreign')
print('Khusus untuk membuat powerpoint menggunakan officer, pastikan bahwa template powerpoint diberikan nama doc yah')
print('Khusus untuk melakukan tabulasi data, pastikan bahwa data diberikan nama data yah')
print('===============================================================================================================')

#load library yg dbutuhkan
library(readxl)
library(dplyr)
library(officer)
library(gridExtra)
library(ggplot2)
library(foreign)
library(expss)
library (RDCOMClient)

#membersihkan nama variabel dalam data frame
tolong.bersihin.judul.donk = function(data){
judul=colnames(data)
judul=tolower(judul)
judul=gsub(' ','.',judul)
judul=gsub('_','.',judul)
judul=gsub('-','.',judul)
judul=gsub('\\|','.',judul)
judul=gsub('\\/','.',judul)
judul=gsub('\r','.',judul)
judul=gsub('\n','.',judul)
judul=gsub('\t','.',judul)
judul=gsub('\\(','',judul)
judul=gsub('\\)','',judul)
judul=gsub('\\:','',judul)
judul=gsub('..','.',judul,fixed=T)
judul=gsub('..','.',judul,fixed=T)
judul=gsub('..','.',judul,fixed=T)
return(judul)
}

#Gabung data dalam satu folder csv
gabungin.data.csv.saya.donk = function(path){
  setwd(path)
  i=1
  file=list.files(pattern = '[.]csv$')
  data=read.csv(file[i])
  for(j in 2:length(file)){
    temp = read.csv(file[j])
    data[setdiff(names(temp), names(data))] <- NA
    temp[setdiff(names(data), names(temp))] <- NA
    data=rbind(data,temp)}
  write.csv(data,'Hasil Gabung Metode Ikanx.csv')
}
path=('D:/Project_R/Belajar R/Rocky Nutrimart/Extento')

#Gabung data dalam satu folder excel
gabungin.data.xls.saya.donk = function(path,skip){
  setwd(path)
  i=1
  file=list.files(pattern = c('[.]xls$'))
  data=read_excel(file[i],skip=skip)
  for(j in 2:length(file)){
    temp = read_excel(file[j],skip=skip)
    data[setdiff(names(temp), names(data))] <- NA
    temp[setdiff(names(data), names(temp))] <- NA
    data=rbind(data,temp)}
  write.csv(data,'Hasil Gabung Metode Ikanx.csv')
}

#Gabung data dalam satu folder excel
gabungin.data.xlsx.saya.donk = function(path,skip){
  setwd(path)
  i=1
  file=list.files(pattern = c('[.]xlsx$'))
  data=read_excel(file[i],skip=skip)
  for(j in 2:length(file)){
    temp = read_excel(file[j],skip=skip)
    data[setdiff(names(temp), names(data))] <- NA
    temp[setdiff(names(data), names(temp))] <- NA
    data=rbind(data,temp)}
  write.csv(data,'Hasil Gabung Metode Ikanx.csv')
}

#ubahin faktor variable ke character dr suatu data frame
ubahin.data.dari.faktor.ke.karakter.donk=function(data){
  data = data %>% mutate_if(is.factor,as.character)
  return(data)}

#tambahin slide judul utama
tambahin.slide.judul.donk=function(main.title,sub.title){
  doc=add_slide(x=doc,layout = 'Title Slide',master = 'Office Theme')
  doc=ph_with(x=doc,main.title,location=ph_location_type(type='ctrTitle')) #Title pertama
  doc=ph_with(x=doc,sub.title,location=ph_location_type(type='subTitle')) #Title kedua
}

#tambahin slide sub judul pemisah
tambahin.slide.pemisah.donk=function(main.title,sub.title){
  doc=add_slide(x=doc,layout = 'Section Header',master = 'Office Theme')
  doc=ph_with(x=doc,main.title,location=ph_location_type(type='title')) #Title slide
  doc=ph_with(x=doc,sub.title,location=ph_location_type(type='body')) #Title slide
}

#bikin list utk powerpoint
bikinin.list.untuk.content.slide.donk=function(isi.content,urutan){
  ul <- unordered_list(
    level_list = urutan,
    str_list = isi.content,
    style = fp_text(font.family = 'Century Gothic',font.size = 0) )
  return(ul)
}

#tambahin slide title dan content
tambahin.slide.isi.donk=function(slide.title,isi){
  doc <- add_slide(doc,layout = "Title and Content", master = "Office Theme")
  doc <- ph_with(x=doc,slide.title, location = ph_location_type(type = "title"))
  doc <- ph_with(x=doc,isi, location = ph_location_type(type = "body"))
}

#tambahin slide Ending
tambahin.slide.ending.donk=function(){
  doc <- add_slide(doc,layout = "Title Only", master = "Office Theme")
  doc <- ph_with(x=doc,"This is AI Generated Presentation\nUsing R\ni k A n g\n\nThank You", location = ph_location_type(type = "title"))
}

#tambahin slide title dan two content
tambahin.slide.isi.kanan.vs.kiri.donk=function(slide.title,isi1,isi2){
  doc=add_slide(x=doc,layout = 'Two Content',master = 'Office Theme')
  doc=ph_with(x=doc,slide.title,location=ph_location_type(type='title')) #Title slide
  doc=ph_with(x=doc,isi1,location=ph_location_label(ph_label='Content Placeholder 2'))
  doc <- ph_with(x = doc,isi2,location=ph_location_label(ph_label='Content Placeholder 3'))
  }

#import file spss dengan mudah
import.data.spss.saya.donk=function(nama.file){
  read.spss(nama.file,to.data.frame=TRUE)
}

#melihat isi pertanyaan (variable label dari spss)
liat.variable.labels.donk=function(data){
  View(attributes(data)$variable.labels) #melihat pertanyaannya
  }

#bikin pie chart
bikinin.pie.chart.dari.data.saya.donk=function(data,variabel,pertanyaan,sub.judul){
  tabulasi=data %>% tab_cells(variabel) %>% tab_stat_cpct() %>% tab_pivot()
  tabulasi$dummy=strsplit(tabulasi$row_labels,'\\|')
  for(i in 1:length(tabulasi$dummy))
  {tabulasi$row_labels[i]=unlist(tabulasi$dummy[i])[2]}
  tabulasi=data.frame(tabulasi)
  tabulasi=tabulasi[-3]
  colnames(tabulasi)=c('ket','percent')
  tabulasi$percent=round(tabulasi$percent,2)
  n = as.numeric(tabulasi %>% filter(grepl('total',ket,ignore.case=T)) %>% summarize(n=sum(percent))) #ambil base buat kepentingan chart
  tabulasi = tabulasi %>% filter(!grepl('total',ket,ignore.case=T)) #tabulasi final untuk chart
  tabulasi = tabulasi %>% filter(!is.na(ket))
  ggplot(tabulasi,aes(x='',y=percent,fill=ket,label=paste(ket,', ',percent,'%',sep=''))) + geom_bar(stat='identity') + coord_polar("y", start=0) +scale_fill_brewer(palette="Pastel2") + theme_minimal() + theme(axis.title.y=element_blank(),axis.title.x=element_blank(),legend.position = 'none',plot.title=element_text(size=14),plot.caption=element_text(size=10))+geom_text(position = position_stack(vjust = 0.5),size=4) +labs(caption = paste('n = ',ifelse(n>=30,n,paste(n,', indikasi',sep='')),sep='')) + labs(title=pertanyaan) + labs(subtitle = sub.judul) #ini grafiknya yah. Pertanyaan masukin dari subtitle
}

#bikin pie chart facet
bikinin.pie.chart.facet.dari.data.saya.donk=function(data,variabel,facet,pertanyaan,sub.judul,caption){
  tabulasi=data %>% tab_cells(variabel) %>% tab_rows(facet) %>% tab_stat_cpct() %>% tab_pivot()
  tabulasi$dummy=strsplit(tabulasi$row_labels,'\\|')
  for(i in 1:length(tabulasi$dummy))
  {tabulasi$row_labels[i]=unlist(tabulasi$dummy[i])[4]
   tabulasi$facet[i]=unlist(tabulasi$dummy[i])[2]
  }
  tabulasi=data.frame(tabulasi)
  tabulasi=tabulasi[-3]
  colnames(tabulasi)=c('ket','percent','facet')
  tabulasi$percent=round(tabulasi$percent,2)
  new=tabulasi %>% filter(grepl('total',ket,ignore.case=T)) %>% mutate(facet.new=paste(facet,', n=',percent,ifelse(percent<30,' - indikasi',''),sep=''))
  new$ket=NULL
  new$percent=NULL #baru sampe sini yah
  tabulasi = tabulasi %>% filter(!grepl('total',ket,ignore.case=T)) #tabulasi final untuk chart
  tabulasi = tabulasi %>% filter(!is.na(ket))
  tabulasi=merge(tabulasi,new)
  ggplot(tabulasi,aes(x='',y=percent,fill=ket,label=paste(ket,', ',percent,'%',sep=''))) + geom_bar(stat='identity') + coord_polar("y", start=0) +scale_fill_brewer(palette="Pastel2") + theme_minimal() + theme(axis.title.y=element_blank(),axis.title.x=element_blank(),legend.position = 'none',plot.title=element_text(size=16),plot.subtitle = element_text(size=13))+geom_text(position = position_stack(vjust = 0.5),size=4) + labs(title=pertanyaan) + facet_wrap(~facet.new) + theme(strip.background = element_rect(colour="black", fill="white",size=1.5, linetype="solid")) + labs(subtitle = sub.judul,caption=caption) #ini grafiknya yah. Pertanyaan masukin dari subtitle
}

#bikin bar chart standar - dari tabulasi (sort)
bikinin.bar.chart.sort.dari.data.tabulasi.saya.donk=function(tabulasi,pertanyaan,sub.judul){
  colnames(tabulasi)=c('ket','percent')
  tabulasi$percent=round(tabulasi$percent,2)
  n = as.numeric(tabulasi %>% filter(grepl('total',ket,ignore.case=T)) %>% summarize(n=sum(percent))) #ambil base buat kepentingan chart
  tabulasi = tabulasi %>% filter(!grepl('total',ket,ignore.case=T)) #tabulasi final untuk chart
  tabulasi = tabulasi %>% filter(!is.na(ket))
  tabulasi = tabulasi %>% filter(!is.na(percent))
  ggplot(tabulasi,aes(reorder(ket,-percent),percent,label=paste(percent,'%',sep='')))+geom_bar(fill='steelblue',stat='identity')+scale_fill_brewer(palette="Pastel2") + theme_minimal() + theme(panel.grid=element_blank(),axis.title.y=element_blank(),axis.title.x=element_blank(),legend.position = 'none',plot.title=element_text(size=16),plot.subtitle=element_text(size=13),plot.caption=element_text(size=10),axis.text.y = element_blank())+geom_text(position = position_stack(vjust = 1.03),size=3.5) +labs(caption = paste('n = ',ifelse(n>=30,n,paste(n,', indikasi',sep='')),sep='')) + labs(title=pertanyaan,subtitle = sub.judul)
}

#bikin bar chart standar - dari tabulasi (not sort)
bikinin.bar.chart.not.sort.dari.data.tabulasi.saya.donk=function(tabulasi,pertanyaan,sub.judul){
  colnames(tabulasi)=c('ket','percent')
  tabulasi$percent=round(tabulasi$percent,2)
  n = as.numeric(tabulasi %>% filter(grepl('total',ket,ignore.case=T)) %>% summarize(n=sum(percent))) #ambil base buat kepentingan chart
  tabulasi = tabulasi %>% filter(!grepl('total',ket,ignore.case=T)) #tabulasi final untuk chart
  tabulasi = tabulasi %>% filter(!is.na(ket))
  tabulasi = tabulasi %>% filter(!is.na(percent))
  tabulasi$ket=factor(tabulasi$ket,levels = (tabulasi$ket))
  ggplot(tabulasi,aes(ket,percent,label=paste(percent,'%',sep='')))+geom_bar(fill='steelblue',stat='identity')+scale_fill_brewer(palette="Pastel2") + theme_minimal() + theme(panel.grid=element_blank(),axis.title.y=element_blank(),axis.title.x=element_blank(),legend.position = 'none',plot.title=element_text(size=16),plot.subtitle=element_text(size=13),plot.caption=element_text(size=10),axis.text.y = element_blank())+geom_text(position = position_stack(vjust = 1.03),size=3.5) +labs(caption = paste('n = ',ifelse(n>=30,n,paste(n,', indikasi',sep='')),sep='')) + labs(title=pertanyaan,subtitle = sub.judul)
}

#bikin bar chart standar (sort)
bikinin.bar.chart.sort.dari.data.saya.donk=function(data,variabel,pertanyaan,sub.judul){
  tabulasi=data %>% tab_cells(variabel) %>% tab_stat_cpct() %>% tab_pivot()
  tabulasi$dummy=strsplit(tabulasi$row_labels,'\\|')
  for(i in 1:length(tabulasi$dummy))
  {tabulasi$row_labels[i]=unlist(tabulasi$dummy[i])[2]}
  tabulasi=data.frame(tabulasi)
  tabulasi=tabulasi[-3]
  colnames(tabulasi)=c('ket','percent')
  tabulasi$percent=round(tabulasi$percent,2)
  n = as.numeric(tabulasi %>% filter(grepl('total',ket,ignore.case=T)) %>% summarize(n=sum(percent))) #ambil base buat kepentingan chart
  tabulasi = tabulasi %>% filter(!grepl('total',ket,ignore.case=T)) #tabulasi final untuk chart
  tabulasi = tabulasi %>% filter(!is.na(ket))
  tabulasi = tabulasi %>% filter(!is.na(percent))
  ggplot(tabulasi,aes(reorder(ket,-percent),percent,label=paste(percent,'%',sep='')))+geom_bar(fill='steelblue',stat='identity')+scale_fill_brewer(palette="Pastel2") + theme_minimal() + theme(panel.grid=element_blank(),axis.title.y=element_blank(),axis.title.x=element_blank(),legend.position = 'none',plot.title=element_text(size=16),plot.subtitle=element_text(size=13),plot.caption=element_text(size=10),axis.text.y = element_blank())+geom_text(position = position_stack(vjust = 1.03),size=3.5) +labs(caption = paste('n = ',ifelse(n>=30,n,paste(n,', indikasi',sep='')),sep='')) + labs(title=pertanyaan,subtitle = sub.judul)
}

#bikin bar chart standar (not sort)
bikinin.bar.chart.not.sort.dari.data.saya.donk=function(data,variabel,pertanyaan,sub.judul){
  tabulasi=data %>% tab_cells(variabel) %>% tab_stat_cpct() %>% tab_pivot()
  tabulasi$dummy=strsplit(tabulasi$row_labels,'\\|')
  for(i in 1:length(tabulasi$dummy))
  {tabulasi$row_labels[i]=unlist(tabulasi$dummy[i])[2]}
  tabulasi=data.frame(tabulasi)
  tabulasi=tabulasi[-3]
  colnames(tabulasi)=c('ket','percent')
  tabulasi$percent=round(tabulasi$percent,2)
  n = as.numeric(tabulasi %>% filter(grepl('total',ket,ignore.case=T)) %>% summarize(n=sum(percent))) #ambil base buat kepentingan chart
  tabulasi = tabulasi %>% filter(!grepl('total',ket,ignore.case=T)) #tabulasi final untuk chart
  tabulasi = tabulasi %>% filter(!is.na(ket))
  tabulasi = tabulasi %>% filter(!is.na(percent))
  tabulasi$ket=factor(tabulasi$ket,levels = (tabulasi$ket))
  ggplot(tabulasi,aes(ket,percent,label=paste(percent,'%',sep='')))+geom_bar(fill='steelblue',stat='identity')+scale_fill_brewer(palette="Pastel2") + theme_minimal() + theme(panel.grid=element_blank(),axis.title.y=element_blank(),axis.title.x=element_blank(),legend.position = 'none',plot.title = element_text(size=14),plot.caption=element_text(size=10),axis.text.y = element_blank())+geom_text(position = position_stack(vjust = 1.02),size=3.5) +labs(caption = paste('n = ',ifelse(n>=30,n,paste(n,', indikasi',sep='')),sep='')) + labs(title=pertanyaan,subtitle = sub.judul)
}

#bikin bar chart standar facet (not sort)
bikinin.bar.chart.facet.not.sort.dari.data.saya.donk=function(data,variabel,facet,pertanyaan,sub.judul,caption){
  tabulasi=data %>% tab_cells(variabel) %>% tab_rows(facet) %>% tab_stat_cpct() %>% tab_pivot()
  tabulasi$dummy=strsplit(tabulasi$row_labels,'\\|')
  for(i in 1:length(tabulasi$dummy))
  {tabulasi$row_labels[i]=unlist(tabulasi$dummy[i])[4]
  tabulasi$facet[i]=unlist(tabulasi$dummy[i])[2]
  }
  tabulasi=data.frame(tabulasi)
  tabulasi=tabulasi[-3]
  colnames(tabulasi)=c('ket','percent','facet')
  tabulasi$percent=round(tabulasi$percent,2)
  new=tabulasi %>% filter(grepl('total',ket,ignore.case=T)) %>% mutate(facet.new=paste(facet,', n=',percent,ifelse(percent<30,' - indikasi',''),sep=''))
  new$ket=NULL
  new$percent=NULL #baru sampe sini yah
  tabulasi = tabulasi %>% filter(!grepl('total',ket,ignore.case=T)) #tabulasi final untuk chart
  tabulasi = tabulasi %>% filter(!is.na(ket))
  tabulasi=merge(tabulasi,new)
  ggplot(tabulasi,aes(ket,percent,label=paste(percent,'%',sep='')))+geom_bar(fill='steelblue',stat='identity')+scale_fill_brewer(palette="Pastel2") + theme_minimal() + theme(panel.grid=element_blank(),axis.title.y=element_blank(),axis.title.x=element_blank(),legend.position = 'none',plot.subtitle=element_text(size=13),plot.caption=element_text(size=10),axis.text.y = element_blank(),axis.text.x = element_text(angle = 90),plot.title = element_text(size = 16))+geom_text(position = position_stack(vjust = 1.03),size=3.5) + labs(title=pertanyaan,subtitle = sub.judul,caption=caption)+ facet_wrap(~facet.new) + theme(strip.background = element_rect(colour="black", fill="white",size=1.5, linetype="solid"))
}

#bikin bar chart standar facet (sort)
bikinin.bar.chart.facet.sort.dari.data.saya.donk=function(data,variabel,facet,pertanyaan,sub.judul,caption){
  tabulasi=data %>% tab_cells(variabel) %>% tab_rows(facet) %>% tab_stat_cpct() %>% tab_pivot()
  tabulasi$dummy=strsplit(tabulasi$row_labels,'\\|')
  for(i in 1:length(tabulasi$dummy))
  {tabulasi$row_labels[i]=unlist(tabulasi$dummy[i])[4]
  tabulasi$facet[i]=unlist(tabulasi$dummy[i])[2]
  }
  tabulasi=data.frame(tabulasi)
  tabulasi=tabulasi[-3]
  colnames(tabulasi)=c('ket','percent','facet')
  tabulasi$percent=round(tabulasi$percent,2)
  new=tabulasi %>% filter(grepl('total',ket,ignore.case=T)) %>% mutate(facet.new=paste(facet,', n=',percent,ifelse(percent<30,' - indikasi',''),sep=''))
  new$ket=NULL
  new$percent=NULL #baru sampe sini yah
  tabulasi = tabulasi %>% filter(!grepl('total',ket,ignore.case=T)) #tabulasi final untuk chart
  tabulasi = tabulasi %>% filter(!is.na(ket))
  tabulasi=merge(tabulasi,new)
  ggplot(tabulasi,aes(reorder(ket,-percent),percent,label=paste(percent,'%',sep='')))+geom_bar(fill='steelblue',stat='identity')+scale_fill_brewer(palette="Pastel2") + theme_minimal() + theme(panel.grid=element_blank(),axis.title.y=element_blank(),axis.title.x=element_blank(),legend.position = 'none',plot.subtitle=element_text(size=13),plot.caption=element_text(size=10),axis.text.y = element_blank(),axis.text.x = element_text(angle = 90),plot.title = element_text(size = 16))+geom_text(position = position_stack(vjust = 1.03),size=3.5) + labs(title=pertanyaan,subtitle = sub.judul,caption=caption)+ facet_wrap(~facet.new) + theme(strip.background = element_rect(colour="black", fill="white",size=1.5, linetype="solid"))
}

#bikin bar chart standar facet dari tabulasi (sort)
bikinin.bar.chart.facet.sort.dari.tabulasi.saya.donk=function(tabulasi,pertanyaan,sub.judul,caption){
  tabulasi$dummy=strsplit(tabulasi$row_labels,'\\|')
  for(i in 1:length(tabulasi$dummy))
  {tabulasi$row_labels[i]=unlist(tabulasi$dummy[i])[3]
  tabulasi$facet[i]=unlist(tabulasi$dummy[i])[2]
  }
  tabulasi=data.frame(tabulasi)
  tabulasi=tabulasi[-3]
  colnames(tabulasi)=c('ket','percent','facet')
  tabulasi$percent=round(tabulasi$percent,2)
  new=tabulasi %>% filter(grepl('total',ket,ignore.case=T)) %>% mutate(facet.new=paste(facet,', n=',percent,ifelse(percent<30,' - indikasi',''),sep=''))
  new$ket=NULL
  new$percent=NULL #baru sampe sini yah
  tabulasi = tabulasi %>% filter(!grepl('total',ket,ignore.case=T)) #tabulasi final untuk chart
  tabulasi = tabulasi %>% filter(!is.na(ket))
  tabulasi=merge(tabulasi,new)
  ggplot(tabulasi,aes(reorder(ket,-percent),percent,label=paste(percent,'%',sep='')))+geom_bar(fill='steelblue',stat='identity')+scale_fill_brewer(palette="Pastel2") + theme_minimal() + theme(panel.grid=element_blank(),axis.title.y=element_blank(),axis.title.x=element_blank(),legend.position = 'none',plot.subtitle=element_text(size=13),plot.caption=element_text(size=10),axis.text.y = element_blank(),axis.text.x = element_text(angle = 90),plot.title = element_text(size = 16))+geom_text(position = position_stack(vjust = 1.08),size=2.25) + labs(title=pertanyaan,subtitle = sub.judul,caption=caption)+ facet_wrap(~facet.new) + theme(strip.background = element_rect(colour="black", fill="white",size=1.5, linetype="solid"))
}

#bikin bar chart standar facet dari tabulasi (not sort)
bikinin.bar.chart.facet.not.sort.dari.tabulasi.saya.donk=function(tabulasi,pertanyaan,sub.judul,caption){
  tabulasi$dummy=strsplit(tabulasi$row_labels,'\\|')
  for(i in 1:length(tabulasi$dummy))
  {tabulasi$row_labels[i]=unlist(tabulasi$dummy[i])[3]
  tabulasi$facet[i]=unlist(tabulasi$dummy[i])[2]
  }
  tabulasi=data.frame(tabulasi)
  tabulasi=tabulasi[-3]
  colnames(tabulasi)=c('ket','percent','facet')
  tabulasi$percent=round(tabulasi$percent,2)
  new=tabulasi %>% filter(grepl('total',ket,ignore.case=T)) %>% mutate(facet.new=paste(facet,', n=',percent,ifelse(percent<30,' - indikasi',''),sep=''))
  new$ket=NULL
  new$percent=NULL #baru sampe sini yah
  tabulasi = tabulasi %>% filter(!grepl('total',ket,ignore.case=T)) #tabulasi final untuk chart
  tabulasi = tabulasi %>% filter(!is.na(ket))
  tabulasi=merge(tabulasi,new)
  tabulasi=tabulasi %>% mutate(ket=factor(ket,levels = unique(ket)))
  ggplot(tabulasi,aes(ket,percent,label=paste(percent,'%',sep='')))+geom_bar(fill='steelblue',stat='identity')+scale_fill_brewer(palette="Pastel2") + theme_minimal() + theme(panel.grid=element_blank(),axis.title.y=element_blank(),axis.title.x=element_blank(),legend.position = 'none',plot.subtitle=element_text(size=13),plot.caption=element_text(size=10),axis.text.y = element_blank(),axis.text.x = element_text(angle = 90),plot.title = element_text(size = 16))+geom_text(position = position_stack(vjust = 1.08),size=2.25) + labs(title=pertanyaan,subtitle = sub.judul,caption=caption)+ facet_wrap(~facet.new) + theme(strip.background = element_rect(colour="black", fill="white",size=1.5, linetype="solid"))
}

#bikin bar chart khusus skala 6
bikinin.bar.chart.untuk.likert.6.skala.dari.data.saya.donk=function(data,variabel,pertanyaan){
  tabulasi=data %>% tab_cells(variabel) %>% tab_stat_cpct() %>% tab_pivot()
  tabulasi$dummy=strsplit(tabulasi$row_labels,'\\|')
  for(i in 1:length(tabulasi$dummy))
  {tabulasi$row_labels[i]=unlist(tabulasi$dummy[i])[2]}
  tabulasi=data.frame(tabulasi)
  tabulasi[is.na(tabulasi)]=0
  tabulasi=tabulasi[-3]
  colnames(tabulasi)=c('ket','percent')
  tabulasi$percent=round(tabulasi$percent,2)
  n = as.numeric(tabulasi %>% filter(grepl('total',ket,ignore.case=T)) %>% summarize(n=mean(percent))) #ambil base buat kepentingan chart
  tabulasi = tabulasi %>% filter(!grepl('total',ket,ignore.case=T)) #tabulasi final untuk chart
  tabulasi$ket=factor(tabulasi$ket,levels = (tabulasi$ket)) #untuk mengurutkan grafiknya
  T2B=paste('Top 2 Boxes = ',tabulasi$percent[5]+tabulasi$percent[6],'%',sep='')
  tabulasi$kat=c('B2B','B2B','Neutral','Neutral','T2B','T2B')
  tabulasi$angka=c(1:6)
  tabulasi$angka=tabulasi$angka*(tabulasi$percent/100*n)
  mean.score=paste('Mean score=',round(sum(tabulasi$angka)/n,2))
  ggplot(tabulasi,aes(ket,percent,label=paste(percent,'%',sep='')))+geom_bar(fill='steelblue',stat='identity')+scale_fill_brewer(palette="Pastel2") + theme_minimal() + theme(axis.title.y=element_blank(),axis.title.x=element_blank(),legend.position = 'none',plot.title=element_text(size=16),plot.caption=element_text(size=10),axis.text.y = element_blank(),axis.text.x = element_text(angle=90))+geom_text(position = position_stack(vjust = 1.05),size=3.5) +labs(caption = paste('base:',ifelse(n>=30,n,paste(n,', indikasi',sep='')),sep='')) + labs(title=pertanyaan,subtitle=paste(T2B,mean.score,sep='  ')) + facet_wrap(~kat,scales='free_x') + theme(strip.background = element_rect(colour="black", fill="white",size=1.5, linetype="solid")) #kalau mau pakai facet
}

#bikin bar chart khusus cross tab
bikinin.bar.chart.crosstab.dari.data.saya.donk=function(data,variabel1,variabel2,pertanyaan){
  tabulasi=data %>% tab_cells(variabel1) %>% tab_rows(variabel2) %>% tab_stat_cpct() %>% tab_pivot()
  tabulasi$dummy=strsplit(tabulasi$row_labels,'\\|')
  for(i in 1:length(tabulasi$dummy))
  {tabulasi$row_labels.1[i]=unlist(tabulasi$dummy[i])[2]
  tabulasi$row_labels.2[i]=unlist(tabulasi$dummy[i])[4]}
  tabulasi$dummy=NULL
  tabulasi$row_labels=NULL
  colnames(tabulasi)=c('percent','label.1','label.2')
  tabulasi$percent=round(tabulasi$percent,2)
  d1=tabulasi %>% filter(grepl('total',label.2,ignore.case = T))
  d1$indikasi=if_else(d1$percent<30,', indikasi','')
  d1=d1 %>% filter(!is.na(percent))
  n=paste(d1$label.1,' = ',d1$percent,d1$indikasi,sep='')
  tabulasi = tabulasi %>% filter(!grepl('total',label.2,ignore.case=T)) #tabulasi final untuk chart
  tabulasi = tabulasi %>% filter(!is.na(label.1))
  tabulasi = tabulasi %>% filter(!is.na(label.2))
  tabulasi = tabulasi %>% filter(!is.na(percent))
  n=paste(n,collapse = '; ')
  ggplot(tabulasi,aes(label.2,percent,label=paste(percent,'%',sep='')))+geom_bar(fill='steelblue',stat='identity')+scale_fill_brewer(palette="Pastel2") + theme_minimal() + theme(axis.title.y=element_blank(),axis.title.x=element_blank(),legend.position = 'none',plot.title=element_text(size=16),plot.caption=element_text(size=10),axis.text.y = element_blank())+geom_text(position = position_stack(vjust = 1.05),size=3.5) +labs(caption = paste('base: ',n,sep='')) + labs(title=pertanyaan) + facet_wrap(~label.1,scales='free_x') + theme(strip.background = element_rect(colour="black", fill="white",size=1.5, linetype="solid")) #kalau mau pakai facet
}

#bikin bar chart khusus NPS
bikinin.bar.chart.untuk.NPS.dari.data.saya.donk=function(data,variabel,pertanyaan,sub.judul){
  tabulasi=data %>% tab_cells(variabel) %>% tab_stat_cpct() %>% tab_pivot()
  tabulasi$dummy=strsplit(tabulasi$row_labels,'\\|')
  for(i in 1:length(tabulasi$dummy))
  {tabulasi$row_labels[i]=unlist(tabulasi$dummy[i])[2]}
  tabulasi=data.frame(tabulasi)
  tabulasi[is.na(tabulasi)]=0
  tabulasi=tabulasi[-3]
  colnames(tabulasi)=c('ket','percent')
  tabulasi$percent=round(tabulasi$percent,2)
  n = as.numeric(tabulasi %>% filter(grepl('total',ket,ignore.case=T)) %>% summarize(n=mean(percent))) #ambil base buat kepentingan chart
  tabulasi = tabulasi %>% filter(!grepl('total',ket,ignore.case=T)) #tabulasi final untuk chart
  tabulasi$ket=factor(tabulasi$ket,levels = (tabulasi$ket)) #untuk mengurutkan grafiknya
  T2B=paste('Net Promoter Score = ',tabulasi$percent[10]+tabulasi$percent[11]-(tabulasi$percent[1]+tabulasi$percent[2]+tabulasi$percent[3]+tabulasi$percent[4]+tabulasi$percent[5]+tabulasi$percent[6]+tabulasi$percent[7]),'%',sep='')
  tabulasi$kat=c('Detractors','Detractors','Detractors','Detractors','Detractors','Detractors','Detractors','Passives','Passives','Promoters','Promoters')
  ggplot(tabulasi,aes(ket,percent,label=paste(percent,'%',sep='')))+geom_bar(fill='steelblue',stat='identity')+scale_fill_brewer(palette="Pastel2") + theme_minimal() + theme(axis.title.y=element_blank(),axis.title.x=element_blank(),legend.position = 'none',plot.title=element_text(size=16),plot.caption=element_text(size=10),axis.text.y = element_blank(),axis.text.x = element_text(angle=90))+geom_text(position = position_stack(vjust = 1.05),size=3.5) +labs(caption = paste('base:',ifelse(n>=30,n,paste(n,', indikasi',sep='')),sep='')) + labs(title=pertanyaan,subtitle=T2B) + facet_wrap(~kat,scales='free_x') + theme(strip.background = element_rect(colour="black", fill="white",size=1.5, linetype="solid"))+labs(subtitle = sub.judul) #kalau mau pakai facet
}

export.powerpoint.saya.donk=function(judul.ppt){
  print(doc,paste(judul.ppt,'pptx',sep='.'))
}

#Buat line chart (tren line chart)
bikinin.line.chart.dari.data.tren.waktu.donk=function(judul,sub.judul,caption,dataframe,var.x,var.y){
ggplot(dataframe,aes(x=var.x, y=var.y,group=1,label=round(var.y,2)))+geom_line()+geom_point()+geom_label(size=3)+theme_minimal()+theme(axis.title.y = element_blank(),axis.title.x = element_blank(),axis.text.y = element_blank(),axis.text.x = element_text(size=11),plot.title=element_text(size=16))+labs(title = judul,subtitle = sub.judul,caption=caption)
}

#Buat bikin barchart facet dari dataframe
bikinin.bar.chart.facet.dari.dataframe.donk=function(judul,sub.judul,caption,dataframe,var.x,var.y,facet){
  ggplot(dataframe,aes(x=reorder(var.x,-var.y),y=var.y,label=var.y)) + geom_bar(stat='identity',fill='steelblue')+geom_text(position = position_stack(vjust = 1.03),size=2)+theme_minimal()+facet_wrap(~facet)+ theme(strip.background = element_rect(colour="black", fill="white",size=1.5, linetype="solid"))+theme(panel.grid = element_blank(),axis.title.y = element_blank(),axis.title.x = element_blank(),axis.text.x = element_text(size=8,angle = 90),plot.title=element_text(size=16))+labs(title = judul,subtitle = sub.judul,caption=caption)
}

#Buat boxplot
bikinin.boxplot.donk=function(judul,sub.judul,caption,dataframe,var.x,var.y){
  ggplot(dataframe,aes(x=var.x, y=var.y))+geom_boxplot()+theme_minimal()+theme(axis.title.y = element_blank(),axis.title.x = element_blank(),axis.text.y = element_text(size=7),plot.title=element_text(size=16))+labs(title = judul,subtitle = sub.judul,caption=caption)
} 

liatin.package.yang.ada.di.R.saya.donk=function(){
  package=as.data.frame(installed.packages())
  nama.paket=package %>% arrange(Package)
  nama.paket=as.character(nama.paket$Package)
  return(nama.paket)}

bikinin.tabel.utk.di.slide.donk=function(tabel.data.frame){
  qplot(1:20, 1:20, geom = "blank") + theme_bw() + theme(panel.border = element_blank(),line = element_blank(), text = element_blank()) + annotation_custom(grob = tableGrob(tabel.data.frame))
}

gabung.string.donk=function(vector,vector.number){
  n=length(vector.number)
  x=vector[vector.number[1]]
  i=1
  while(i<n){
    y=vector.number[i+1]
    x=paste(x,vector[y],sep=' --> ')
    i=i+1
  }
  return(x)
}

ubahin.rasio.jadi.persen.donk=function(rasio){
  rasio=round(rasio*100,2)
  return(rasio)
}

#Send email outlook via RDCOM
Outlook <- COMCreate("Outlook.Application")
kirim.email.nutrifood.donk = function(email.to,email.cc,email.bcc,subject,body){
Email = Outlook$CreateItem(0)
# Set the recipient, subject, and body
Email[["to"]] = email.to
Email[["cc"]] = email.cc
Email[["bcc"]] = email.bcc
Email[["subject"]] = subject
Email[["body"]] = body
# Send the message
Email$Send()
}

x='i'
print(x)
for(i in 2:12){
  c=seq(1:i)
  nama=c('i','k','a','n','x','____','f','a','d','h','l','i')
  x=paste(x,nama[i])
  print(x)
}
print('===============================================================================================================')
print('https://passingthroughresearcher.wordpress.com/')
print('Last update: 26 Sept 2019')
#sir.ikanx
