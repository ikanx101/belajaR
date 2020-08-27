rm(list=ls())

library(dplyr)
library(tidyr)
library(tidytext)
library(htmlwidgets)

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
wc = wordcloud2::wordcloud2(tes)

saveWidget(wc,"1.html",selfcontained = F)
webshot::webshot("1.html","wordcloud.png",vwidth = 1200, vheight = 1000, delay = 30)

# mulai NLP
library(NLP)
library(tm)

NAME = new$baca
NAME = Corpus(VectorSource(NAME))
tdm = TermDocumentMatrix(NAME)

# bikin fungsi asosiasi
asosiasi = function(kata,angka){
  kata_1 = findAssocs(tdm, kata, angka)
  kata_1 = unlist(kata_1)
  kata_1 = data.frame(kata.awal = attributes(kata_1)$names,
                      korel = kata_1) %>% 
    mutate(kata.awal = as.character(kata.awal)) %>%
    separate(kata.awal,into=c('word1','word2'),sep='\\.')
  return(kata_1)
}


kata = tes %>% arrange(desc(n)) %>% head(2)
kata = kata$words
i = 1
data = asosiasi(kata[i],.9501)
for(i in 2:length(kata)){
  temp = asosiasi(kata[i],.9501)
  data = rbind(data,temp)
}

library(igraph)
library(ggraph)

data %>% 
  rename(n = korel) %>% 
  graph_from_data_frame() %>%
  ggraph(layout = 'star') +
  geom_edge_link(aes(edge_alpha=n),
                show.legend = F,
                color='darkred') +
  geom_node_point(size=1,color='steelblue') +
  geom_node_text(aes(label=name),alpha=0.4,size=3,vjust=1,hjust=1) +
  theme_void()

