setwd('D:/Project_R/Kamis Data/BNPB')
rm(list=ls())

library(rvest)
library(dplyr)
library(tidyr)
library(tidytext)
library(ggplot2)
library(ggpubr)

#masukin url
url = 'http://bnpb.cloud/dibi/tabel1b'
data = read_html(url) %>% html_table(fill=T)
data = data[[1]]
colnames(data) = janitor::make_clean_names(data[1,])
data = data[-1,]
data = data[1:5]
data = data[-9,]
str(data)

#final data setelah bebersih
data = 
data %>% separate(jenis_bencana,into = c('dummy','jenis'),sep='\\.') %>%
  mutate(dummy=NULL,
         luka_luka = gsub('\\,','',luka_luka),
         menderita_mengungsi = gsub('\\,','',menderita_mengungsi),
         jumlah_kejadian = as.numeric(jumlah_kejadian),
         meninggal_hilang = as.numeric(meninggal_hilang),
         luka_luka = as.numeric(luka_luka),
         menderita_mengungsi = as.numeric(menderita_mengungsi))

#berapa banyak kejadian
chart.1 = 
data %>% ggplot(aes(x=reorder(jenis,jumlah_kejadian),y=jumlah_kejadian)) +
  theme_pubr() +
  geom_col(fill='#bac9e3',color='#24498a',alpha=.7) +
  geom_label(aes(label = jumlah_kejadian),fill='#e9edf5',color='#a60707',size=3) +
  theme(axis.title = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size=9),
        plot.title = element_text(size=20,face='bold'),
        plot.subtitle = element_text(size=12,face='italic')) +
  labs(title = 'Banyaknya Bencana Alam\ndi Indonesia 2019',
       subtitle = 'source: Badan Nasional Penanggulangan Bencana') +
  coord_flip()
#ggsave('jumlah bencana.png',width = 10,height = 8)

#rate korban per kejadian
chart.2 = 
data %>% mutate(rate_meninggal = meninggal_hilang / jumlah_kejadian,
                rate_luka = luka_luka / jumlah_kejadian,
                rate_mengungsi = menderita_mengungsi / jumlah_kejadian,
                rate_meninggal = round(rate_meninggal,3),
                rate_luka = round(rate_luka,3),
                rate_mengungsi = round(rate_mengungsi,3)) %>%
  select(jenis,rate_meninggal,rate_luka,rate_mengungsi) %>%
  reshape2::melt(id.vars='jenis') %>%
  mutate(variable = 
           case_when(variable=='rate_meninggal'~'Banyak orang meninggal/hilang per kejadian',
                     variable=='rate_luka'~'Banyak orang luka-luka per kejadian',
                     variable=='rate_mengungsi'~'Banyak orang menderita/mengungsi per kejadian')) %>% 
  ggplot(aes(x=variable,y=value)) +
  theme_pubr() +
  geom_col(fill='#bac9e3',color='#24498a',alpha=.7) +
  geom_label(aes(label = value),fill='#e9edf5',color='#a60707',size=4) +
  coord_flip() +
  facet_wrap(~ jenis,nrow = 2) +
  theme(axis.title = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size=13),
        plot.title = element_text(size=24,face='bold'),
        plot.subtitle = element_text(size=15,face='italic'),
        plot.caption = element_text(size=10,face='italic')) +
  labs(title = 'Rasio Korban Bencana Alam per Kejadian di Indonesia 2019',
       subtitle = 'source: Badan Nasional Penanggulangan Bencana',
       caption = 'Scraped and Visualised\nusing R\ni k A n x')
ggsave('rate korban bencana.png',width = 14,height = 12)

ggarrange(chart.1,chart.2,ncol=2,nrow=1,widths = c(1,2))
ggsave('wallpaper.png',width = 19.20,height = 10.80,dpi=800)
