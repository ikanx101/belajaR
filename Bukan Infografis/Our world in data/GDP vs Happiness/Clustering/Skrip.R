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

#kita buat grafik terbaru yah
data.new.1 %>%
  ggplot(aes(x = gdp.per.capita,
             y = life.satisfaction)) +
  theme_tufte() +
  geom_point(aes(color = as.factor(cluster)),size=3) +
  scale_color_brewer(palette = 'Dark2') +
  geom_text(aes(label = negara),size=2.25,alpha=.45) +
  theme(legend.position = 'none') +
  labs(title = 'Cluster Analysis\nSetiap Warna Merepresentasikan Kelompok Negara',
       subtitle = 'Klasifikasi menggunakan algoritma k-means clustering.\nSuatu teknik unsupervised yang digunakan untuk mengelompokkan data berdasarkan cluster center.\nDidapat 7 buah cluster negara.\nVariabel yang digunakan: GDP per kapita, happiness index, dan populasi.',
       caption = 'Scraped and Visualized from ourworldindata.org\nusing R\ni k A n x',
       x = 'GDP per Capita',
       y = 'Life satisfaction') +
  theme(axis.text = element_blank(),
        plot.title = element_text(size=24,face='bold'),
        plot.subtitle = element_text(size=10),
        plot.caption = element_text(size=8,face='bold.italic'),
        axis.title = element_text(size=15,face='bold'))
ggsave('Cluster Model.png',
       width = 10,
       height = 8,
       dpi = 600)
