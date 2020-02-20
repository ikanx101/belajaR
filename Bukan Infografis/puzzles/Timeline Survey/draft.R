rm(list=ls())
library(dplyr)
library(ggplot2)

proporsi = c(4.7/100,15.1/100,44.3/100,35.9/100)
ses = c('U1','U2','M1','M2')

orang = function(){
  sample(ses,1,prob = proporsi)
}

siapa = function(){
  hitung = orang()
  U1 = ifelse(hitung == 'U1',1,0)
  U2 = ifelse(hitung == 'U2',1,0)
  M1 = ifelse(hitung == 'M1',1,0)
  M2 = ifelse(hitung == 'M2',1,0)
  data = data.frame(U1,U2,M1,M2)
  return(data)
}

data_1 = siapa()

while(sum(data_1$U1)<30){
  data_fi = siapa()
  data_1 = rbind(data_1,data_fi)
}
sum(data_1$U1)
sum(data_1$U2)
sum(data_1$M1)
sum(data_1$M2)
length(data_1$U1)
