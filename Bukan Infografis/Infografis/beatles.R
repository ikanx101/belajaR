rm(list=ls())
setwd('D:/Project_R/Kamis Data/The Beatles')

#enjoy the library
library(rvest)
library(dplyr)
library(tidyr)
library(ggplot2)
library(tidytext)
library(ggpubr)
library(igraph)
library(ggraph)

#ambil semua links dari lagu the beatles
url = 'https://www.lyricsfreak.com/b/beatles/'

link = read_html(url) %>% html_nodes('.lf-link--primary') %>% html_attr('href')
data_awal = tibble(
  link = link,
  id = c(1:length(link))
  ) %>% filter(grepl('beatles',link,ignore.case = T))

data_awal$link = paste('https://www.lyricsfreak.com',data_awal$link,sep='')

#fungsi untuk ambil lirik lagu nya
scrap_lirik = function(url){
  data = read_html(url) %>% {
    tibble(
      judul = html_nodes(.,'.lyric-song-head') %>% html_text(),
      lirik = html_nodes(.,'#content') %>% html_text()
    )
  } %>% 
    mutate(judul = gsub("\\'",' ',judul),
           judul = janitor::make_clean_names(judul),
           judul = gsub('\\_',' ',judul),
           lirik = gsub("\\'",' ',lirik),
           lirik = janitor::make_clean_names(lirik),
           lirik = gsub('\\_',' ',lirik))
  return(data)
}

#kita mulai scrap datanya
url = data_awal$link
i = 1
data = scrap_lirik(url[i])
data$id = i

for(i in 2:length(url)){
  temp = scrap_lirik(url[i])
  temp$id = i
  data = rbind(data,temp)
}

#bebersih
data = data %>% mutate(judul = gsub(' lyrics','',judul))

#final data
data
write.csv(data,'the beatles.csv')

#kita liat dulu berapa banyak lagu yang ditulis dari sudut pandang pertama
song_without_i = data %>% unnest_tokens('words',lirik) %>% 
  filter(words=='i' | words=='me' | words=='my') %>% distinct()
song_without_i = song_without_i$id

song_without_i = data %>% filter(!id %in% song_without_i)

data.frame(label=c('1st person pov','not 1st person pov'),value=c(200-22,22)) %>%
  mutate(percent=100*value/sum(value)) %>% 
  ggplot(aes(x=label,y=percent)) +
  geom_col(fill='white',color='blue',size=1) +
  theme_pubclean() +
  geom_label(aes(label=paste(value,'lagu',sep=' ')),size=4) +
  labs(title = 'Apa benar bahwa semua lagu the Beatles ditulis dari 1st person POV?',
       subtitle = 'source: Semua lagu yang bisa diambil dari www.lyricsfreak.com',
       caption = 'Scraped and Visualised\nusing R\ni k A n x') +
  theme(plot.title = element_text(size = 18,face='bold.italic'),
        axis.title = element_blank(),
        axis.text.x = element_text(size = 14,face='bold'),
        axis.text.y = element_blank(),
        plot.caption = element_text(size=11,face='italic'))
ggsave('the beatles.png',width = 10,height = 8)


#sekarang kita liat text mining
sensor = c('a','s','t','m','ll','re','ve','d','mm','ah','ain','didn','la')
data %>% unnest_tokens('words',lirik) %>% count(words,sort=T) %>%
  filter(!words %in% sensor) %>% head(50) %>% 
  ggplot(aes(x=reorder(words,n),y=n)) +
  geom_col(fill='white',color='blue',size=.4) +
  theme_pubclean() +
  coord_flip() +
  geom_label(aes(label=n),size=2) +
  labs(title = 'Kata apa saja yang sering digunakan oleh the Beatles?\nTop 50 Words',
       subtitle = 'source: Semua lagu yang bisa diambil dari www.lyricsfreak.com',
       caption = 'Scraped and Visualised\nusing R\ni k A n x') +
  theme(plot.title = element_text(size = 18,face='bold.italic'),
        axis.title = element_blank(),
        axis.text.y = element_text(size = 10,face='bold'),
        axis.text.x = element_blank(),
        plot.caption = element_text(size=11,face='italic'))
ggsave('lirik beatles.png',width = 10,height = 8)

#world cloud
tes = 
data %>% unnest_tokens('words',lirik) %>% count(words,sort=T) %>%
  filter(!words %in% sensor) %>% head(200)

word = 
wordcloud2::wordcloud2(tes,
                       color = "random-dark", 
                       backgroundColor = "white",
                       shape = 'cardioid',
                       fontFamily = "Miso",
                       size=2)
htmlwidgets::saveWidget(word,'dummy.html',selfcontained = F)
webshot::webshot('dummy.html',"wordcloud.png", delay =5, vwidth = 1000, vheight=1000)

#bigrams
data %>% unnest_tokens('words',lirik) %>%
  filter(!words %in% sensor) %>%
  group_by(judul) %>%
  summarise(lirik = stringr::str_c(words,collapse = ' ')) %>%
  unnest_tokens(bigram,lirik,token='ngrams',n=2) %>%
  count(bigram,sort=T) %>% 
  separate(bigram,into=c('word1','word2'),sep=' ') %>%
  filter(n>30) %>%
  graph_from_data_frame() %>%
  ggraph(layout = 'fr') +
  theme_pubclean() +
  geom_edge_link(aes(edge_alpha=n),
                 show.legend = F,
                 color='darkred') +
  geom_node_point(size=1,color='steelblue') +
  geom_node_text(aes(label=name),repel=T,size=3,vjust=1,hjust=1) +
  theme_void()
ggsave('bigrams bitels.png',width = 6,height = 4)
