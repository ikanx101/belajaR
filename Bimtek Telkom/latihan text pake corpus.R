rm(list=ls())
setwd("/cloud/project/Bimtek Telkom")

#libraries
library(dplyr)
library(tidyr)
library(tidytext)
library(ggplot2)
library(wordcloud2)
library(NLP)
library(tm)

#ini stopword bahasa indonesia
stopwords_indo <- readLines("https://raw.githubusercontent.com/masdevid/ID-Stopwords/master/id.stopwords.02.01.2016.txt")

#contoh dokumen
d1="Sekelompok ibu dan kaum perempuan duduk beralaskan rumput lapangan sambil fokus menganyam bambu yang ia genggam ditangan."
d2="Sebagian besar masyarakat rupanya tak mau melewatkan waktu begitu  saja untuk meratapi erupsi."
d3="Lombok memang memiliki sejuta pesona yang mampu menyedot perhatian orang untuk datang berwisata."
d4="Perempuan yang bergelut di dunia kerelawanan akan belajar caranya bertanggung jawab bagi sendiri dan orang lain."
d5="Kami berkoordinasi dan melapor pada posko relawan, kami berkomitmen  siap membantu dengan siaga 24 jam"

teks = c(d1,d2,d3,d4,d5)

NAME=Corpus(VectorSource(teks))
NAME
NAME = tm_map(NAME, content_transformer(tolower))
NAME = tm_map(NAME,removePunctuation)
NAME= tm_map(NAME, stripWhitespace)
#NAME= tm_map(NAME, removeWords, stopwords_indo)
tdm<- TermDocumentMatrix(NAME)
m <- as.matrix(tdm)
m

dtm <- DocumentTermMatrix(NAME)
dtm
m1 = as.matrix(dtm)
m1


#ini mah iseng2 aja yah
library(igraph)
library(ggraph)
rowTotals <- apply(dtm , 1, sum) #Find the sum of words in each Document
dtm<- dtm[rowTotals> 0, ]           #remove all docs without words
cor_g <- cor(as.matrix(dtm))
cor_g <- graph_from_adjacency_matrix(cor_g, mode='undirected', weighted = 'correlation')
cor_edge_list <- as_data_frame(cor_g, 'edges')
only_sig <- cor_edge_list[abs(cor_edge_list$correlation) > .95, ]
src=only_sig$from
target=only_sig$to
library(networkD3)
networkData <- data.frame(src, target)
simpleNetwork(networkData, nodeColour = "red", zoom=T, height=300, width=300,fontSize = 16)