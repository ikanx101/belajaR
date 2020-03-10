rm(list=ls())
library(rvest)
library(dplyr)
library(ggplot2)
library(igraph)
library(ggraph)

# TENET
url = 'https://en.wikipedia.org/wiki/Tenet_(film)'
tenet = read_html(url) %>% html_nodes('.column-width a') %>% html_text()
tenet = tenet[-11]
tenet = combn(tenet,2,simplify = T)
tenet = data.frame(from = tenet[1,],
                   to = tenet[2,],
                   film = 'TENET')

# DUNKIRK
url = 'https://en.wikipedia.org/wiki/Dunkirk_(2017_film)'
dunkirk = read_html(url) %>% html_nodes('ul:nth-child(13) a:nth-child(1)') %>% html_text()
dunkirk = combn(dunkirk,2,simplify = T)
dunkirk = data.frame(from = dunkirk[1,],
                     to = dunkirk[2,],
                     film = 'DUNKIRK')

rbind(tenet,dunkirk) %>% 
  graph_from_data_frame() %>%
  ggraph(layout = 'kk') +
  theme_void() +
  geom_edge_link(aes(color = film),
                 show.legend = F) +
  geom_node_point(color='red',size=1) +
  geom_node_text(aes(label=name),size=3) +
  labs(title = 'SPG dan Sekolah yang Dikunjungi',
       subtitle = 'base: area BODETA') +
  theme(plot.title = element_text(size=15,face='bold'))
