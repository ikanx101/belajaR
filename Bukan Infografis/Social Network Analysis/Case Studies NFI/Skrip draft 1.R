rm(list=ls())

library(rvest)
library(dplyr)
library(ggplot2)

#set working directory
setwd('D:/Project_R/Kamis Data/workplace/Save an')
file = list.files()

#Bikin fungsinya
scrap = function(html){
  nama = read_html(html) %>% 
    html_nodes('#u_0_s a') %>% 
    html_text()
  
  data = data.frame(c(1:length(nama)),nama)
  data = data %>% filter(nama!='')
  nama = unique(data$nama)
  
  tes = combn(nama,2,simplify = T)
  
  source = c()
  target = c()
  
  for(i in 1: (length(tes)/2)){
    dummy = as.character(tes[,i])
    source[i] = dummy[1]
    target[i] = dummy[2]
  }
  hasil = data.frame(source,target)
  return(hasil)
}

data.1 = scrap(file[1])
data.2 = scrap(file[2])
data.3 = scrap(file[3])


final = rbind(data.1,data.2)
final = rbind(final,data.3)
final = final %>% distinct()

library(igraph)
library(ggraph)
graph_from_edgelist(as.matrix(final,nrow=2)) %>% 
  ggraph(layout = 'fr') +
  geom_edge_link(show.legend = F,
                 color='darkred',alpha=.3) +
  geom_node_point(size=1,color='steelblue') +
  geom_node_text(aes(label=name),size=2,vjust=1,hjust=1) +
  theme_void()
ggsave('tes.png',width = 15,height = 11)

graph_from_data_frame(final) %>% 
  ggraph(layout = 'fr') +
  geom_edge_link(show.legend = F,
                 color='darkred',alpha=.3) +
  geom_node_point(size=1,color='steelblue') +
  geom_node_text(aes(label=name),size=2.5,vjust=1,hjust=1) +
  theme_void()
ggsave('tes 2.png',width = 25,height = 21)

#alternatf berikutnya
#Jika ingin membuat matrix dari edge list
library(dils)
final$id=1
hasil.baru = AdjacencyFromEdgelist(final) #membuat matrix dari edgelist
news = hasil.baru$adjacency
colnames(news) = hasil.baru$nodelist
rownames(news) = hasil.baru$nodelist
g <- graph.adjacency(news, weighted=T, mode = 'undirected')
g <- simplify(g)
set.seed(3952)
layout1 <- layout.fruchterman.reingold(g)
png('tes dulu.png',width = 600,height = 400,units = 'px');plot(g, layout=layout1,edge.curved=0.2,vertex.label.cex=0.2,vertex.size=2);dev.off()
