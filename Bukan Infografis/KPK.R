rm(list=ls())
library(rvest)

setwd('D:/Project_R/Kamis Data/KPK')

#ambil data dan bebersih
url='https://www.kpk.go.id/id/statistik/penindakan/tpk-berdasarkan-profesi-jabatan'
tabel = read_html(url) %>% html_table(fill = T)
data = tabel[[1]]
colnames(data) = data[1,]
data = data[-1,]
data = melt(data,id.vars = 'JABATAN')
colnames(data) = c('jabatan','tahun','value')
data = data %>% filter(tahun!='JUMLAH') %>% mutate(tahun = as.numeric(as.character(tahun))) %>% 
  mutate(value = as.numeric(as.character(value)))

data %>% group_by(tahun) %>% summarise(sum(value))

target = c('Anggota DPR dan DPRD',
           'Eselon I / II / III',
           'Swasta','Walikota/Bupati dan Wakil')
windows()
png('big fish KPK.png',width = 1000,height = 600,res=100)
data %>% filter(jabatan %in% target) %>%
  ggplot(aes(x=(tahun),y=value)) + geom_line(aes(color=jabatan),size=1) + 
  scale_x_continuous(breaks = c(min(data$tahun):max(data$tahun))) +
  scale_color_brewer(palette = 'Set1') +
  labs(x='Tahun ke tahun',y='Banyaknya orang yang ditangkap') + theme_clean() +
  labs(color='Jabatan') +
  labs(title='Siapa saja `big fish` yang sering ditangkap KPK setiap tahunnya?',subtitle = 'source: situs KPK') +
  theme(plot.subtitle = element_text(face='italic'),plot.title = element_text(size=20)) +
  theme(axis.title.y = element_text(size=13,face='bold')) +
  theme(axis.title.x = element_text(size=13,face='bold'))
dev.off()
