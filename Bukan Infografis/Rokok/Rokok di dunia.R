rm(list=ls())
setwd("/cloud/project/Bukan Infografis/Rokok")

library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(ggpubr)

#kita ambil datanya
data = read.csv('number-of-total-daily-smokers.csv')
colnames(data) = janitor::make_clean_names(colnames(data))
colnames(data)[4] = 'total'

#target negara
target = c('Indonesia','Malaysia','Vietnam',
           'Thailand','Phillippines')

#yuk kita bikin grafiknya
options(scipen = 10)
data %>% filter(entity %in% target) %>%
  ggplot(aes(x=year,y=total,group=entity)) +
  geom_line(aes(color=entity),size=1.2) +
  theme_pubclean() +
  labs(title='Number of Daily Smokers',
       subtitle='source: ourworldindata.org',
       caption='Scraped and Visualised\nusing R\ni k A n x',
       color='Some of\nASEAN Countries') +
  theme(axis.title = element_blank(),
        axis.text.x=element_text(face='bold'),
        plot.title=element_text(size=25,face='bold'),
        plot.subtitle = element_text(size=15),
        plot.caption = element_text(size=9,face='italic'))
ggsave('Smokeys.png',width=10,height=8,dpi=500)

#kita bikin growth 10 tahun terakhir yah
data.baru =
  data %>% filter(year %in% c(2002,2012)) %>%
  select(entity,year,total)

#kita pecah dua yah
data.2002 = data.baru %>% filter(year==2002) %>% mutate(year=NULL,
                                                       total.2002=total,
                                                       total=NULL)
data.2012 = data.baru %>% filter(year==2012) %>% mutate(year=NULL,
                                                        total.2012=total,
                                                        total=NULL)
data.baru = merge(data.2002,data.2012)

#hitung growth yah
data.baru %>% mutate(growth = round(((total.2012 - total.2002)/total.2002)*100,2)) %>%
  mutate(warna=ifelse(growth<=0,'Darkred','Steelblue')) %>%
  ggplot(aes(x=reorder(entity,growth),y=growth)) +
  geom_col(aes(fill=warna)) +
  coord_flip() +
  theme_cleveland() +
  labs(title = 'Growth Number of Daily Smokers 2002 vs 2012',
       subtitle = 'source: ourworldindata.org',
       caption='Scraped and Visualised\nusing R\ni k A n x') +
  theme(legend.position = 'none',
        axis.title = element_blank(),
        axis.text.y=element_text(size=4,face='bold'),
        plot.title=element_text(size=14,face='bold'),
        plot.subtitle = element_text(size=10),
        plot.caption = element_text(size=9,face='italic'))
ggsave('Smokeys growth.png',width=8,height=10,dpi=300)
