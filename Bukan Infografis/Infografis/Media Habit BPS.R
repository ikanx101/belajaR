rm(list=ls())
setwd('D:/Project_R/Media Habit BPS')

#ambil libraries
library(rvest)
library(tidyr)
library(dplyr)
library(ggplot2)
library(ggrepel)
library(ggpubr)
library(readxl)

########################
#bps nonton tv
url = 'Indo_27_4503467.xls'
data.tv = read_excel(url,skip=4)
colnames(data.tv) = c('prov','kota.laki','kota.pere','kota.total',
                      'desa.laki','desa.pere','desa.total',
                      'total.laki','total.pere','total.total')
data.tv = data.tv %>% mutate(kota.laki = as.numeric(kota.laki),
                             kota.pere = as.numeric(kota.pere),
                             kota.total = as.numeric(kota.total),
                             desa.laki = as.numeric(desa.laki),
                             desa.pere = as.numeric(desa.pere),
                             desa.total = as.numeric(desa.total)) %>%
  filter(!is.na(total.total)) %>%
  mutate(prov = factor(prov, levels = prov))
data.tv[is.na(data.tv)] = 0 #replace all na to 0's

#bikin ggplot ya
#chart.1
judul = 'Proporsi Penduduk yang Menonton Acara Televisi Selama Seminggu Terakhir di Perkotaan'
sub = 'Berumur 5 Tahun ke Atas\nSumber: BPS 2018'
capt = 'Scraped and Visualized\nusing R\ni k A n x'

chart.1 = 
data.tv %>% select(prov,kota.laki,kota.pere,kota.total) %>%
  reshape2::melt(id.vars='prov') %>%
  mutate(variable = case_when(variable == 'kota.laki' ~ 'Pria perkotaan',
                              variable == 'kota.pere' ~ 'Wanita perkotaan',
                              variable == 'kota.total' ~ 'Total perkotaan')) %>%
  ggplot(aes(x=prov,y=value,group=variable)) + 
  theme_pubclean() +
  geom_col(aes(fill=variable),
           color='steelblue',
           position='dodge',
           alpha=.5) +
  scale_fill_brewer(palette = 'Set1') +
  geom_text(aes(label=round(value,1)),
            angle=90,
            position = position_dodge(1),
            size=3) +
  labs(title = judul,
       subtitle = sub,
       caption = capt,
       fill = 'Keterangan') +
  theme(axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_text(angle=90,face='bold'),
        axis.ticks = element_blank(),
        legend.position = 'bottom',
        plot.title = element_text(size=15,face='bold'),
        plot.subtitle = element_text(size=13),
        plot.caption = element_text(size=9,face='italic'))

#chart.2
judul = 'Proporsi Penduduk yang Menonton Acara Televisi Selama Seminggu Terakhir di Pedesaan'
sub = 'Berumur 5 Tahun ke Atas\nSumber: BPS 2018'
capt = 'Scraped and Visualized\nusing R\ni k A n x'

chart.2 = 
  data.tv %>% select(prov,desa.laki,desa.pere,desa.total) %>%
  reshape2::melt(id.vars='prov') %>%
  mutate(variable = case_when(variable == 'desa.laki' ~ 'Pria pedesaan',
                              variable == 'desa.pere' ~ 'Wanita pedesaan',
                              variable == 'desa.total' ~ 'Total pedesaan')) %>%
  ggplot(aes(x=prov,y=value,group=variable)) + 
  theme_pubclean() +
  geom_col(aes(fill=variable),
           color='steelblue',
           position='dodge',
           alpha=.5) +
  scale_fill_brewer(palette = 'Set1') +
  geom_text(aes(label=round(value,1)),
            angle=90,
            position = position_dodge(1),
            size=3) +
  labs(title = judul,
       subtitle = sub,
       caption = capt,
       fill = 'Keterangan') +
  theme(axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_text(angle=90,face='bold'),
        axis.ticks = element_blank(),
        legend.position = 'bottom',
        plot.title = element_text(size=15,face='bold'),
        plot.subtitle = element_text(size=13),
        plot.caption = element_text(size=9,face='italic'))

ggarrange(chart.1,chart.2,
          ncol = 1,
          nrow = 2,
          heights = c(1,1))
ggsave('TV Indonesia.png',height = 15,width = 15,dpi = 500)




########################
#bps denger radio
url = 'Indo_27_7419619.xls'
data.radio = read_excel(url,skip=4)
colnames(data.radio) = c('prov','kota.laki','kota.pere','kota.total',
                      'desa.laki','desa.pere','desa.total',
                      'total.laki','total.pere','total.total')
data.radio = data.radio %>% mutate(desa.laki = as.numeric(desa.laki),
                             desa.pere = as.numeric(desa.pere),
                             desa.total = as.numeric(desa.total)) %>%
  filter(!is.na(total.total)) %>%
  mutate(prov = factor(prov, levels = prov))
data.radio[is.na(data.radio)] = 0 #replace all na to 0's

#bikin ggplot ya
#chart.3
judul = 'Proporsi Penduduk yang Mendengarkan Siaran Radio Selama Seminggu Terakhir di Perkotaan'
sub = 'Berumur 5 Tahun ke Atas\nSumber: BPS 2018'
capt = 'Scraped and Visualized\nusing R\ni k A n x'

chart.3 = 
  data.radio %>% select(prov,kota.laki,kota.pere,kota.total) %>%
  reshape2::melt(id.vars='prov') %>%
  mutate(variable = case_when(variable == 'kota.laki' ~ 'Pria perkotaan',
                              variable == 'kota.pere' ~ 'Wanita perkotaan',
                              variable == 'kota.total' ~ 'Total perkotaan')) %>%
  ggplot(aes(x=prov,y=value,group=variable)) + 
  theme_pubclean() +
  geom_col(aes(fill=variable),
           color='steelblue',
           position='dodge',
           alpha=.5) +
  scale_fill_brewer(palette = 'Set1') +
  geom_text(aes(label=round(value,1)),
            angle=90,
            position = position_dodge(1),
            size=3) +
  labs(title = judul,
       subtitle = sub,
       caption = capt,
       fill = 'Keterangan') +
  theme(axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_text(angle=90,face='bold'),
        axis.ticks = element_blank(),
        legend.position = 'bottom',
        plot.title = element_text(size=15,face='bold'),
        plot.subtitle = element_text(size=13),
        plot.caption = element_text(size=9,face='italic'))

#chart.4
judul = 'Proporsi Penduduk yang Mendengarkan Siaran Radio Selama Seminggu Terakhir di Pedesaan'
sub = 'Berumur 5 Tahun ke Atas\nSumber: BPS 2018'
capt = 'Scraped and Visualized\nusing R\ni k A n x'

chart.4 = 
  data.radio %>% select(prov,desa.laki,desa.pere,desa.total) %>%
  reshape2::melt(id.vars='prov') %>%
  mutate(variable = case_when(variable == 'desa.laki' ~ 'Pria pedesaan',
                              variable == 'desa.pere' ~ 'Wanita pedesaan',
                              variable == 'desa.total' ~ 'Total pedesaan')) %>%
  ggplot(aes(x=prov,y=value,group=variable)) + 
  theme_pubclean() +
  geom_col(aes(fill=variable),
           color='steelblue',
           position='dodge',
           alpha=.5) +
  scale_fill_brewer(palette = 'Set1') +
  geom_text(aes(label=round(value,1)),
            angle=90,
            position = position_dodge(1),
            size=3) +
  labs(title = judul,
       subtitle = sub,
       caption = capt,
       fill = 'Keterangan') +
  theme(axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_text(angle=90,face='bold'),
        axis.ticks = element_blank(),
        legend.position = 'bottom',
        plot.title = element_text(size=15,face='bold'),
        plot.subtitle = element_text(size=13),
        plot.caption = element_text(size=9,face='italic'))

ggarrange(chart.3,chart.4,
          ncol = 1,
          nrow = 2,
          heights = c(1,1))
ggsave('Radio Indonesia.png',height = 15,width = 15,dpi = 500)




########################
#bps membaca surat kabar
url = 'Indo_27_22936814.xls'
data.koran = read_excel(url,skip=4)
colnames(data.koran) = c('prov','kota.laki','kota.pere','kota.total',
                         'desa.laki','desa.pere','desa.total',
                         'total.laki','total.pere','total.total')
data.koran = data.koran %>% mutate(desa.laki = as.numeric(desa.laki),
                                   desa.pere = as.numeric(desa.pere),
                                   desa.total = as.numeric(desa.total)) %>%
  filter(!is.na(total.total)) %>%
  mutate(prov = factor(prov, levels = prov))
data.koran[is.na(data.koran)] = 0 #replace all na to 0's

#bikin ggplot ya
#chart.5
judul = 'Proporsi Penduduk yang Membaca Surat Kabar/Majalah (online dan offline) Selama Seminggu Terakhir\ndi Perkotaan'
sub = 'Berumur 5 Tahun ke Atas\nSumber: BPS 2018'
capt = 'Scraped and Visualized\nusing R\ni k A n x'

chart.5 = 
  data.koran %>% select(prov,kota.laki,kota.pere,kota.total) %>%
  reshape2::melt(id.vars='prov') %>%
  mutate(variable = case_when(variable == 'kota.laki' ~ 'Pria perkotaan',
                              variable == 'kota.pere' ~ 'Wanita perkotaan',
                              variable == 'kota.total' ~ 'Total perkotaan')) %>%
  ggplot(aes(x=prov,y=value,group=variable)) + 
  theme_pubclean() +
  geom_col(aes(fill=variable),
           color='steelblue',
           position='dodge',
           alpha=.5) +
  scale_fill_brewer(palette = 'Set1') +
  geom_text(aes(label=round(value,1)),
            angle=90,
            position = position_dodge(1),
            size=3) +
  labs(title = judul,
       subtitle = sub,
       caption = capt,
       fill = 'Keterangan') +
  theme(axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_text(angle=90,face='bold'),
        axis.ticks = element_blank(),
        legend.position = 'bottom',
        plot.title = element_text(size=15,face='bold'),
        plot.subtitle = element_text(size=13),
        plot.caption = element_text(size=9,face='italic'))

#chart.6
judul = 'Proporsi Penduduk yang Membaca Surat Kabar/Majalah (online dan offline) Selama Seminggu Terakhir\ndi Pedesaan'
sub = 'Berumur 5 Tahun ke Atas\nSumber: BPS 2018'
capt = 'Scraped and Visualized\nusing R\ni k A n x'

chart.6 = 
  data.koran %>% select(prov,desa.laki,desa.pere,desa.total) %>%
  reshape2::melt(id.vars='prov') %>%
  mutate(variable = case_when(variable == 'desa.laki' ~ 'Pria pedesaan',
                              variable == 'desa.pere' ~ 'Wanita pedesaan',
                              variable == 'desa.total' ~ 'Total pedesaan')) %>%
  ggplot(aes(x=prov,y=value,group=variable)) + 
  theme_pubclean() +
  geom_col(aes(fill=variable),
           color='steelblue',
           position='dodge',
           alpha=.5) +
  scale_fill_brewer(palette = 'Set1') +
  geom_text(aes(label=round(value,1)),
            angle=90,
            position = position_dodge(1),
            size=3) +
  labs(title = judul,
       subtitle = sub,
       caption = capt,
       fill = 'Keterangan') +
  theme(axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_text(angle=90,face='bold'),
        axis.ticks = element_blank(),
        legend.position = 'bottom',
        plot.title = element_text(size=15,face='bold'),
        plot.subtitle = element_text(size=13),
        plot.caption = element_text(size=9,face='italic'))

ggarrange(chart.5,chart.6,
          ncol = 1,
          nrow = 2,
          heights = c(1,1))
ggsave('Koran Indonesia.png',height = 15,width = 15,dpi = 500)

t1 = ggarrange(chart.1,chart.2,
               ncol=2,
               nrow=1)
t2 = ggarrange(chart.3,chart.4,
               ncol=2,
               nrow=1)
t3 = ggarrange(chart.5,chart.6,
               ncol=2,
               nrow=1)
ggarrange(t1,t2,t3,
          ncol = 1,
          nrow = 3)
ggsave('Media Habit BPS Indonesia.png',height = 20,width = 23)
