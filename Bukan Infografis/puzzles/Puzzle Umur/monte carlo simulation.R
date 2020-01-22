setwd("/cloud/project/Bukan Infografis/puzzles/Puzzle Umur")
rm(list=ls())


library(dplyr)
library(ggplot2)

hari = c(1:365)

age_couple = function(n){
  dummy = data.frame(iter = c(1:7000),n)
  for(i in 1:7000){
    hasil = any(duplicated(sample(hari,n,replace=T)))
    dummy$iter[i] = ifelse(hasil==T,1,0)
  }
  dummy = dummy %>% summarise(prob = sum(iter)/7000)
  data = data.frame(group_number = n,
                    prob = dummy$prob)
  return(data)
}

# iterasi pertama
data_new = age_couple(2)

#iterasi selanjutnya
for(i in 3:70){
  temp = age_couple(i)
  data_new = rbind(data_new,temp)
}

save(data_new,file = 'age puzzle.rda')