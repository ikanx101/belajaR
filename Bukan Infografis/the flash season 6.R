setwd("/cloud/project/Bukan Infografis/the Flash")
rm(list=ls())

library(rvest)
library(tidyverse)
library(ggplot2)
library(igraph)
library(ggraph)
library(tidytext)
library(wordcloud2)
library(htmlwidgets)

#ambil jalan cerita
url = 'https://en.wikipedia.org/wiki/The_Flash_(season_6)'
sinopsis = 
  read_html(url) %>% html_nodes('.description') %>% html_text()

data = data.frame(eps=c(1:7),sinopsis)

data
#wordcloud
d = 
data %>% mutate(sinopsis = as.character(sinopsis),
                sinopsis = tolower(sinopsis)) %>%
  unnest_tokens(words,sinopsis) %>%
  count(words,sort=T) %>%
  filter(!words %in% c('a','an','the','to','of','at','and','into','her',
                       'his','he','she','in','is','it','him')) %>%
  filter(n>2)

word = 
wordcloud2(d, 
           color = "random-dark", 
           backgroundColor = "white",
           shape = 'star',
           fontFamily = "Miso",
           size=1)
saveWidget(word,'dummy.html',selfcontained = F)
library(webshot)
webshot('dummy.html',"wordcloud.png", delay =5, vwidth = 700, vheight=600)

#bigrams
data %>% mutate(sinopsis = as.character(sinopsis),
                sinopsis = tolower(sinopsis)) %>%
  unnest_tokens(words,sinopsis) %>%
  filter(!words %in% c('a','an','the','to','of','at','and','into','her',
                       'his','he','she','in','is','it','him','p')) %>%
  group_by(eps) %>%
  summarise(sinopsis = stringr::str_c(words,collapse = ' ')) %>%
  unnest_tokens(bigram,sinopsis,token='ngrams',n=2) %>%
  count(bigram,sort=T) %>% filter(bigram>1) %>%
  separate(bigram,into=c('word1','word2'),sep=' ') %>%
  graph_from_data_frame() %>%
  ggraph(layout = 'kk') +
  theme_pubclean() +
  geom_edge_link(aes(edge_alpha=n),
                 show.legend = F,
                 color='darkred') +
  geom_node_point(size=1,color='steelblue') +
  geom_node_text(aes(label=name),size=3,vjust=1,hjust=1) +
  theme_void()
ggsave('the flash season 6.png',width = 10,height = 7)
