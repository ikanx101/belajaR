rm(list=ls())
setwd("~/Documents/belajaR/Bukan Infografis/HBR")

library(dplyr)
library(tidyr)
library(tidytext)
library(htmlwidgets)
library(igraph)
library(ggraph)

# --------------------------------------------------
# baca artikel
load("artikel hbr.rda")
# bersihin
data = 
  data %>% 
  mutate(id = c(1:length(links)),
         baca_new = janitor::make_clean_names(baca_new),
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
  data %>% select(id,kategori,baca_new) %>% 
  unnest_tokens("words",baca_new) %>% 
  mutate(words = ifelse(words == "m","am",words),
         words = ifelse(words == "ll","will",words),
         words = ifelse(words == "ve","have",words),
         words = ifelse(words == "isn","is",words),
         words = ifelse(words == "t","not",words)) %>% 
  filter(!words %in% stop) %>% 
  mutate(words = sapply(words, stem_bro)) %>% 
  group_by(id,kategori) %>% 
  summarise(baca = stringr::str_c(words,collapse = " ")) %>% 
  ungroup()

save(new,file = "clean.rda")  


# cukup sampai di atas
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


kata = tes %>% arrange(desc(n)) %>% head(5)
kata = kata$words
i = 1
k = .9
data = asosiasi(kata[i],k)
for(i in 2:length(kata)){
  temp = asosiasi(kata[i],k)
  data = rbind(data,temp)
}


data %>% 
  rename(n = korel) %>% 
  graph_from_data_frame() %>%
  ggraph(layout = 'kk') +
  geom_edge_link(aes(edge_alpha=n),
                show.legend = F,
                color='darkred') +
  geom_node_point(size=1,color='steelblue') +
  geom_node_text(aes(label=name),alpha=0.4,size=3,vjust=1,hjust=1) +
  theme_void()


#### topic modelling
dtm = as.DocumentTermMatrix(tdm) 
rowTotals = apply(dtm , 1, sum) 
dtm = dtm[rowTotals> 0, ]           
library(topicmodels)
lda = LDA(dtm, k = 5)  
term = terms(lda, 10)  
term = apply(term, MARGIN = 2, paste, collapse = ",")
cbind(term)

# bikin ke data frame
hasil = data.frame(topic = attributes(term)$names,
                   term = "a")
for(i in 1:5){
  hasil$term[i] = unlist(term)[[i]]
}

hasil = 
  hasil %>% 
  unnest_tokens(kata,term,token = "regex",pattern = "\\,")

kata = unique(hasil$kata)

k = .5
data = asosiasi(kata[i],k)
for(i in 2:length(kata)){
  temp = asosiasi(kata[i],k)
  data = rbind(data,temp)
}

chart = 
  data %>% 
  filter(word2 %in% kata) %>% 
  rename(n = korel) %>% 
  mutate(size_n = round(n*10,0)) %>% 
  graph_from_data_frame() %>%
  ggraph(layout = 'kk') +
  geom_edge_fan(aes(edge_colour=size_n,edge_alpha=size_n),
                 show.legend = F) +
  geom_node_point(shape=21,size=2.5,color='steelblue') +
  geom_node_label(aes(label=name),size = 3,alpha=0.7,repel = T,family="serif") +
  theme_graph()
ggsave("topic modelling.png",dpi = 450,width = 7,height = 6)



c("layout_with_dh", "layout_with_drl", "layout_with_fr", 
  "layout_with_gem", "layout_with_graphopt", "layout_with_kk", 
  "layout_with_lgl", "layout_with_mds", "layout_with_sugiyama",
  "layout_as_bipartite", "layout_as_star", "layout_as_tree")


c("geom_edge_arc", "geom_edge_arc0", "geom_edge_arc2", "geom_edge_density", 
  "geom_edge_diagonal", "geom_edge_diagonal0", "geom_edge_diagonal2", 
  "geom_edge_elbow", "geom_edge_elbow0", "geom_edge_elbow2", "geom_edge_fan", 
  "geom_edge_fan0", "geom_edge_fan2", "geom_edge_hive", "geom_edge_hive0", 
  "geom_edge_hive2", "geom_edge_link", "geom_edge_link0", "geom_edge_link2", 
  "geom_edge_loop", "geom_edge_loop0")


edge_colour (colour of the edge)
edge_width (width of the edge)
edge_linetype (linetype of the edge, defaults to “solid”)
edge_alpha (opacity; a value between 0 and 1)

c("geom_node_arc_bar", "geom_node_circle", "geom_node_label", 
  "geom_node_point", "geom_node_text", "geom_node_tile", "geom_node_treemap")