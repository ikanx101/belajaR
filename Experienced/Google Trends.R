rm(list=ls())
setwd('D:/Project_R/Kamis Data/Google Trends/Wiranto')

#library
library(gtrendsR)
library(ggplot2)
library(dplyr)

#ambil data
brands = c('lomba gambar','lomba mewarnai','HiLo School')
data = gtrends(brands,geo = 'ID')
plot(data)

###################################
#ambil data interest overtime
tabel = data$interest_over_time

tabel %>% mutate(tanggal = as.Date(date),tahun = lubridate::year(tanggal)) %>% filter(tahun>=2016) %>%
  ggplot(aes(x=tanggal,y=hits)) + geom_line(aes(color=keyword,linetype=keyword),size=1) +
  theme_fivethirtyeight() + 
  labs(title = 'Interest Over Time (nilainya dari range 0 - 100)',
       subtitle = 'source: Google Trends area Indonesia',
       caption = 'Scrapped and Visualize using R\n9 Oct 2019 10:20 AM\ni k A n x',
       color = 'Keywords',
       linetype = 'Keywords') +
  theme(plot.caption = element_text(size=10,face='bold'),
        plot.title = element_text(size=25),
        plot.subtitle = element_text(size=14,face='bold.italic'))
ggsave('Gtrends.png',width = 14,height = 8,dpi=500)

###################################
#liat kata yah dari related queries
#kita hanya liat yg hilo school yah
kata = data$related_queries
skul = kata %>% filter(keyword=='HiLo School') %>% select('value')
skul = skul$value
skul = tolower(skul)
skul = gsub('hilo','',skul)
skul = gsub('school','',skul)
skul = gsub('  ',' ',skul)
skul = gsub('  ',' ',skul)

library(NLP)
library(tm)
library(RColorBrewer)
library(SnowballC)
library(wordcloud)
library(wordcloud2)
library(igraph)
library(ggraph)
library(networkD3)

NAME=skul
NAME=Corpus(VectorSource(NAME))
tdm<- TermDocumentMatrix(NAME)
m <- as.matrix(tdm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)

judul='Wordcloud Hasil Pencarian keyword HiLo School.html'
library(htmlwidgets)
my_graph = wordcloud2(d, color = "random-dark", backgroundColor = "white",shape = 'star',fontFamily = "Miso",size=2)
saveWidget(my_graph,judul,selfcontained = F)
library(webshot)
webshot(judul,"wordcloud.png", delay =5, vwidth = 680, vheight=480)

###################################
#liat kata yah dari related queries
#kita hanya liat yg Tropicana Slim yah
kata = data$related_queries
skul = kata %>% filter(keyword=='Tropicana Slim') %>% select('value')
skul = skul$value
skul = tolower(skul)
skul = gsub('tropicana','',skul)
skul = gsub('slim','',skul)
skul = gsub('gay','',skul)
skul = gsub('  ',' ',skul)
skul = gsub('  ',' ',skul)

library(NLP)
library(tm)
library(RColorBrewer)
library(SnowballC)
library(wordcloud)
library(wordcloud2)
library(igraph)
library(ggraph)
library(networkD3)

NAME=skul
NAME=Corpus(VectorSource(NAME))
tdm<- TermDocumentMatrix(NAME)
m <- as.matrix(tdm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)

judul='Wordcloud Hasil Pencarian keyword HiLo School.html'
library(htmlwidgets)
my_graph = wordcloud2(d, color = "random-dark", backgroundColor = "white",shape = 'triangle',fontFamily = "Miso",size=2)
saveWidget(my_graph,judul,selfcontained = F)
library(webshot)
webshot(judul,"wordcloud TS.png", delay =5, vwidth = 680, vheight=480)

###################################
#liat kata yah dari related queries
#kita hanya liat yg NutriSari yah
kata = data$related_queries
skul = kata %>% filter(keyword=='NutriSari') %>% select('value')
skul = skul$value
skul = tolower(skul)
skul = gsub('nutrisari','',skul)
skul = gsub('  ',' ',skul)
skul = gsub('  ',' ',skul)

library(NLP)
library(tm)
library(RColorBrewer)
library(SnowballC)
library(wordcloud)
library(wordcloud2)
library(igraph)
library(ggraph)
library(networkD3)

NAME=skul
NAME=Corpus(VectorSource(NAME))
tdm<- TermDocumentMatrix(NAME)
m <- as.matrix(tdm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)

judul='Wordcloud Hasil Pencarian keyword HiLo School.html'
library(htmlwidgets)
my_graph = wordcloud2(d, color = "random-dark", backgroundColor = "white",shape = 'triangle',fontFamily = "Miso",size=2)
saveWidget(my_graph,judul,selfcontained = F)
library(webshot)
webshot(judul,"wordcloud NS.png", delay =5, vwidth = 680, vheight=480)
