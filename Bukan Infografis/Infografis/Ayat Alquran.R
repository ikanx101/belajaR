setwd('D:/Project_R/Kamis Data/Ar Rahman')
rm(list=ls())

#situsnya di mari
url='https://litequran.net/al-maidah'

library(tidyverse)
library(rvest)

#scrap data
data = read_html(url) %>% {
  tibble(
    arti = html_nodes(.,'.arti') %>% html_text(),
    ayat = c(1:length(arti))
  )
}

#kata yang akan disensor
sensor=c('di','ke','dan','dari','yang','apa','jika','akan',
         'itu','dengan','nya','pada','untuk','bahwa','agar',
         'lalu','setelah','itulah','atau','adalah','pun','tentang','ku',
         'pula','sebagai','al','an','qur','saja','ya','lagi','terhadap','ini',
         'kepada')

#kita bebersih ya
library(tidytext)
data %>% mutate(arti = gsub('[[:punct:]]',' ',arti),
                arti = tolower(arti)) %>%
  unnest_tokens(words,arti) %>% filter(!words %in% sensor) %>% 
  count(words,sort=T) %>% filter(n>10) %>%
  ggplot(aes(x=reorder(words,-n),y=n)) + 
  geom_bar(stat='identity',alpha=.1) +
  geom_text(aes(label=n),color='darkred',size=1) +
  theme_classic() +
  theme(axis.text.x = element_text(angle=90,size=4))
ggsave('Al Maidah.png',width = 10,height = 7)


#bikin bigrams
library(igraph)
library(ggraph)
data %>% mutate(arti = gsub('[[:punct:]]',' ',arti),
                arti = tolower(arti)) %>%
  unnest_tokens(words,arti) %>% filter(!words %in% sensor) %>%
  group_by(ayat) %>%
  summarise(arti = stringr::str_c(words,collapse = ' ')) %>% #perhatikan penggunaan dari stringr::str_c yah!!
  unnest_tokens(bigram,arti,token='ngrams',n=2) %>%
  count(bigram,sort=T) %>%
  separate(bigram,into=c('word1','word2'),sep=' ') %>%
  filter(n>7) %>% graph_from_data_frame() %>%
  ggraph(layout = 'fr') +
  geom_edge_link(aes(edge_alpha=n),
                 show.legend = F,
                 arrow = grid::arrow(type='closed',
                                     length = unit(.1,'inches')),color='darkred') +
  geom_node_point(size=1,color='steelblue') +
  geom_node_text(aes(label=name),size=4,vjust=1,hjust=1) +
  theme_void()
ggsave('Al Maidah bigrams.png',width = 10,height = 7)
