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

# INTERSTELLAR
url = 'https://en.wikipedia.org/wiki/Interstellar_(film)'
inter =read_html(url) %>% html_nodes('.column-width:nth-child(15) a') %>% html_text()
inter = combn(inter,2,simplify = T)
inter = data.frame(from = inter[1,],
                   to = inter[2,],
                   film = 'INTERSTELLAR')

# TDKR
url = 'https://en.wikipedia.org/wiki/The_Dark_Knight_Rises'
TDKR = read_html(url) %>% html_nodes('h2+ ul li > a:nth-child(1)') %>% html_text()
TDKR = combn(TDKR,2,simplify = T)
TDKR = data.frame(from = TDKR[1,],
                  to = TDKR[2,],
                  film = 'The Dark Knight Rises')

# INCEPTION
url = 'https://en.wikipedia.org/wiki/Inception'
incep = read_html(url) %>% html_nodes('.tright+ ul li > a:nth-child(1)') %>% html_text()
incep = combn(incep,2,simplify = T)
incep = data.frame(from = incep[1,],
                   to = incep[2,],
                   film = 'INCEPTION')

# The Dark Knight
url = 'https://en.wikipedia.org/wiki/The_Dark_Knight_(film)'
tdk = read_html(url) %>% html_nodes('tr:nth-child(8) a') %>% html_text()
tdk = tdk[1:7]
tdk = combn(tdk,2,simplify = T)
tdk = data.frame(from = tdk[1,],
                 to = tdk[2,],
                 film = 'The Dark Knight')

# The Prestige
url = 'https://en.wikipedia.org/wiki/The_Prestige_(film)'
prestige = read_html(url) %>% html_nodes('tr:nth-child(7) li') %>% html_text()
prestige = prestige[1:7]
prestige = combn(prestige,2,simplify = T)
prestige = data.frame(from = prestige[1,],
                      to = prestige[2,],
                      film = 'The Prestige')

# Gabung DATA
DATA = rbind(tenet,dunkirk)
DATA = rbind(DATA,inter)
DATA = rbind(DATA,TDKR)
DATA = rbind(DATA,incep)
DATA = rbind(DATA,tdk)
DATA = rbind(DATA,prestige)
DATA = distinct(DATA)

DATA %>% 
  graph_from_data_frame() %>%
  ggraph(layout = 'kk') +
  theme_void() +
  geom_edge_link(aes(color = film),
                 show.legend = F) +
  geom_node_point(color='darkgreen',size=1) +
  geom_node_text(aes(label=name),size=3) +
  labs(title = 'FILM ARAHAN CHRISTOPHER NOLAN',
       subtitle = 'base: aktor dan aktris yang bermain dalam film') +
  theme(plot.title = element_text(size=15,face='bold'))
