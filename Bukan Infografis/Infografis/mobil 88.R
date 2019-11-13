rm(list=ls())

library(tidyverse)
library(rvest)
library(ggpubr)

setwd('D:/Project_R/Kamis Data/Mobil88')

data = read_html('web.html') %>% {
  tibble(
    mobil = html_nodes(.,'.product-name') %>% html_text(),
    fitur = html_nodes(.,'.product-feature') %>% html_text(),
    harga = html_nodes(.,'.price') %>% html_text()
  )
}

clean_data = 
data %>% separate(fitur,into=c('tahun','km','transmisi'),sep='\\|') %>%
  mutate(tahun = gsub(' ','',tahun),
         tahun = as.numeric(tahun),
         km = gsub(' ','',km),
         km = gsub('KM','',km),
         km = as.numeric(km),
         harga = gsub('\\.','',harga),
         harga = gsub('Rp ','',harga),
         harga = as.numeric(harga),
         transmisi = gsub(' ','',transmisi)) %>%
  separate(mobil,into = c('mobil','varian'),sep='\\(') %>%
  mutate(varian = NULL,lengkap = mobil) %>%
  separate(mobil,into = c('merk','dummy'),sep=' ') %>%
  mutate(dummy=NULL)

caption = 'scraped and visualized\nusing R\i k A n x'
source='sumber: www.mobil88.astra.co.id'

chart.1=
clean_data %>% group_by(merk,transmisi) %>% summarise(n=n()) %>%
  ggplot(aes(reorder(merk,-n),n)) + 
  geom_col(aes(fill = transmisi),alpha=0.4,position = position_stack()) +
  scale_fill_manual(values = c("#0073C2FF", "#EFC000FF")) +
  theme_pubclean() +
  labs(fill = 'Transmisi',
       title = 'Merek dan Jenis Mobil Bekas yang Dijual',
       subtitle = source,
       y = 'Banyak mobil yang dijual') +
  theme(axis.title.x = element_blank())

chart.2=
clean_data %>% group_by(merk) %>% 
  summarise(rata = mean(harga/100000000),
            sd = sd(harga/100000000,na.rm=T)) %>%
  mutate(sd = ifelse(is.na(sd),0,sd)) %>%
  ggplot(aes(reorder(merk,rata), rata)) +
  geom_line(aes(group = 1),color='steelblue',size=2,alpha=.4) +
  geom_errorbar( aes(ymin = rata-sd, ymax = rata+sd),width = 0.1,color='darkred') +
  geom_point(size = 2) +
  theme_pubclean() +
  labs(title = 'Rata-rata dan Rentang Harga per Merek Mobil Bekas yang Dijual',
       subtitle = source,
       y = 'Dalam ratusan juta rupiah') +
  theme(axis.title.x = element_blank())

library(ggpubr)
tes = clean_data %>% filter(merk %in% c('Toyota','Honda','Daihatsu')) %>%
  mutate(harga = harga/100000000)

chart.3 = 
ggscatterhist(
  tes, x = "km", y = "harga",
  color = "merk", size = 3, alpha = 0.6,
  palette = c("#00AFBB", "#E7B800", "#FC4E07"),
  margin.params = list(fill = "merk", color = "black", size = 0.2),
  ylab = 'Harga (dalam ratusan juta rupiah)',
  xlab = 'Kilometer mobil (odometer)',
  title = 'Harga dan Kilometer Top 3 Merk Mobil Bekas yang Dijual'
)

chart.5 = 
clean_data %>% filter(grepl('avanza',lengkap,ignore.case = T) |
                      grepl('xenia',lengkap,ignore.case = T)) %>% 
  mutate(merk = ifelse(merk=='Toyota','Avanza','Xenia')) %>%
  ggplot(aes(km, harga)) +
  geom_jitter(aes(col=merk,size=tahun)) + 
  scale_size(range = c(.1, 4)) +
  geom_smooth(aes(col=merk), method="lm",se=F) +
  theme_pubclean() +
  labs(title = 'Avanza vs Xenia: Perbandingan Harga dan Kilometer',
       subtitle = source,
       y = 'Dalam ratusan juta rupiah',
       x = 'Kilometer mobil (odometer)',
       size = 'Tahun Mobil',
       col = 'Merk') +
  theme(axis.text = element_blank())
ggsave('avanza xenia.png',width = 9,height = 7)

library(ggcorrplot)
tes.2 = clean_data %>% select(c('tahun','km','harga'))
corr <- round(cor(tes.2), 1)

chart.4=
ggcorrplot(corr, 
           hc.order = TRUE, 
           type = "lower", 
           lab = TRUE, 
           lab_size = 3, 
           method="circle", 
           colors = c("tomato2", "white", "springgreen3"), 
           title="Korelasi Antara Tahun,\nkm, dan Harga", 
           ggtheme=theme_bw)


draft.1 = ggarrange(chart.1,chart.4,
          ncol = 2,
          nrow = 1,
          widths = c(1,.4))
draft.2 = ggarrange(chart.2,chart.3,
          ncol = 2,
          nrow = 1,
          widths = c(1,1.3))
final = ggarrange(draft.1,draft.2,
                  ncol = 1,
                  nrow = 2,
                  heights = c(1,.8))
ggsave('mobil88.png',width = 12,height = 10,dpi=600)
