# clean the environment
rm(list=ls())

# panggil maha function
source('/cloud/project/All Func.R')

# set working directory
setwd("/cloud/project/nitip sebentar/nitip dulu")

# open the powerpoint
doc = read_pptx('template.pptx')

# bikin slide pertama
tambahin.slide.judul.donk('Time Series Decomposition','Granger Causality')

# kita ambil datanya
url = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vRnPxduyaDGHSqR_Wz39y_bSsN-4rO4hZQoRkd6HXNviSw4eEE3mp71kzdmm2eDbxIolzWaPIMyYtMB/pubhtml'
data = read_html(url) %>% html_table()
data = data[[1]]
colnames(data) = data[1,]
data = data[-1,]

# all market all parent
tes = 
  data %>%
  mutate(bulan = as.numeric(bulan),
         tahun = as.numeric(tahun)) %>%
  filter(tahun<=2018) %>%
  group_by(bulan,tahun) %>%
  summarise(value = sum(as.numeric(value))) %>%
  arrange(tahun,bulan)
View(tes)

tambahin.slide.pemisah.donk('Market Trends',
                            'All Parents dan All Brands')

all = ts(tes$value,start=c(2014,1),frequency = 12)
all
str(all)
summary(all)
decompose=stl(all,s.window='periodic')
decompose
decompose=data.frame(decompose$time.series)
seasonal=decompose$seasonal
trend=decompose$trend
remainder=decompose$remainder

hasil = data.frame(seasonal,trend,decompose,
                   bulan = tes$bulan,
                   tahun = tes$tahun)
hasil %>% ggplot(aes(x=paste(bulan,tahun,sep='-'),
                     y=trend)) +
  geom_line(group=1) + theme(axis.text.x = element_text(angle=90))
ggsave('Decompose.png')

tambahin.slide.ending.donk()
export.powerpoint.saya.donk('hasil sementara')