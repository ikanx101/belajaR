rm(list=ls())
setwd("/cloud/project/Bukan Infografis/Our world in data/GDP vs Happiness")

#the libs family
library(ggplot2)
library(tidyverse)
library(ggpubr)
library(ggthemes)
library(factoextra)

#baca data
file = list.files()
data = read.csv(file[2])
str(data)
colnames(data) = c('negara','code','tahun',
                   'gdp.per.capita',
                   'life.satisfaction',
                   'population')

#kita mulai clusteringnya yah
#dimulai dari mengambil data dan variabel yang diinginkan
data.new.1 =
  data %>% filter(tahun==2017) %>%
  filter(!is.na(gdp.per.capita)) %>%
  filter(!is.na(life.satisfaction)) %>%
  filter(!is.na(population)) %>%
  mutate(negara = as.character(negara)) 
head(data.new.1)

data.new =
  data.new.1 %>%
  select(gdp.per.capita,life.satisfaction,population)
setwd("/cloud/project/Bukan Infografis/Our world in data/GDP vs Happiness/Clustering")

#transformasi skala
data.new =
  data.new %>%
  mutate(gdp.per.capita = cut(gdp.per.capita,breaks = 5,labels = c(1,2,3,4,5)),
         life.satisfaction = cut(life.satisfaction,breaks = 5,labels=c(1,2,3,4,5)),
         population = cut(population,breaks = 5,labels = c(1,2,3,4,5)))
head(data.new)

#kita pake elbow yah
elbow=fviz_nbclust(data.new, kmeans, method = "wss") 
ggsave(elbow,file='elbow method.png',width=16,height=9, units='in',dpi=150)

#yang ini pake siluet
siluet=fviz_nbclust(data.new, kmeans, method = "silhouette") #siluet method hasil: 2 dan 6
ggsave(siluet,file='sillhoutte method.png',width=16,height=9, units='in',dpi=150)

head(data.new)
set.seed(123)
final = kmeans(data.new,7,nstart=10)
final$cluster
data.new.1$cluster = final$cluster
head(data.new.1)

sink('hasil clustering.txt')
print(final)
sink()
