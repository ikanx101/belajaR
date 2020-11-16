rm(list=ls())
library(dplyr)
library(janitor)
library(tidytext)

setwd("~/belajaR/Bukan Infografis/CEO Talks")

data = read.csv("~/belajaR/Bukan Infografis/CEO Talks/ramuan modelling/hasil scrape hbr.csv")
str(data)

data = 
  data %>% 
  select(url,sumber,isi) %>% 
  mutate(label = case_when(
    grepl("leadership|managing|strategy",sumber) ~ "CEO",
    !grepl("leadership|managing|strategy",sumber) ~ "Bukan CEO"
  )
        ) %>% 
  mutate(isi = gsub("\\'","",isi),
         isi = trimws(isi),
         isi = tolower(isi))

dummy = 
  data %>% 
  unnest_tokens("words",isi) %>% 
  group_by(label,words) %>% 
  summarise(freq = n()) %>% 
  ungroup() %>% 
  filter(!words %in% c(stopwords::stopwords(),
                       "you’re","don't","it's","can","can’t",
                       "us","u.s","mia","we","we’ve","we’re",
                       "i'm","i","i’m","19","don’t","it’s","that’s")
         ) %>% 
  arrange(desc(freq))

CEO_200 = 
  dummy %>% 
  filter(label == "CEO") %>% 
  arrange(desc(freq)) %>% 
  head(200) %>% 
  select(words)
CEO_200 = CEO_200$words

bukan_CEO_200 = 
  dummy %>% 
  filter(label != "CEO") %>% 
  arrange(desc(freq)) %>% 
  head(200) %>% 
  select(words)
bukan_CEO_200 = bukan_CEO_200$words

words_400 = c(CEO_200,bukan_CEO_200)

data = 
  data %>% 
  unnest_tokens("words",isi) %>% 
  filter(words %in% words_400) %>% 
  distinct() %>% 
  group_by(label,url) %>% 
  summarise(artikel = paste(words,collapse = " ")) %>% 
  ungroup()
  
save(data,words_400,file = "untuk model.rda")
