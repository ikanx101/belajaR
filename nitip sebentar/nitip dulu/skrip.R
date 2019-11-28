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
url = 'lalala yeyeyeye lalalala'
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
png(filename = 'decompose sweetener market.png',
    res = 10)
plot(decompose)
dev.off()

decompose=data.frame(decompose$time.series)
decompose
seasonal=decompose$seasonal
trend=decompose$trend
remainder=decompose$remainder

hasil = data.frame(id=c(1:length(seasonal)),
                   seasonal,
                   trend,
                   remainder)

library(scales)
hasil %>% mutate(id = as.factor(id)) %>%
  ggplot(aes(x=id,y=trend)) +
  geom_line(group=1) +
  scale_y_continuous(labels = comma) +
  theme(axis.text.x = element_text(angle=90))
ggsave('Decompose.png',width=10,height=8,dpi=450)

tambahin.slide.ending.donk()
export.powerpoint.saya.donk('hasil sementara')