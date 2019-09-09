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

#membersihkan nama variabel dalam data frame
tolong.bersihin.judul.donk = function(data){
judul=colnames(data)
judul=tolower(judul)
judul=gsub(' ','.',judul)
judul=gsub('_','.',judul)
judul=gsub('-','.',judul)
judul=gsub('\\|','.',judul)
judul=gsub('\r','.',judul)
judul=gsub('\n','.',judul)
judul=gsub('\t','.',judul)
judul=gsub('\\(','',judul)
judul=gsub('\\)','',judul)
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
  doc <- add_slide(doc,layout = "Title Slide", master = "Office Theme")
  doc <- ph_with(x=doc,"This is AI Generated Presentation\nUsing R\ni k A n g", location = ph_location_type(type = "subTitle"))
  doc <- ph_with(x=doc,"Thank You", location = ph_location_type(type = "ctrTitle"))
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
    x=paste(x,vector[y])
    i=i+1
  }
  return(x)
}


ubahin.rasio.jadi.persen.donk=function(rasio){
  rasio=round(rasio*100,2)
  return(rasio)
}

############################################################
# scrap detik.com
############################################################
cariin.berita.detik.com.donk = function(url){
    library(rvest)
    webpage <- read_html(url)
    links <- webpage %>% html_nodes("a") %>% html_attr("href")
    judul <- webpage %>% html_nodes("a") %>% html_text()
    data = data.frame(judul,links)
    return(data)
}

bacain.artikel.dari.link.detik.com.donk = function(url){
    webpage <- read_html(url)
    teks = webpage %>% html_nodes("#detikdetailtext") %>% html_text()
    hapus=c('\r','googletag display div gpt ad','googletag cmd push function',
                '1535944519982 0 ','\\{','\\}','\\;','msh','  ','  ','  ','  ')
    for(i in 1:length(hapus)){
        teks = gsub(hapus[i],' ',teks)
    }
    return(teks)
    }

############################################################
# telegram bot
############################################################
cek.pesan.bot.telegram.donk = function(){
    library(telegram.bot)
    library(telegram)
    updater <- Updater(token = bot_token("RTelegramBot"))
    bot <- TGBot$new(token = bot_token('RTelegramBot'))
    
    # Get bot info
    print(bot$getMe())
    # Get updates
    update <- bot$getUpdates()
    return(update)
}

set.live.bot.telegram.donk = function(){
    library(telegram.bot)
    library(telegram)
    updater <- Updater(token = bot_token("RTelegramBot"))
    bot <- TGBot$new(token = bot_token('RTelegramBot'))
    
    # Get bot info
    print(bot$getMe())
    
    # Get updates
    update <- bot$getUpdates()
    
    start <- function(bot, update){
        bot$sendMessage(chat_id = update$message$chat_id,
                        text = paste('Hai Kak ',update$message$from$first_name,', perkenalkan saya i.k.a.n.x_bot_ver_1.005\nSilakan tanyakan tentang machine learning, artificial intelligence, atau apapun itu ya... #projectiseng\nContoh: Apa itu machine learning?',sep=''))
    }
    
    start_handler <- CommandHandler('start', start)
    updater <- updater + start_handler
    
    tolong.donk = function(judul){
        judul=tolower(judul)
        judul=gsub('_','',judul)
        judul=gsub('-','',judul)
        judul=gsub('\\,','',judul)
        judul=gsub('\\?','',judul)
        judul=gsub('\\!','',judul)
        judul=gsub('\\|','',judul)
        judul=gsub('sih','',judul)
        judul=gsub('..','',judul,fixed=T)
        return(judul)
    }
    
    start_handler <- function(bot, update){
        text <- "Saya masih belum belajar itu... Maklum #projectiseng, mau bantu develop bot ini? hehehe.\nTry: `Apa itu machine learning?`\n Try: `Apa itu algoritma?`\n atau silakan berkunjung ke blog saya di: https://passingthroughresearcher.wordpress.com/"
        if (grepl('mean',tolong.donk(update$message$text),ignore.case = T)){text = "Salah satu ukuran pemusatan data. Biasa disebut dengan rata - rata. Dihitung dengan membagi jumlah data dengan banyaknya data. Contoh kasus: https://passingthroughresearcher.wordpress.com/2019/01/01/market-research-101-analisa-punya-point-of-view-lhoo/"}
        else if (grepl('belajar',tolong.donk(update$message$text),ignore.case = T)){text = "Ada berbagai macam cara untuk belajar machine learning. Bisa ambil online course atau hands on dan melihat forum tanya jawab seperti stackoverflow. Tapi pertanyaan yang lebih mendasar adalah `kapan saya harus mulai belajar machine learning?`. Silakan membaca tulisan lengkap saya di: https://passingthroughresearcher.wordpress.com/2018/12/18/kapan-saya-harus-belajar-machine-learning"}
        else if (grepl('median',tolong.donk(update$message$text),ignore.case = T)){text = "Salah satu ukuran pemusatan data. Biasa disebut dengan nilai tengah. Dicari dengan mengurutkan data dari terkecil ke terbesar lalu lihat di mana tengahnya. Contoh kasus: https://passingthroughresearcher.wordpress.com/2019/01/01/market-research-101-analisa-punya-point-of-view-lhoo/"}
        else if (grepl('modus',tolong.donk(update$message$text),ignore.case = T)){text = "Salah satu ukuran pemusatan data. Dicari dengan cara melihat data yang paling sering muncul. Biasanya kita sering mendengarkan modus dalam kata: `mayoritas`. Contoh kasus: https://passingthroughresearcher.wordpress.com/2019/01/01/market-research-101-analisa-punya-point-of-view-lhoo/"}
        else if (grepl('machine',tolong.donk(update$message$text),ignore.case = T)){text = "Secara definisi, machine learning adalah: method of data analysis that automates analytical model building. Kalau saya pribadi lebih senang menyebutnya computational science and statistics. Jadi kalau ada komputasi yang rumit dan melelahkan bagi manusia, biar mesin saja yang melakukannya.\n\nBisa buat apa aja sih?\nMacem-macem yah, dari mulai analisa data (structured atau unstructured) sampai webscrapping data.\n\nSilakan berkunjung ke blog saya di: https://passingthroughresearcher.wordpress.com/ \n\nTry: Bagaimana cara belajarnya?"}
        else if (grepl('ml',tolong.donk(update$message$text),ignore.case = T)){text = "Secara definisi, machine learning adalah: method of data analysis that automates analytical model building. Kalau saya pribadi lebih senang menyebutnya computational science and statistics. Jadi kalau ada komputasi yang rumit dan melelahkan bagi manusia, biar mesin saja yang melakukannya. \n\nBisa buat apa aja sih?\nMacem-macem yah, dari mulai analisa data (structured atau unstructured) sampai webscrapping data.\n\nSilakan berkunjung ke blog saya di: https://passingthroughresearcher.wordpress.com/ \n\nTry: Bagaimana cara belajarnya?"}
        else if (grepl('artificial',tolong.donk(update$message$text),ignore.case = T)){text = "Secara definisi, artificial intelligence adalah kecerdasan buatan. Terms ini pertama muncul pada tahun 1950-an. Merupakan umbrella terms dari berbagai related fields yang digunakan untuk memecahkan masalah komputasi seperti matematika, statistik, dan engineering. Pada dasarnya artificial intelligence saat ini adalah kumpulan algoritma yang ditulis oleh manusia untuk mengerjakan well-defined-tasks (paling sering digunakan untuk repetitive tasks). Istilah machine learning dan deep learning termasuk ke dalam AI itu sendiri. Seringkali orang mempersepsikan AI sebagai suatu hal yang sangat luar biasa (bisa melakukan banyak hal secara sendiri), namun demikian tidak seperti itu.Ada dua tools / bahasa yang sering digunakan, yakni R dan Pyton. Mau tau lebih lanjut? Ketik:\nR atau\nPyton"}
        else if (grepl('algoritma',tolong.donk(update$message$text),ignore.case = T)){text = "Secara simpel algoritma berarti proses berpikir. Bisa dituliskan sebagai baris perintah atau workflow. Sekarang ini kata algoritma erat diasosiasikan sebagai kumpulan baris perintah yang kemudian akan dijalankan oleh mesin atau robot."}
        else if (tolong.donk(update$message$text) == "r"){text = "R atau GNU R adalah software open source yang digunakan dalam computational science. Biasa digunakan oleh matematikawan dan statistikawan untuk melakukan data analisis. Tidak cuma itu, R juga bisa digunakan untuk melakukan pekerjaan lain seperti web scrapping, video analyzing, image data processing, geolocation analysis, bikin chatbot (seperti bot ini) dll. Silakan masuk ke blog saya di https://passingthroughresearcher.wordpress.com/ untuk contoh kasus yang digunakan dengan R."}
        else if (tolong.donk(update$message$text) == "pyton"){text = "Pyton pada awalnya digunakan developer untuk membuat software atau aplikasi. Namun sekarang ini digunakan untuk membuat algoritma dan analisa data. Banyak perdebatan mengenai siapa yang terbaik antara R dan Pyton. Tapi saya rasa keduanya memiliki pangsa pasar dan tujuan masing-masing."}
        else if (grepl('kasih',tolong.donk(update$message$text),ignore.case = T)){text = "Terima kasih kembali... n_n"}
        else if (grepl('trims',tolong.donk(update$message$text),ignore.case = T)){text = "Terima kasih kembali... n_n"}
        else if (grepl('thx',tolong.donk(update$message$text),ignore.case = T)){text = "Terima kasih kembali... n_n"}
        else if (grepl('thank',tolong.donk(update$message$text),ignore.case = T)){text = "Terima kasih kembali... n_n"}
        else if (grepl('thanx',tolong.donk(update$message$text),ignore.case = T)){text = "Terima kasih kembali... n_n"}
        else if (tolong.donk(update$message$text) == "sample"|tolong.donk(update$message$text) == "sampel"){text = "Tentang sample, apa yang mau Anda ketahui?\nDefinisi sampel\nCara menghitung banyaknya sampel\nTeknik sampling"}
        else if (tolong.donk(update$message$text) == "hi"|tolong.donk(update$message$text) == "hai"|tolong.donk(update$message$text) == "halo"){text = "hai, ada yang bisa dibantu kah?\nCoba tuliskan: mean"}
        else if (tolong.donk(update$message$text) == "hii"|tolong.donk(update$message$text) == "test"|tolong.donk(update$message$text) == "tes"){text = "hai, ada yang bisa dibantu kah?\nCoba tuliskan: artificial intelligence"}
        else if (tolong.donk(update$message$text) == "hallo"|tolong.donk(update$message$text) == "haloo"|tolong.donk(update$message$text) == "helo"){text = "hai, ada yang bisa dibantu kah?\nCoba tuliskan: sample"}
        else if (tolong.donk(update$message$text) == "ya"|tolong.donk(update$message$text) == "hellow"|tolong.donk(update$message$text) == "kang"){text = "hai, ada yang bisa dibantu kah?\nCoba tuliskan: modus"}
        else if (tolong.donk(update$message$text) == "ikang"){text = "hai, ada yang bisa dibantu kah?\nCoba tuliskan: median"}
        else if (grepl('salam',tolong.donk(update$message$text),ignore.case = T)){text = "Wa alaikum Salam"}
        else if (tolong.donk(update$message$text) == "assw"){text = "Wa alaikum Salam"}
        else if (tolong.donk(update$message$text) == "asw"){text = "Wa alaikum Salam"}
        else if (tolong.donk(update$message$text) == "ass"){text = "Wa alaikum Salam"}
        else if (tolong.donk(update$message$text) == "pa"){text = "Kenapa San?"}
        else if (tolong.donk(update$message$text) == "kamu siapa"){text = "Saya chatbot versi #projectiseng ya... Semoga semakin lama bisa semakin pintar. Aamiin..."}
        else if (tolong.donk(update$message$text) == "kamu apa"){text = "Saya chatbot versi #projectiseng ya... Semoga semakin lama bisa semakin pintar. Aamiin..."}
        else if (tolong.donk(update$message$text) == "km siapa"){text = "Saya chatbot versi #projectiseng ya... Semoga semakin lama bisa semakin pintar. Aamiin..."}
        else if (tolong.donk(update$message$text) == "km apa"){text = "Saya chatbot versi #projectiseng ya... Semoga semakin lama bisa semakin pintar. Aamiin..."}
        else if (tolong.donk(update$message$text) == "siapa kamu"){text = "Saya chatbot versi #projectiseng ya... Semoga semakin lama bisa semakin pintar. Aamiin..."}
        else if (tolong.donk(update$message$text) == "siapa km"){text = "Saya chatbot versi #projectiseng ya... Semoga semakin lama bisa semakin pintar. Aamiin..."}
        else if (tolong.donk(update$message$text) == "apa kamu"){text = "Saya chatbot versi #projectiseng ya... Semoga semakin lama bisa semakin pintar. Aamiin..."}
        else if (tolong.donk(update$message$text) == "apa km"){text = "Saya chatbot versi #projectiseng ya... Semoga semakin lama bisa semakin pintar. Aamiin..."}
        else if (tolong.donk(update$message$text) == "oh gtu ya"){text = "Iya Kak... Kakak mau tanya apa? yang gampang-gampang aja ya Kak..."}
        else if (tolong.donk(update$message$text) == "oh gitu ya"){text = "Iya Kak... Kakak mau tanya apa? yang gampang-gampang aja ya Kak..."}
        else if (tolong.donk(update$message$text) == "oh gt ya"){text = "Iya Kak... Kakak mau tanya apa? yang gampang-gampang aja ya Kak..."}
        else if (tolong.donk(update$message$text) == "oh gt y"){text = "Iya Kak... Kakak mau tanya apa? yang gampang-gampang aja ya Kak..."}
        bot$sendMessage(chat_id = update$message$chat_id, text = text)
    }
    updater <- updater + MessageHandler(start_handler, MessageFilters$text)
    updater$start_polling()
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
print('Last update: 9 Sept 2019')
#sir.ikanx
