setwd('D:/Project_R/Kamis Data/bps rokok')

library(readxl)

kelompok = c('Kuintil 1',
             'Kuintil 2',
             'Kuintil 3',
             'Kuintil 4',
             'Kuintil 5')

thn.2015 = c(26.91,31.70,32.47,32.07,27.28)
thn.2016 = c(26.16,29.63,31.39,30.48,27.14)
thn.2017 = c(27.63,30.26,31.22,30.83,26.44)
thn.2018 = c(32.57,33.52,33.41,32.56,28.96)

data = data.frame(kelompok = as.factor(kelompok),
                  thn.2015,
                  thn.2016,
                  thn.2017,
                  thn.2018)

chart.1 = 
data %>% reshape2::melt(id.vars='kelompok') %>% 
  mutate(variable = case_when(variable=='thn.2015'~'Tahun 2015',
                              variable=='thn.2016'~'Tahun 2016',
                              variable=='thn.2017'~'Tahun 2017',
                              variable=='thn.2018'~'Tahun 2018')) %>%
  ggplot(aes(x=variable,y=value,group=kelompok)) + 
  theme_economist() +
  geom_line(aes(color=kelompok),size=1.1) +
  scale_color_brewer(palette = 'Set1') +
  labs(title = 'Persentase Merokok Pada Penduduk Umur di atas 15 Tahun\nMenurut Kelompok Pengeluaran (Persen)',
       subtitle = 'source: Susenas bps.go.id',
       color = 'Kelompok pengeluaran\npenduduk') +
  geom_label_repel(aes(label = value),size=2.5) +
  theme(axis.title = element_blank(),
        panel.grid = element_blank(),
        axis.text.y = element_blank(),
        legend.position = 'bottom',
        plot.title = element_text(face='bold.italic',size=15),
        plot.subtitle = element_text(face='bold'))

umur = c('15-19',
         '20-24',
         '25-29',
         '30-34',
         '35-39',
         '40-44',
         '45-49',
         '50-54',
         '55-59',
         '60-64',
         '65+')
persen = c('20.59',
           '33.41',
           '34.98',
           '36.66',
           '36.23',
           '35.69',
           '34.56',
           '33.28',
           '32.78',
           '30.22',
           '24.38')

data = data.frame(umur,persen=as.numeric(persen))

chart.2 = 
data %>% ggplot(aes(x=umur,y=persen)) + 
  theme_economist() +
  geom_line(group=1,color='steelblue',size=1.5) +
  geom_label(aes(label=persen),size=2.5) +
  labs(title = 'Persentase Merokok Pada Penduduk Umur di atas 15 Tahun\nMenurut Kelompok Umur (Persen)',
       subtitle = 'source: Susenas bps.go.id',
       caption = 'Scraped and Visualized\nusing R\ni k A n x') +
  theme(axis.title = element_blank(),
        axis.text.y = element_blank(),
        legend.position = 'bottom',
        panel.grid = element_blank(),
        plot.title = element_text(face='bold.italic',size=15),
        plot.subtitle = element_text(face='bold'),
        plot.caption = element_text(face='italic',size=10))

library(ggpubr)
ggarrange(chart.1,chart.2,
          ncol = 2,
          nrow = 1,
          heights = c(.6,.5))

ggsave('rokok 1.png',width = 13.66,height = 7.68,dpi=900)
