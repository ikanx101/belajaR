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
