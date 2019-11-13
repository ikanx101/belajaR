rm(list=ls())
setwd("/cloud/project/Bimtek Telkom")

#libraries
library(dplyr)
library(tidyr)
library(tidytext)
library(ggplot2)
library(wordcloud2)

#ini stopword bahasa indonesia
stopwords_indo <- readLines("https://raw.githubusercontent.com/masdevid/ID-Stopwords/master/id.stopwords.02.01.2016.txt")

#yuk mari kita mulai yah
string01 = "Budi dan Badu bermain bola di sekolah"
string02 = "Apakah Romi dan Julia saling mencintai saat mereka berjumpa di persimpangan jalan?"

#kita bikin tibbel dari data ini yah
data = tibble(
  id = c(1,2),
  string = c(string01,string02)
)
View(data)

#kita mulai bikin wordcloud yah
clean = 
  data %>% mutate(string = tolower(string)) %>%
  unnest_tokens(words,string) %>% count(words,sort = T) %>% filter(!words %in% stopwords_indo)

library(katadasaR)
katadasaR(clean$words)
tes = sapply(clean$words, katadasaR)

wordcloud2(wc,
           color = "random-dark", 
           backgroundColor = "white",
           shape = 'cardioid',
           fontFamily = "Miso",
           size=2)

