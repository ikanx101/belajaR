rm(list=ls())
setwd("~/Documents/belajaR/Bukan Infografis/Al Quran")

library(dplyr)
library(tidyr)
library(tidytext)

load("alquran.rda")
stop = readLines("https://raw.githubusercontent.com/ikanx101/ID-Stopwords/master/id.stopwords.02.01.2016.txt")

data_pikir = data %>% filter(grepl("pikir",arti,ignore.case = T))

library(katadasaR)

data_pikir = 
  data_pikir %>% 
  unnest_tokens(words,arti) %>% 
  mutate(words = sapply(words,katadasar)) %>% 
  filter(!words %in% stop) %>% 
  group_by(ayat,surah.id) %>% 
  summarise(ayat_all = stringr::str_c(words,collapse = " ")) %>% 
  ungroup()


tes = 
  data_pikir %>% 
  unnest_tokens(words,ayat_all) %>% 
  group_by(words) %>% 
  count() %>% 
  arrange(desc(n)) 


library(htmlwidgets)
#wc = 
  wordcloud2::wordcloud2(tes,
                         color = "random-dark", 
                         backgroundColor = "white",
                         shape = 'star',
                         fontFamily = "Miso",
                         size=2)
#saveWidget(wc,"1.html",selfcontained = F)
#webshot::webshot("1.html","1.png",vwidth = 700, vheight = 500, delay =10)
  
library(igraph)
library(ggraph)
library(tidyr)
  
data_pikir %>% 
  unnest_tokens(bigram,ayat_all,token='ngrams',n=2) %>% 
  count(bigram,sort=T) %>% 
  filter(n>2) %>% 
  separate(bigram,into=c('word1','word2'),sep=' ') %>%
  graph_from_data_frame() %>%
  ggraph(layout = 'linear',circular = TRUE) +
  geom_edge_arc(aes(edge_alpha=n),
                 show.legend = F,
                 color='darkred') +
  geom_node_point(size=1,color='steelblue') +
  geom_node_text(aes(label=name),alpha=0.4,size=3,vjust=1,hjust=1) +
  theme_void()



library(NLP)
library(tm)

NAME = data_pikir$ayat_all
NAME = Corpus(VectorSource(NAME))
tdm = TermDocumentMatrix(NAME)

kata_1 = findAssocs(tdm, "pikir", 0.1)
kata_1 = unlist(kata_1)
kata_1 = data.frame(kata.awal = attributes(kata_1)$names,
                    korel = kata_1)
kata_1 %>% mutate(kata.awal = as.character(kata.awal)) %>%
  separate(kata.awal,into=c('word1','word2'),sep='\\.') %>%
  ggplot(aes(x=reorder(word2,-korel),y=korel)) + geom_col(color='steelblue',fill='white') + 
  geom_label(aes(label=korel),size=3) + theme_pubclean() +
  labs(y='Korelasi',
       title='Kata apa saja yang berkorelasi dengan kata `tropicana`?',
       subtitle = 'source: Youtube DATA API 5 Des 2019 3:56 pm',
       caption = 'https://ikanx101.github.io/') +
  theme(axis.text.y = element_blank(),
        axis.title.x = element_blank())


dtm = as.DocumentTermMatrix(tdm) 
rowTotals = apply(dtm , 1, sum) 
dtm = dtm[rowTotals> 0, ]           
library(topicmodels)
lda = LDA(dtm, k = 5)  
term = terms(lda, 10)  
term = apply(term, MARGIN = 2, paste, collapse = ", ")
cbind(term)
