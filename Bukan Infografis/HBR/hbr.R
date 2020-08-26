rm(list=ls())

library(dplyr)
library(tidytext)

# --------------------------------------------------
# baca artikel
load("artikel hbr.rda")
# bersihin
data = 
  temp %>% 
  mutate(baca_new = janitor::make_clean_names(baca_new),
         baca_new = gsub("\\_"," ",baca_new))

# --------------------------------------------------
# english stopwords
stop = readLines("https://raw.githubusercontent.com/stopwords-iso/stopwords-en/master/stopwords-en.txt")

# --------------------------------------------------
# function stem
stem_hunspell = function(term) {
  # look up the term in the dictionary
  stems <- hunspell::hunspell_stem(term)[[1]]
  
  if (length(stems) == 0) { # if there are no stems, use the original term
    stem <- term
  } else { # if there are multiple stems, use the last one
    stem <- stems[[length(stems)]]
  }
  stem
}

stem_bro = function(kata){
  corpus::text_tokens(kata,stemmer=stem_hunspell)
  }

# --------------------------------------------------
# stemming dan cleaning terhadap data
new = 
  data %>% select(id,baca_new) %>% 
  unnest_tokens("words",baca_new) %>% 
  mutate(words = ifelse(words == "m","am",words),
         words = ifelse(words == "ll","will",words),
         words = ifelse(words == "ve","have",words),
         words = ifelse(words == "isn","is",words),
         words = ifelse(words == "t","not",words)) %>% 
  filter(!words %in% stop) %>% 
  mutate(words = sapply(words, stem_bro)) %>% 
  group_by(id) %>% 
  summarise(baca = stringr::str_c(words,collapse = " ")) 
  
tes = new %>% unnest_tokens("words",baca) %>% group_by(words) %>% summarise(n = n())
wordcloud2::wordcloud2(tes)

NAME = new$baca
NAME=gsub("[^\x01-\x7F]", "", NAME) #menghilangkan emoticons
NAME=iconv(NAME, "latin1", "ASCII", sub="") #MENGHILANGKAN karakter non ascii
NAME=Corpus(VectorSource(NAME))
NAME = tm_map(NAME, content_transformer(tolower))
NAME = tm_map(NAME,removePunctuation)
NAME= tm_map(NAME, stripWhitespace)
NAME=tm_map(NAME,removeWords, stopwords("en"))
NAME=tm_map(NAME,removeNumbers)

