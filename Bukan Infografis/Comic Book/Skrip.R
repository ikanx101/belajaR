rm(list=ls())

url = 'https://en.m.wikipedia.org/wiki/List_of_superhero_debuts'

library(rvest)
library(dplyr)
library(ggplot2)
library(igraph)
library(ggraph)
library(tidytext)
library(tidyr)

tabel=
  read_html(url) %>%
  html_table(fill = T)

i=1
data = tabel[[i]]
colnames(data) = janitor::make_clean_names(colnames(data))
data = data %>% select(contains('character'),
                       contains('creator'))
colnames(data) = c('character','creator')

for(i in 2:length(tabel)){
  temp = tabel[[i]]
  colnames(temp) = janitor::make_clean_names(colnames(temp))
  temp = temp %>% select(contains('character'),
                         contains('creator'))
  colnames(temp) = c('character','creator')
  data = rbind(data,temp)
}
data
