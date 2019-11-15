#EXERCISE USING THE SNA PACKAGE
setwd("/cloud/project/Bukan Infografis/Social Network Analysis")

#ini ambil dari tel-u
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

B
#betweeness
betweenness(B)

#density
network(B)
B <- network(B)
network.density(B)
