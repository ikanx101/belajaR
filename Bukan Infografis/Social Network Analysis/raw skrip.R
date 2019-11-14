#EXERCISE USING THE SNA PACKAGE
setwd("/cloud/project/Bukan Infografis/Social Network Analysis")

people <- c("dandi", "lala", "reza", "ais", "eci")
people

B <- matrix(
  c(0,1,0,0,1,
    0,0,0,1,1,
    1,1,0,0,1,
    0,1,0,0,1,
    0,1,1,0,0),
  nrow=5,
  ncol=5, dimnames = list(people,people))
B

library(sna)

gplot (B, displaylabels=TRUE)


od <-degree(B, cmode = 'outdegree')
gplot (B, displaylabels=TRUE, vertex.cex = od )

id <-degree(B, cmode = 'indegree')
gplot (B, displaylabels=TRUE, vertex.cex = id )

fr <-degree(B, cmode = 'freeman')
gplot (B, displaylabels=TRUE, vertex.cex = fr)

#closeness
closeness(B)

#betweeness
betweenness(B)

#density
network(B)
B <- network(B)
network.density(B)



library(dils)
combn(10,2)
edgelist <- cbind(expand.grid(letters[1:2], letters[1:2]), runif(4))
AdjacencyFromEdgelist(edgelist)
