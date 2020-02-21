rm(list=ls())
library(dplyr)
library(ggplot2)

proporsi = c(3.1/100,21.0/100,52.4/100,23.4/100)
ses = c('A','B','C','D')

orang = function(){
  sample(ses,1,prob = proporsi)
}
orang()

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

berapa_calon_responden = function(){
  data_1 = siapa()
  i = 1
  while(sum(data_1$A)<70 && data_1$B<100){ # kelas sosial ekonomi A harus minimal 70
    data_fi = siapa()
    data_1 = rbind(data_1,data_fi)
    i = i + 1
  }
  return(i) # berapa banyak calon responden yang ditemui sampai terpenuhi banyak minimal responden
}

berapa_calon_responden()

hasil = data.frame(id = c(1:5))
for(i in 1:length(hasil$id)){
  hasil$banyak_calon_resp[i] = berapa_calon_responden()
}
head(hasil)