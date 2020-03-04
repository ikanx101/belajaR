rm(list=ls())
setwd('D:/Project_R')
library(dplyr)
library(ggplot2)
library(ggpubr)

# bikin fungsi pertama
proporsi = c(3.1/100,21.0/100,52.4/100,23.4/100)
ses = c('A','B','C','D')

orang = function(){
  sample(ses,1,prob = proporsi)
}
orang()

# bikin fungsi kedua
siapa = function(){
  hitung = orang()
  A = ifelse(hitung == 'A',1,0)
  B = ifelse(hitung == 'B',1,0)
  C = ifelse(hitung == 'C',1,0)
  D = ifelse(hitung == 'D',1,0)
  data = data.frame(A,B,C,D) # calon responden yang ditemui memiliki kelas ekonomi apa?
  mau = sample(c(1,0),1,prob = c(.5,.5)) # apakah calon responden mau diwawancarai atau tidak?
  data = data*mau # kelas ekonomi responden yang diwawancarai. Apakah ada atau tidak ada?
  return(data)
}
siapa()

# bikin fungsi ketiga
berapa_calon_responden = function(n){
  n+100
  data_1 = siapa()
  i = 1
  while(sum(data_1$A)<70 && data_1$B<100){ # kelas sosial ekonomi A harus minimal 70
    data_fi = siapa()
    data_1 = rbind(data_1,data_fi)
    i = i + 1
  }
  return(i) # berapa banyak calon responden yang ditemui sampai terpenuhi banyak minimal responden
}

berapa_calon_responden(1)

# simulasi dimulai dari mari
hasil = data.frame(id = c(1:500))
hasil$banyak_calon_resp = sapply(hasil$id,berapa_calon_responden)
hasil %>% write.csv('simulasi lama interview.csv')