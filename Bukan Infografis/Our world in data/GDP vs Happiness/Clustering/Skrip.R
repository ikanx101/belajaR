rm(list=ls())
setwd("/cloud/project/Bukan Infografis/Our world in data/GDP vs Happiness")

#the libs family
library(ggplot2)
library(tidyverse)
library(ggpubr)
library(ggthemes)

#baca data
file = list.files()
data = read.csv(file[1])
str(data)
colnames(data) = c('negara','code','tahun',
                   'gdp.per.capita',
                   'life.satisfaction',
                   'population')

#kita fokus di tahun 2017
data %>% filter(tahun==2017) %>% 
  filter(!is.na(gdp.per.capita)) %>%
  filter(!is.na(life.satisfaction)) %>%
  filter(!is.na(population)) %>%
  ggplot(aes(x = gdp.per.capita,
             y = life.satisfaction)) +
  theme_tufte() +
  geom_point(aes(size = population,color = population),alpha=.7) +
  geom_text(aes(label = negara),size=2.25,alpha=.45) +
  geom_smooth(method = 'lm',alpha=.1) +
  theme(legend.position = 'none') +
  labs(title = 'Money Can`t Buy Happiness...\nIs that true?',
       subtitle = 'Each dot in the visualization represents one country. The vertical position of the dots shows national average self-reported life satisfaction\nin the Cantril Ladder (a scale ranging from 0-10 where 10 is the highest possible life satisfaction)\nwhile the horizontal position shows GDP per capita based on purchasing power parity (i.e. GDP per head after adjusting for inflation and cross-country price differences).',
       caption = 'Scraped and Visualized from ourworldindata.org\nusing R\ni k A n x',
       x = 'GDP per Capita',
       y = 'Life satisfaction') +
  theme(axis.text = element_blank(),
        plot.title = element_text(size=24,face='bold'),
        plot.subtitle = element_text(size=10),
        plot.caption = element_text(size=8,face='bold.italic'),
        axis.title = element_text(size=15,face='bold')) +
  stat_regline_equation(
    aes(label =  paste(..eq.label.., ..adj.rr.label.., sep = "~~~~"))
  )
ggsave('reg model 2.png',
       width = 10,
       height = 8,
       dpi = 600)

#kita lagi dengan tambahan korelasi yah
korel =
  data %>% filter(tahun==2017) %>%
  filter(!is.na(gdp.per.capita)) %>%
  filter(!is.na(life.satisfaction)) %>%
  filter(!is.na(population)) %>% 
  summarise(cor(gdp.per.capita,life.satisfaction))
# ditemukan korelasi yang tinggi
write.table(korel,file='Hasil korelasi.txt')

#kita bikin modelnya yah
data.lm =
  data %>% filter(tahun==2017) %>%
  filter(!is.na(gdp.per.capita)) %>%
  filter(!is.na(life.satisfaction)) %>%
  filter(!is.na(population))

model.reg =
  lm(life.satisfaction~gdp.per.capita,
     data=data.lm)
summary(model.reg)
str(model.reg)

sink('summary reg model.txt')
print(summary(model.reg))
sink()
