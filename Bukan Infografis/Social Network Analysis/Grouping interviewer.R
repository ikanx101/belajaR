rm(list=ls())

#bikin nama
library(randomNames)
intr = randomNames(30,gender = 'female',which.names = 'first')
hasil = combn(intr,2,simplify = T)
n = length(hasil)/2

from = c()
to = c()

for(i in 1:n){
  dummy = unlist(hasil[,i])
  from[i] = dummy[1]
  to[i] = dummy[2]
}
data = data.frame(id=(1:n),from,to)

#random angka
target = sample(n,60)

#final data
library(dplyr)
final = data %>% filter(id %in% target)
final$id = NULL

#yuk mari
library(igraph)
library(ggraph)
graph_from_data_frame(final) %>%
  ggraph(layout = 'fr') +
  geom_edge_link(color='darkred',alpha=.4) +
  geom_node_point(size=2,color='steelblue') +
  geom_node_text(aes(label=name),size=2) +
  theme_void()
ggsave('interviewer.png',width = 8, height = 7,dpi=700)

library(dils)
final$id=1
tes = AdjacencyFromEdgelist(final)
hasil = tes$adjacency
colnames(hasil) = tes$nodelist
rownames(hasil) = tes$nodelist

library(sna)
close = sna::closeness(hasil)
between = sna::betweenness(hasil)
degree = sna::degree(hasil)
eigen = sna::evcent(hasil)

analisa.hasil = data.frame(nama=tes$nodelist,
                           close,
                           between,
                           degree,
                           eigen)
View(analisa.hasil)

#bikin chart yg sama
g = graph.adjacency(hasil,weighted = T, mode='undirected')
g = simplify(g)
set.seed(3952)
layout1 = layout.fruchterman.reingold(g)
png('between.png',width = 1024,height = 768,units = 'px');plot(g, layout=layout1,edge.curved=0.2,vertex.label.cex=1.25,vertex.size=between/2);dev.off()
png('degree.png',width = 1024,height = 768,units = 'px');plot(g, layout=layout1,edge.curved=0.2,vertex.label.cex=1.25,vertex.size=degree);dev.off()

g
fc = fastgreedy.community(as.undirected(g))
V(g)$color <- ifelse(membership(fc)==1,"red","blue")
png('cluster membership.png',
    width = 1024,
    height = 768,
    units = 'px');plot(g);dev.off()
