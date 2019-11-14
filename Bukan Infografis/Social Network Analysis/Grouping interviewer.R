rm(list=ls())

#bikin nama
library(randomNames)
intr = randomNames(20,gender = 'female',which.names = 'first')
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
target = sample(n,36)

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
sna::closeness(hasil)
sna::betweenness(hasil)
sna::degree(hasil)

tes$nodelist
